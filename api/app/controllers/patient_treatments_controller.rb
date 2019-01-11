class PatientTreatmentsController < BaseController

  before_filter :find_patient, only: [:show_patient_main,
                                      :show_patient_diagnoses,   :add_patient_diagnoses,
                                      :show_patient_medications, :add_patient_medications,
                                      :show_patient_allergy,
                                      :encounter_full_info,
                                      :show_patient_perio_data_entry,
                                      :add_patient_encounter,
                                      :add_patient_procedure,
                                      :show_patient_procedure,
                                      :add_patient_insurance,
                                      :add_patient_payer,
                                      :guarantor,
                                      :edit_patient_smoking,
                                      :add_patient_medical_history,
                                      :add_patient_advanced_directives,
                                      :encounters,
                                      :procedures
                                     ]

  before_filter :prepare_diagnosis_params,  only: [:create_diagnosis,  :update_diagnosis]
  before_filter :prepare_medication_params, only: [:create_medication, :update_medication]
  before_filter :prepare_allergy_params,    only: [:create_allergy, :update_allegy]
  before_filter :prepare_insurance_params,  only: [:create_insurance]
  before_filter :prepare_guarantor_params,  only: [:update_guarantor]
  before_filter :prepare_procedure_params,  only: [:create_procedure]
  before_filter :prepare_smoking_status_params,     only: [:update_smoking_status]
  before_filter :prepare_advanced_directive_params, only: [:update_advanced_directive]

  def index
    authorize Provider, :provider?
    render json: JSONAPI::Serializer.serialize(current_user.provider.all_patients.where(active: true).offset(params[:data][:page].to_i * 10).limit(10), is_collection: true),
           status: 200
  end

  def search_patients
    authorize Provider, :provider?
    patients = current_user.provider.all_patients.where(or: [{ :first_name.eq  => /^#{params[:data][:part]}/ },
                                                         { :last_name.eq   => /^#{params[:data][:part]}/ }]
                                                   ).offset(params[:data][:page].to_i * 10).limit(10)
    render json: JSONAPI::Serializer.serialize(patients, is_collection: true),
           status: 200
  end

  def active_patients
    authorize Provider, :provider?
    if params[:active] == 'true'
      patients = current_user.provider.all_patients.page(params[:page]).per(10)
    else
      patients = current_user.provider.all_patients.where(active: true).page(params[:page]).per(10)
    end
    render json: JSONAPI::Serializer.serialize(patients, is_collection: true),
           status: 200
  end

  def show_patient_main
    authorize Provider, :provider?
    diactive_ids = @patient.tooth_tables.where(active: false).map(&:id)
    top_teeth    = @patient.tooth_tables.where(:tooth_num.lt => 17)
    bottom_teeth = @patient.tooth_tables.where(:tooth_num.gt => 16).reverse
    procedures   = Procedure.where(tooth_table_id: @patient.tooth_tables.map(&:id))
    encounters   = @patient.encounters
    insurances   = @patient.insurances
    diagnoses    = @patient.diagnoses
    medications  = Medication.where(diagnosis_id: @patient.diagnoses.map(&:id))
    allergies    = @patient.allergies
    email_messages = current_user.draft
    appointments   = current_user.provider.appointments
    smoking_status       = @patient.smoking_statuses.order_by(created_at: :desc)
    past_medical_history = @patient.past_medical_history
    advanced_directive   = @patient.advanced_directive
    render json: { data: {
        diactive_ids: diactive_ids,
        top_teeth:    top_teeth,
        bottom_teeth: bottom_teeth,
        procedures:   procedures,
        encounters:   encounters,
        insurances:   insurances,
        diagnoses:    diagnoses,
        medications:  medications,
        allergies:    allergies,
        email_messages: email_messages,
        appointments: appointments,
        smoking_status: smoking_status,
        past_medical_history: past_medical_history,
        advanced_directive: advanced_directive
    } }, status: 200
  end

  def add_patient_diagnoses
    authorize Diagnosis, :create?
    if params[:data][:diagnosis_id].present?
      diagnosis = Diagnosis.find(params[:data][:diagnosis_id])
      diagnosis_code = diagnosis.diagnosis_code
    else
      diagnosis = Diagnosis.new
      diagnosis_code = DiagnosisCode.find(params[:data][:diagnosis_code_id])
    end
    render json: { data: { diagnosis: diagnosis, diagnosis_code: diagnosis_code } },
           status: 200
  end

  def create_diagnosis
    authorize Diagnosis, :create?
    diagnosis = Diagnosis.create(diagnosis_params)
    if diagnosis.persisted?
      render json: JSONAPI::Serializer.serialize(diagnosis), status: 200
    else
      render json: { errors: diagnosis.errors.full_messages }, status: 422
    end
  end

  def update_diagnosis
    authorize Diagnosis, :update?
    diagnosis = Diagnosis.find(params[:data][:diagnosis][:diagnosis_id])
    if diagnosis.update(diagnosis_params)
      render json: JSONAPI::Serializer.serialize(diagnosis), status: 200
    else
      render json: { errors: diagnosis.errors.full_messages }, status: 422
    end
  end

  def show_patient_medications
    authorize Medication, :show?
    render json: JSONAPI::Serializer.serialize(Portion.all, is_collection: true), status: 200
  end

  def add_patient_medications
    authorize Medication, :create?
    diagnosis  = Diagnosis.find(params[:data][:diagnosis_id])
    medication = params[:data][:medication_id].present? ? Medication.find(params[:data][:medication_id]) : Medication.new
    render json: { data: { diagnosis: diagnosis, medication: medication } }
  end

  def create_medication
    authorize Medication, :create?
    medication = Medication.create(medication_params)
    if medication.persisted?
      render json: JSONAPI::Serializer.serialize(medication), status: 200
    else
      render json: { errors: medication.errors.full_messages }, status: 422
    end
  end

  def update_medication
    authorize Medication, :update?
    medication = Medication.find(params[:data][:medication][:medication_id])
    if medication.update(medication_params)
      render json: JSONAPI::Serializer.serialize(medication), status: 200
    else
      render json: { errors: medication.errors.full_messages }, status: 422
    end
  end

  def create_allergy
    authorize Allergy, :create?
    allergy = Allergy.create(allergy_params)
    if allergy.persisted?
      render json: JSONAPI::Serializer.serialize(allergy), status: 200
    else
      render json: { errors: allergy.errors.full_messages }, status: 422
    end
  end

  def update_allergy
    authorize Allergy, :create?
    params[:data][:allergy][:start_date] = params[:data][:allergy][:start_date].to_time
    allergy = Allergy.find(params[:data][:allergy][:id])
    if allergy.update(allergy_params)
      render json: JSONAPI::Serializer.serialize(allergy), status: 200
    else
      render json: { errors: allergy.errors.full_messages }, status: 422
    end
  end

  def update_smoking_status
    authorize SmokingStatus, :update?
    smoking_status = SmokingStatus.find(params[:data][:smoking_status][:smoking_status_id])
    if smoking_status.update(smoking_status_params)
      render json: JSONAPI::Serializer.serialize(smoking_status), status: 200
    else
      render json: { data: { errors: smoking_status.errors.full_messages } }, status: 422
    end
  end

  def update_medical_history
    authorize PastMedicalHistory, :update?
    med_history = PastMedicalHistory.find(params[:data][:past_medical_history][:id])
    if med_history.update(past_medical_history_params)
      render json: JSONAPI::Serializer.serialize(med_history), status: 200
    else
      render json: { data: { errors: med_history.errors.full_messages } }, status: 422
    end
  end

  def update_advanced_directive
    authorize AdvancedDirective, :update?
    adv_directive = AdvancedDirective.find(params[:data][:advanced_directive][:id])
    if adv_directive.update(adv_directive_params)
      render json: JSONAPI::Serializer.serialize(adv_directive), status: 200
    else
      render json: { data: { errors: adv_directive.errors.full_messages } }, status: 422
    end
  end

  def create_insurance
    authorize :chart, :insurance_show?
    params[:data][:insurance][:patient_id] = params[:data][:patient_id]
    insurance = Insurance.create(insurance_params)
    if insurance.persisted?
      params[:data][:employer][:insurance_id] = insurance.id
      employer = Employer.create(employer_params)
      if employer.persisted?
        params[:data][:subscriber][:insurance_id] = insurance.id
        subscriber = Subscriber.create(subscriber_params)
        if subscriber.persisted?
          render json: JSONAPI::Serializer.serialize(insurance), status: 200
        else
          render json: { data: { errors: subscriber.errors.full_messages } }, status: 422
        end
      else
        render json: { data: { errors: employer.errors.full_messages } }, status: 422
      end
    else
      render json: { data: { errors: insurance.errors.full_messages } }, status: 422
    end
  end

  def create_payer
    authorize :chart, :insurance_show?
    params[:data][:payer][:patient_id] = params[:data][:patient_id]
    payer = Payer.create(payer_params)
    if payer.persisted?
      params[:data][:claim][:payer_id] = payer.id
      claim = Claim.create(claim_params)
      if claim.persisted?
        render json: JSONAPI::Serializer.serialize(payer), status: 200
      else
        render json: { data: { errors: claim.errors.full_messages } }, status: 422
      end
    else
      render json: { data: { errors: payer.errors.full_messages } }, status: 422
    end
  end

  def tooth_activity
    authorize :chart, :perio_update?
    ToothTable.find(params[:data][:id]).update(active: params[:data][:active])
    render json: {}, status: 200
  end

  def show_patient_full_perio
    authorize Provider, :provider?
    tooth = ToothTable.find(params[:data][:id])
    if tooth.active
      render json: JSONAPI::Serializer.serialize(tooth), status: 200
    else
      render json: { data: { notices: ['This tooth is inactive'] } }, status: 422
    end
  end

  def update_full_perio
    authorize :chart, :perio_update?
    errors = []
    tooth = ToothTable.find(params[:data][:tooth_table][:id])
    errors << tooth.errors.full_messages unless tooth.update(fm_f: params[:data][:tooth_table][:fm_f], fm_m: params[:data][:tooth_table][:fm_m])
    params[:data][:tooth_table].each do |field_name, _|
      if %w(pd gm cal mgl).include? field_name
        tooth_field = tooth.send(field_name)
        errors << tooth_field.errors.full_messages unless tooth_field.update(full_tooth_params(field_name))
      end
    end
    if errors.any?
      render json: { data: { errors: errors } }, status: 422
    else
      render json: JSONAPI::Serializer.serialize(tooth), status: 200
    end
  end

  def show_patient_perio_data_entry
    authorize Provider, :provider?
    field = params[:data][:field]
    if %w(pd gm cal mgl).include? field
      top_teeth    = @patient.tooth_tables.where(:tooth_num.gt => 17)
      bottom_teeth = @patient.tooth_tables.where(:tooth_num.lt => 16).reverse
      render json: { data: { patient: @patient, field: field, top_teeth: top_teeth, bottom_teeth: bottom_teeth } },
             status: 200
    else
      render json: {}, status: 200
    end
  end

  def update_tooth
    authorize :chart, :perio_update?
    errors = []
    params[:data][:patient][:tooth_tables].each_with_index do |tooth, index|
      if tooth[:tooth_field].present?
        tooth_field = ToothTable.find(tooth[:id]).tooth_fields.find(tooth[:tooth_field_id])
        errors << tooth_field.errors.full_messages unless tooth_field.update(tooth_params(tooth))
      end
    end
    if errors.any?
      render json: { errors: errors }, status: 422
    else
      render json: {}, status: 200
    end
  end

  def set_tooth_bsp
    authorize :chart, :perio_update?
    if (1..9).to_a.map{ |el| "b_bsp#{el}" }.include?(params[:data][:field_name]) || (1..9).to_a.map{|el| "l_bsp#{el}"}.include?(params[:data][:field_name])
      tooth = ToothTable.find(params[:data][:id])
      bsp = !tooth.send(params[:data][:field_name])
      tooth.update(params[:data][:field_name] => bsp)
      tooth.tooth_fields.update_all(params[:data][:field_name] => bsp)
      render json: {}, status: 200
    else
      render json: { errors: ['Wrong field name'] }, status: 422
    end
  end

  def add_patient_encounter
    authorize Encounter, :create?
    procedures = Procedure.where(:tooth_table_id.in => @patient.tooth_tables.map(&:id))
                          .order_by(:tooth_table_id, date_of_service: :desc)

    render json: JSONAPI::Serializer.serialize(procedures, is_collection: true), status: 200
  end

  def create_patient_encounter
    authorize Encounter, :create?
    params[:data][:encounter][:patient_id] = params[:data][:patient_id]
    encounter = Encounter.create(encounter_params)
    if encounter.persisted?
      params[:data][:vital][:encounter_id] = encounter.id
      vital = Vital.create(vital_params)
      if vital.persisted?
        params[:data][:procedure_completed][:encounter_id]   = encounter.id
        params[:data][:procedure_recommended][:encounter_id] = encounter.id
        Procedure.find(params[:data][:procedure_id]).update(encounter_id: encounter.id)
        ProcedureCompleted.create(procedure_completed_params)
        ProcedureRecommended.create(procedure_recommended_params)
        render json: JSONAPI::Serializer.serialize(encounter), status: 200
      else
        render json: { data: { errors: vital.errors.full_messages } }, status: 422
      end
    else
      render json: { data: { errors: encounter.errors.full_messages } }, status: 422
    end
  end

  def providers
    authorize Provider, :provider?
    providers = if params[:data][:part].present?
                  Provider.where(or: [{first_name: /^#{params[:data][:part]}/}, {last_name: /^#{params[:data][:part]}/}])
                else
                  Provider.limit(10)
                end
    render json: JSONAPI::Serializer.serialize(providers, is_collection: true), status: 200
  end

  def diagnosis_codes
    authorize Provider, :provider?
    diagnosis_codes = if params[:data][:part].present?
                        DiagnosisCode.where(code: /^#{params[:data][:part]}/)
                      else
                        DiagnosisCode.limit(10)
                      end
    render json: JSONAPI::Serializer.serialize(diagnosis_codes, is_collection: true), status: 200
  end

  def procedure_codes
    authorize Procedure, :show?
    procedure_codes = if params[:data][:part].present?
                        PROCEDURE_CODES.select{ |code, _| code.to_s.include?(params[:data][:part]) }
                      else
                        PROCEDURE_CODES.limit(10)
                      end.map{ |code, procedure| { procedure: procedure, code: code} }
    render json: { data: { procedure_codes: procedure_codes } }, status: 200
  end

  def payers
    authorize :chart, :insurance_show?
    payers = if params[:data][:part].present?
               Patient.find(params[:data][:patient_id]).payers.where(name: /^#{params[:data][:part]}/)
             else
               Patient.find(params[:data][:patient_id]).payers.limit(10)
             end
    render json: JSONAPI::Serializer.serialize(payers, is_collection: true), status: 200
  end

  def guarantor
    authorize :chart, :insurance_show?
    render json: JSONAPI::Serializer.serialize(@patient.guarantor), status: 200
  end

  def portions
    authorize Provider, :provider?
    portions = if params[:data][:part].present?
                 Portion.where(drug: /^#{params[:data][:part]}/)
               else
                 Portion.limit(10)
               end
    render json: JSONAPI::Serializer.serialize(portions, is_collection: true), status: 200
  end

  def medications
    authorize Provider, :provider?
    medications = if params[:data][:part].present?
                    Medication.where(:portion_id.in => Portion.where(drug: /^#{params[:data][:part]}/).map(&:id))
                  else
                    Medication.limit(10)
                  end
    render json: JSONAPI::Serializer.serialize(medications, is_collection: true), status: 200
  end

  def encounter_full_info
    authorize Provider, :provider?
    render json: JSONAPI::Serializer.serialize(Encounter.find(params[:data][:id])), status: 200
  end

  def add_patient_procedure
    authorize Procedure, :create?
    procedure_code = params[:data][:code]
    tooth          = @patient.tooth_tables.where(tooth_num: params[:data][:tooth_num]).first
    render json: { data: { procedure_code: procedure_code, tooth: tooth } }, status: 200
  end

  def create_procedure
    authorize Procedure, :create?
    procedure = Procedure.create(procedure_params)
    if procedure.persisted?
      surface = Surface.create(surface_params)
      if surface.persisted?
        pit = Pit.create(pit_params)
        if pit.persisted?
          cusp = Cusp.create(cusp_params)
          if cusp.persisted?
            render json: JSONAPI::Serializer.serialize(procedure), status: 200
          else
            render json: { data: { errors: cusp.errors.full_messages } }, status: 422
          end
        else
          render json: { data: { errors: pit.errors.full_messages } }, status: 422
        end
      else
        render json: { data: { errors: surface.errors.full_messages } }, status: 422
      end
    else
      render json: { data: { errors: procedure.errors.full_messages } }, status: 422
    end
  end

  def update_guarantor
    guarantor = Patient.find(params[:data][:guarantor][:patient_id]).guarantor
    if guarantor.update(guarantor_params)
      render json: JSONAPI::Serializer.serialize(guarantor), status: 200
    else
      render json: { data: { errors: guarantor.errors.full_messages } }, status: 422
    end
  end

  private

  def find_patient
    @patient = Patient.find(params[:data][:patient_id])
  end

  def prepare_diagnosis_params
    params[:data][:diagnosis][:patient_id] = params[:data][:patient_id]
    params[:data][:diagnosis][:start_date] = params[:data][:diagnosis][:start_date].to_time
    params[:data][:diagnosis][:stop_date]  = params[:data][:diagnosis][:stop_date].to_time
  end

  def diagnosis_params
    params.require(:data).require(:diagnosis).permit(
        :patient_id,
        :diagnosis_code_id,
        :start_date,
        :stop_date,
        :acute,
        :terminal,
        :note
    )
  end

  def prepare_medication_params
    params[:data][:medication][:start_date] = params[:data][:medication][:start_date].to_time
    params[:data][:medication][:stop_date]  = params[:data][:medication][:stop_date].to_time
  end

  def medication_params
    params.require(:data).require(:medication).permit(
        :diagnosis_id,
        :shorthand,
        :signature,
        :portion_id,
        :start_date,
        :stop_date,
        :note
    )
  end

  def prepare_allergy_params
    params[:data][:allergy][:patient_id] = params[:data][:patient_id]
    params[:data][:allergy][:start_date] = params[:data][:allergy][:start_date].to_time
  end

  def allergy_params
    params.require(:data).require(:allergy).permit(
        :patient_id,
        :allergen_type,
        :severity_level,
        :onset_at,
        :start_date,
        :active,
        :note
    )
  end

  def tooth_params(tooth)
    tooth.require(:tooth_field).permit(
        :b1,
        :b2,
        :b3,
        :b_bsp1,
        :b_bsp2,
        :b_bsp3,
        :b_bsp4,
        :b_bsp5,
        :b_bsp6,
        :b_bsp7,
        :b_bsp8,
        :b_bsp9,
        :l1,
        :l2,
        :l3,
        :l_bsp1,
        :l_bsp2,
        :l_bsp3,
        :l_bsp4,
        :l_bsp5,
        :l_bsp6,
        :l_bsp7,
        :l_bsp8,
        :l_bsp9
    )
  end

  def full_tooth_params(tooth_field_name)
    params.require(:data).require(:tooth_table).require(tooth_field_name.to_sym).permit(
        :b1,
        :b2,
        :b3,
        :b_bsp1,
        :b_bsp2,
        :b_bsp3,
        :b_bsp4,
        :b_bsp5,
        :b_bsp6,
        :b_bsp7,
        :b_bsp8,
        :b_bsp9,
        :l1,
        :l2,
        :l3,
        :l_bsp1,
        :l_bsp2,
        :l_bsp3,
        :l_bsp4,
        :l_bsp5,
        :l_bsp6,
        :l_bsp7,
        :l_bsp8,
        :l_bsp9
    )
  end

  def encounter_params
    params.require(:data).require(:encounter).permit(
      :provider_id,
      :patient_id,
      :notes,
      :med_completed,
      :patient_education,
      :clinical_summary,
      :to_provider_id,
      :from_provider_id
    )
  end

  def vital_params
    params.require(:data).require(:vital).permit(
        :height_major,
        :height_minor,
        :weight,
        :units_system,
        :bp_left,
        :bp_right,
        :temp,
        :pulse,
        :rr,
        :sat,
        :temp_type,
        :ra_type,
        :blood
    )
  end

  def procedure_completed_params
    params.require(:data).require(:procedure_completed).permit(
        :encounter_id,
        :procedure_code
    )
  end

  def procedure_recommended_params
    params.require(:data).require(:procedure_recommended).permit(
        :encounter_id,
        :procedure_code
    )
  end

  def prepare_procedure_params
    params[:data][:procedure][:date_of_service] = params[:data][:procedure][:date_of_service].to_time
  end

  def procedure_params
    params.require(:data).require(:procedure).permit(
      :tooth_table_id,
      :procedure_code,
      :date_of_service,
      :status
    )
  end

  def surface_params
    params.require(:data).require(:surface).permit(
      :procudure_id,
      :mesial,
      :incisal,
      :distal,
      :lingual,
      :facial,
      :class_five
    )
  end

  def pit_params
    params.require(:data).require(:pit).permit(
      :procudure_id,
      :mesial,
      :mesiobuccal,
      :mesiolingual,
      :distal,
      :distobuccal,
      :distolingual
    )
  end

  def cusp_params
    params.require(:data).require(:cusp).permit(
      :procudure_id,
      :mesiobuccal,
      :mesiolingual,
      :distobuccal,
      :distolingual
    )
  end

  def prepare_guarantor_params
    params[:data][:guarantor][:birth] = params[:data][:guarantor][:birth].to_time
  end

  def guarantor_params
    params.require(:data).require(:guarantor).permit(
      :first_name,
      :middle_name,
      :last_name,
      :gender,
      :social_number,
      :birth,
      :relation,
      :phone,
      :email,
      :street_address,
      :city,
      :state,
      :zip
    )
  end

  def payer_params
    params.require(:data).require(:payer).permit(
      :patient_id,
      :name,
      :plan,
      :plan_type
    )
  end

  def claim_params
    params.require(:data).require(:claim).permit(
      :first_name,
      :middle_name,
      :last_name,
      :street_address1,
      :street_address2,
      :phone,
      :fax,
      :ext1,
      :ext2,
      :city,
      :state,
      :zip,
      :notes
    )
  end

  def prepare_insurance_params
    params[:data][:insurance][:effective_from] = params[:data][:insurance][:effective_from].to_time
    params[:data][:insurance][:effective_to]   = params[:data][:insurance][:effective_to].to_time
    params[:data][:subscriber][:birth]         = params[:data][:subscriber][:birth].to_time
  end

  def insurance_params
    params.require(:data).require(:insurance).permit(
        :patient_id,
        :provider_id,
        :payer_id,
        :worker_compensation,
        :insurance_number,
        :relation,
        :effective_from,
        :effective_to,
        :copay_type,
        :copay_amount,
        :claim,
        :note,
        :active
    )
  end

  def employer_params
    params.require(:data).require(:employer).permit(
      :name,
      :phone,
      :street_address,
      :city,
      :state,
      :zip
    )
  end

  def subscriber_params
    params.require(:data).require(:subscriber).permit(
      :first_name,
      :middle_name,
      :last_name,
      :birth,
      :gender,
      :social_number,
      :phone,
      :street_address,
      :city,
      :state,
      :zip
    )
  end

  def prepare_smoking_status_params
    params[:data][:smoking_status][:effective_from] = params[:data][:smoking_status][:effective_from].to_time
  end

  def smoking_status_params
    params.require(:data).require(:smoking_status).permit(
        :patient_id,
        :status,
        :effective_from
    )
  end

  def past_medical_history_params
    params.require(:data).require(:past_medical_history).permit(
        :patient_id,
        :major_events,
        :ongoing_problems,
        :preventitive_care,
        :nutrition_history,
        :developmental_history
    )
  end

  def prepare_advanced_directive_params
    params[:data][:advanced_directive][:record_date] = params[:data][:advanced_directive][:record_date].to_time
  end

  def adv_directive_params
    params.require(:data).require(:advanced_directive).permit(
        :patient_id,
        :record_date,
        :notes
    )
  end
end
