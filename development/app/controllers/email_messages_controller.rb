class EmailMessagesController < ApplicationController
  layout 'email_messages'
  layout 'email_messages_contacts', only: [:contacts]

  before_filter Proc.new { authorize EmailMessage, :show? }
  skip_before_action :verify_authenticity_token

  def index
    @messages = current_user.inbox.order_by(:created_at).page(0).per(25)
  end

  def new
    @patient = Patient.find(params[:id])
  end

  def create
    patient = Patient.find(params[:email_message][:patient_id])
    email_message = EmailMessage.create(email_message_params.merge({from_id: current_user.user_id_for_email_messages, to: patient.user}))
    if email_message.persisted?
      EmailMessagesMailer.send_message(email_message).deliver if params[:commit] == 'Send'
      flash[:notice] = 'Message created successfully'
      redirect_to show_patient_main_patient_treatments_path(id: patient.id)
    else
      flash[:error] = email_message.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def create_main
    patient = Patient.find(params[:email_message][:patient_id])
    message = EmailMessage.create(email_message_params.merge({from_id: current_user.user_id_for_email_messages, to: patient.user}))
    if message.persisted?
      EmailMessagesMailer.send_message(message).deliver if params[:commit] == 'Send'
      flash[:notice] = 'Message created successfully'
      remote_redirect_to email_messages_path
    else
      flash[:error] = message.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def create_to_practice
    patient  = Patient.find(params[:email_message][:patient_id])
    practice = Provider.find(params[:email_message][:practice_id])
    message1 = EmailMessage.create(email_message_params.merge({from_id: current_user.user_id_for_email_messages, to: patient.user}))
    message2 = EmailMessage.create(email_message_params.merge({from_id: current_user.user_id_for_email_messages, to: practice.user}))

    if message1.present? && message2.present?
      if params[:commit] == 'Send'
        EmailMessagesMailer.send_message(message1).deliver
        EmailMessagesMailer.send_message(message2).deliver
      end
      flash[:notice] = 'Messages created successfully'
      remote_redirect_to email_messages_path
    else
      flash[:error] = "#{message1.errors.full_messages.to_sentence} #{message2.errors.full_messages.to_sentence}"
      redirect_to :back
    end
  end

  def create_from_patient_to_practice
    provider = Provider.find(params[:to_id])
    message = EmailMessage.create(email_message_params.merge({from_id: current_user.user_id_for_email_messages, to: provider.user}))
    if message.persisted?
      EmailMessagesMailer.send_message(message).deliver if params[:commit] == 'Send'
      flash[:notice] = 'Message created successfully'
      remote_redirect_to email_messages_path
    else
      flash[:error] = message.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def create_reply
    original_message = EmailMessage.find(params[:email_message][:message_id])
    to_user = original_message.from
    to_user = Provider.find(params[:practice_id]).user if params[:practice_id].present?
    message = EmailMessage.create(email_message_params.merge({from: original_message.to, to: to_user}))
    if message.persisted?
      EmailMessagesMailer.send_message(message).deliver if params[:commit] == 'Send'
      flash[:notice] = 'Message created successfully'
      remote_redirect_to email_messages_path
    else
      flash[:error] = message.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def new_tab
    params[:amount] ||= 25
    params[:page]   ||= 1
    params[:sort_by] ||= 'created_at'
    if %w(inbox sent draft urgent archive).include? params[:type]
      messages = if params[:sort_by] == 'created_at'
        current_user.send(params[:type]).order_by(:created_at).page(params[:page]).per(params[:amount])
      else
        current_user.send(params[:type]).sort_by{ |message| message.from.person.full_name }.paginate(page: params[:page], per_page: params[:amount])
      end
      render partial: 'tab_container', locals: { messages: messages,
                                                 type:   params[:type],
                                                 amount: params[:amount],
                                                 sort_by: params[:sort_by]
                                               }
    else
      render nothing: true
    end
  end

  def open_message
    @message = EmailMessage.find(params[:id])
  end

  def new_message_to_practice
  end

  def new_message_to_patient
  end

  def forward_message_from_patient
    @message = EmailMessage.find(params[:id])
  end

  def new_message_in_practice
    @practice = Practice.find(params[:practice_id]) if params[:practice_id].present?
  end

  def reply_to_message_in_practice_contacts
    @message = EmailMessage.find(params[:id])
  end

  def forward_message_in_practice_contacts
    @message = EmailMessage.find(params[:id])
  end

  def contacts
    @contacts = current_user.provider.contacts.page(params[:page]).per(25)
  end

  def contacts_pagination
    contacts = current_user.provider.contacts.page(params[:page]).per(25)
    render partial: 'contacts', locals: { contacts: contacts }
  end

  def find_practices
    existed_practice_ids = current_user.provider.contacts.map(&:provider_id)
    practices = if params[:part].present?
                  current_user.provider.all_providers.where(or: [{first_name: /^#{params[:part]}/}, {last_name: /^#{params[:part]}/}])
                else
                  current_user.provider.all_providers.limit(10)
                end.reject{ |practice| existed_practice_ids.include? practice.id }.map{ |practice| { full_name: practice.full_name, id: practice.id } }.to_json
    render json: practices
  end

  def add_contact
    if params[:id].present?
      Contact.create(provider_id: current_user.provider.id,
        # practice_id: params[:id],
        favorite: params[:favorite].present? == true)
      render partial: 'contacts', locals: { contacts: current_user.provider.contacts.join(:practice).order_by{ |contact| contact[:practices][:speciality] }.page(params[:page]).per(25) }, layout: false
    else
      render nothing: true
    end
  end

  def favorite_contact
    if params[:id].present? && params[:favorite].present?
      Contact.find(params[:id]).update(favorite: params[:favorite])
      render nothing: true
    end
  end

  def new_contact
  end

  def message
    render partial: 'message_show', locals: { message: EmailMessage.find(params[:id]) }
  end

  def to_archive
    if params[:ids].present?
      messages = JSON.parse(params[:ids])
      messages.each do |message|
        EmailMessage.find(message['id']).update(archive: true)
      end
    end
    if params[:id].present?
      EmailMessage.find(params[:id]).update(archive: true)
    end
    render nothing: true
  end

  def delete_message
    if params[:ids].present?
      messages = JSON.parse(params[:ids])
      messages.each do |message|
        EmailMessage.find(message['id']).destroy
      end
    end
    if params[:id].present?
      EmailMessage.find(params[:id]).destroy
    end
    render nothing: true
  end

  def mark_as_read
    if params[:ids].present? && params[:read].present?
      messages = JSON.parse(params[:ids])
      messages.each do |message|
        EmailMessage.find(message['id']).update(read: params[:read])
      end
    end
    if params[:id].present? && params[:read].present?
      EmailMessage.find(params['id']).update(read: params[:read])
    end
    render nothing: true
  end

  def search_message
    params[:amount] ||= 25
    params[:page]   ||= 1
    params[:sort_by] ||= 'created_at'
    if %(inbox sent draft urgent archive).include? params[:type]
      user_ids = User.where(email: /^#{params[:part]}/).map(&:id)
      messages = current_user.send(params[:type])
      messages = if 'inbox' == params[:type]
                   messages.where(:from_id.in => user_ids)
                 elsif 'sent' == params[:type]
                   messages.where(:to_id.in => user_ids)
                 else
                   messages.where(or: [{:from_id.in => user_ids}, {:to_id.in => user_ids}])
                 end.page(params[:page]).per(params[:amount])
      render partial: 'tab_container', locals: { messages: messages,
                                                 type:   params[:type],
                                                 amount: params[:amount],
                                                 sort_by: params[:sort_by]
                                               }
    else
      render nothing: true
    end
  end

  def get_subjects
    render json: Subject.pluck(:id, :name).to_json
  end

  def add_subject
    render json: { id: Subject.create(name: params[:name]).id, name: params[:name] }
  end

  def update_subject
    Subject.find(params[:id]).update(name: params[:name].to_s)
    render nothing: true
  end

  def remove_subject
    Subject.find(params[:id]).destroy
    render nothing: true
  end

  def patients
    patients = if params[:part].present?
                 current_user.provider.all_patients.where(or: [{first_name: /^#{params[:part]}/}, {last_name: /^#{params[:part]}/}])
               else
                 current_user.provider.all_patients.limit(10)
               end.map{ |patient| { full_name: patient.full_name, id: patient.id } }.to_json
    render json: patients
  end

  def practices
    params[:is_in_practice] ||= 'true'
    practices = if params[:is_in_practice] == 'true'
                  if params[:part].present?
                    current_user.provider.all_providers.find_all{|p| p.first_name =~ /^#{params[:part]}/ || p.last_name =~ /^#{params[:part]}/}
                  else
                    current_user.provider.all_providers.first(10)
                  end
                else
                  if params[:part].present?
                    current_user.provider.contact_practices.where(or: [{first_name: /^#{params[:part]}/}, {last_name: /^#{params[:part]}/}])
                  else
                    current_user.provider.contact_practices.limit(10)
                  end
                end.map{ |practice| { full_name: practice.full_name, id: practice.id } }.to_json
    render json: practices
  end

  def patient_practices
    providers = if params[:part].present?
                  current_user.patient.provider.all_providers.where(or: [{first_name: /^#{params[:part]}/}, {last_name: /^#{params[:part]}/}])
                else
                  current_user.patient.provider.all_providers.first(10)
                end.map{ |provider| { full_name: provider.full_name, id: provider.id } }.to_json
    render json: providers
  end

  def contacts_practices
    if params[:id].present?
      practice = Practice.find(params[:id])
      if practice.present?
        render json: practice.to_json
      else
        render nothing: true
      end
    else
      render nothing: true
    end
  end

  private

  def email_message_params
    params.require(:email_message).permit(
        :subject_id,
        :body,
        :urgent
    )
  end
end
