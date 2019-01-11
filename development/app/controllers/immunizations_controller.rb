class ImmunizationsController < ApplicationController
  before_filter :find_patient
  before_filter :prepare_params, only: [:create, :update]

  def index
    authorize Immunization, :show?
    @immunizations = @patient.immunizations
  end

  def new
    authorize Immunization, :create?
    @immunization = Immunization.new
  end

  def create
    authorize Immunization
    immunization = Immunization.create(immunization_params)
    if immunization.persisted?
      flash[:notice] = 'Immunization created successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:immunization][:patient_id])
    else
      flash[:error] = immunization.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def edit
    authorize Immunization, :update?
    @immunization = @patient.immunizations.find(params[:id])
  end

  def update
    authorize Immunization
    immunization = @patient.immunizations.find(params[:id])
    if immunization.update(immunization_params)
      flash[:notice] = 'Immunization updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:immunization][:patient_id])
    else
      flash[:error] = immunization.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def name_block
    authorize Immunization, :show?
    if params[:type_general] && params[:type].present?
      @immunization = params[:id].present? ? @patient.immunizations.find(params[:id]) : Immunization.new
      render partial: 'form', locals: { type_general: params[:type_general], type: params[:type] }, layout: nil
    end
  end

  def vaccines
    authorize Immunization, :show?
    vaccines = if params[:part].present?
                    Vaccine.where(name: /^#{params[:part]}/)
                  else
                    Vaccine.limit(10)
                  end.map{ |vaccine| { name: vaccine.name, id: vaccine.id } }
    render json: vaccines
  end

  private

  def find_patient
    @patient = current_user.provider.all_patients.find(params[:immunization][:patient_id])
  end

  def prepare_params
    params[:immunization][:administered_at] = params[:immunization][:administered_at].try(:to_time)
    params[:immunization][:refused_at]      = params[:immunization][:refused_at].try(:to_time)
    params[:immunization][:expiration_at]   = params[:immunization][:expiration_at].try(:to_time)
  end

  def immunization_params
    params.require(:immunization).permit(
        :patient_id,
        :vaccine_id,
        :name,
        :administered_at,
        :refused_at,
        :source_of_information,
        :reason_refused,
        :manufacturer,
        :lot,
        :quantity,
        :dose,
        :unit,
        :expiration_at,
        :route,
        :body_site,
        :funding_source,
        :registry_notification,
        :vfc_class,
        :comments,
        :administered_by_id,
        :ordered_by_id,
        :administered_facility_id,
        :facility_id,
    )
  end
end