class EmailMessagesController < BaseController

  before_filter Proc.new { authorize EmailMessage, :show? }

  def index
    render json: JSONAPI::Serializer.serialize(current_user.inbox.limit(25), is_collection: true), status: 200
  end

  def new
    render json: JSONAPI::Serializer.serialize(Patient.find(params[:data][:id])), status: 200
  end

  def create
    patient = Patient.find(params[:data][:email_message][:patient_id])
    email_message = EmailMessage.create(email_message_params.merge({from: current_user, to: patient.user}))
    if email_message.persisted?
      EmailMessagesMailer.send_message(email_message).deliver if params[:data][:commit] == 'Send'
      render json: JSONAPI::Serializer.serialize(email_message), status: 200
    else
      render json: { errors: email_message.errors.full_messages }, status: 422
    end
  end

  def create_to_practice
    patient  = Patient.find(params[:data][:email_message][:patient_id])
    practice = Provider.find(params[:data][:email_message][:practice_id])
    message1 = EmailMessage.create(email_message_params.merge({from: current_user, to: patient.user}))
    message2 = EmailMessage.create(email_message_params.merge({from: current_user, to: practice.user}))

    if message1.persisted? && message2.persisted?
      if params[:data][:commit] == 'Send'
        EmailMessagesMailer.send_message(message1).deliver_now
        EmailMessagesMailer.send_message(message2).deliver_now
      end
      render json: { data: [message1, message2] }, status: 200
    else
      render json: { errors: email_message.errors.full_messages }, status: 422
    end
  end

  def create_from_patient_to_practice
    practice = Provider.find(params[:data][:email_message][:to_id])
    message = EmailMessage.create(email_message_params.merge({from: current_user, to: practice.user}))
    if message.persisted?
      EmailMessagesMailer.send_message(message).deliver if params[:commit] == 'Send'
      render json: JSONAPI::Serializer.serialize(message), status: 200
    else
      render json: { errors: email_message.errors.full_messages }, status: 422
    end
  end

  def create_reply
    original_message = EmailMessage.find(params[:data][:email_message][:message_id])
    practice_id = params[:data][:email_message][:practice_id]
    to_user = original_message.from
    to_user = Provider.find(practice_id).user if practice_id.present?
    message = EmailMessage.create(email_message_params.merge({from: original_message.to, to: to_user}))
    if message.persisted?
      EmailMessagesMailer.send_message(message).deliver if params[:data][:commit] == 'Send'
      render json: JSONAPI::Serializer.serialize(message), status: 200
    else
      render json: { errors: email_message.errors.full_messages }, status: 422
    end
  end

  def new_tab
    amount  = (params[:data][:amount] || 25).to_i
    page    = (params[:data][:page]   || 1).to_i
    sort_by = params[:data][:sort_by] || 'created_at'
    type    = params[:data][:type]
    if %(inbox sent draft urgent archive).include? type
      messages = if sort_by == 'created_at'
                   current_user.send(type).order_by(:created_at).page(page).per(amount)
                 else
                   current_user.send(type).sort_by{ |message| message.from.person.full_name }.paginate(page: page, per_page: amount)
                 end
      render json: JSONAPI::Serializer.serialize(messages, is_collection: true), status: 200
    else
      render json: { data: { errors: ['Wrong type, should be one of following: inbox, sent, draft, urgent or archive'] } },
             status: 200
    end
  end

  def practice
    render json: JSONAPI::Serializer.serialize(Provider.find(params[:data][:practice_id])), status: 200
  end

  def contacts
    contacts = current_user.provider.contacts.paginate(page: params[:page], per: 25)
    render json: JSONAPI::Serializer.serialize(contacts, is_collection: true), status: 200
  end

  def find_practices
    existed_practice_ids = current_user.provider.contacts.map(&:provider_id)
    practices = if params[:data][:part].present?
                  current_user.provider.all_providers.find_all{|p| p.first_name =~ /^#{params[:data][:part]}/ || p.last_name =~ /^#{params[:data][:part]}/}
                else
                  current_user.provider.all_providers.first(10)
                end.reject{ |practice| existed_practice_ids.include? practice.id }
    render json: JSONAPI::Serializer.serialize(practices, is_collection: true), status: 200
  end

  def add_contact
      contact = Contact.create(provider_id: current_user.provider.id,
                               favorite: params[:data][:favorite].present? == true ? params[:data][:favorite] : false)
      render json: JSONAPI::Serializer.serialize(contact), status: 200
  end

  def favorite_contact
    if params[:data][:contact_id].present? && params[:data][:favorite].present?
      contact = Contact.find(params[:data][:contact_id])
      contact.update(favorite: params[:data][:favorite])
      render json: JSONAPI::Serializer.serialize(contact), status: 200
    else
      render json: { errors: ['contact id or favorite not present'] }, status: 422
    end
  end

  def to_archive
    if params[:data][:message_ids].present?
      messages = params[:data][:message_ids]
      messages.each do |message|
        EmailMessage.find(message['id']).update(archive: true)
      end
    end
    EmailMessage.find(params[:data][:message_id]).update(archive: true) if params[:data][:message_id].present?
    render json: {}, status: 200
  end

  def delete_message
    messages = params[:data][:message_ids]
    if messages.present?
      messages.each do |message|
        EmailMessage.find(message['id']).destroy
      end
    end
    EmailMessage.find(params[:data][:message_id]).destroy if params[:data][:message_id].present?
    render json: {}, status: 200
  end

  def mark_as_read
    if params[:data][:message_ids].present?
      messages = params[:data][:message_ids]
      messages.each do |message|
        EmailMessage.find(message['id']).update(read: params[:data][:read])
      end
    end
    EmailMessage.find(params[:data][:message_id]).update(read: params[:data][:read]) if params[:data][:message_id].present?
    render json: {}, status: 200
  end

  def search_message
    amount = (params[:data][:amount] || 25).to_i
    page   = (params[:data][:page] || 1).to_i
    type   = params[:data][:type]
    part   = params[:data][:part]
    if %(inbox sent draft urgent archive).include? type
      user_ids = User.where(email: /^#{part}/).map(&:id)
      messages = current_user.send(type)
      messages = if 'inbox' == type
                   messages.where(:from_id.in => user_ids)
                 elsif 'sent' == type
                   messages.where(:to_id.in => user_ids)
                 else
                   messages.where(or: [{:from_id.in => user_ids}, {:to_id.in => user_ids}])
                 end.paginate(page: page, per: amount)
      render json: JSONAPI::Serializer.serialize(messages, is_collection: true), status: 200
    else
      render json: { errors: ['Type should be one of following: inbox, sent, draft, urgent or archive'] }, status: 422
    end
  end

  def get_subjects
    render json: JSONAPI::Serializer.serialize(Subject.all, is_collection: true), status: 200
  end

  def add_subject
    name = params[:data][:name]
    if name.present?
      render json: JSONAPI::Serializer.serialize(Subject.create(name: name)), status: 200
    else
      render json: { errors: ["Name can't be blank"] }, status: 422
    end

  end

  def update_subject
    Subject.find(params[:data][:subject_id]).update(name: params[:data][:name])
    render json: {}, status: 200
  end

  def remove_subject
    Subject.find(params[:data][:subject_id]).destroy
    render nothing: true
  end

  def patients
    patients = if params[:data][:part].present?
                 current_user.provider.all_patients.where(or: [{first_name: /^#{params[:data][:part]}/}, {last_name: /^#{params[:data][:part]}/}])
               else
                 current_user.provider.all_patients.limit(10)
               end
    render json: JSONAPI::Serializer.serialize(patients, is_collection: true), status: 200
  end

  private

  def email_message_params
    params.require(:data).require(:email_message).permit(
        :subject_id,
        :body,
        :urgent
    )
  end
end
