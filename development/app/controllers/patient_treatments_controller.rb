class PatientTreatmentsController < ApplicationController
  layout 'patient_treatments'

  before_filter :check_role
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

  def index
    authorize Provider, :provider?
    @patients = current_user.provider.all_patients.where(active: true).paginate(:page => params[:page], :per_page => 10)
  end

  def search_patients
    authorize Provider, :provider?
    patients = current_user.provider.all_patients.where(or: [{first_name: /^#{params[:part]}/}, {last_name: /^#{params[:part]}/}]).page(params[:page]).per(10)
    render partial: 'patient_treatments/patients', locals: { patients: patients }, layout: nil
  end

  def active_patients
    authorize Provider, :provider?
    if params[:active] == 'true'
      patients = current_user.provider.all_patients.page(params[:page]).per(10)
    else
      patients = current_user.provider.all_patients.where(active: true).page(params[:page]).per(10)
    end
    render partial: 'patients', locals: { patients: patients }
  end

  def show_patient_main
    authorize Provider, :provider?
    @diactive_ids = @patient.tooth_tables.where(active: false).map(&:id).to_json
    @top_teeth    = @patient.tooth_tables.where(:tooth_num.lt => 17)
    @bottom_teeth = @patient.tooth_tables.where(:tooth_num.gt => 16).reverse
    @procedures   = Procedure.where(:tooth_table_id.in => @patient.tooth_tables.map(&:id))
    @encounters   = @patient.encounters
    @insurances   = @patient.insurances
    @diagnoses    = @patient.diagnoses
    @medications  = Medication.where(:diagnosis_id.in => @patient.diagnoses.map(&:id))
    @allergies    = @patient.allergies
    @email_messages = current_user.draft
    @appointments  = current_user.provider.appointments
    @smoking_statuses     = @patient.smoking_statuses.order_by(created_at: :desc)
    @past_medical_history = @patient.past_medical_history
    @advanced_directive   = @patient.advanced_directive
    @immunizations = @patient.immunizations
    @dosespot = @patient.dosespot
  end

  def show_patient_diagnoses
    authorize Diagnosis, :show?
  end

  def add_patient_diagnoses
    authorize Diagnosis, :create?
    if params[:diagnosis_id].present?
      @diagnosis = Diagnosis.find(params[:diagnosis_id])
      @diagnosis_code = @diagnosis.diagnosis_code
    else
      @diagnosis = Diagnosis.new
      @diagnosis_code = DiagnosisCode.find(params[:diagnosis_code_id])
    end
  end

  def create_diagnosis
    authorize Diagnosis, :create?
    params[:diagnosis][:start_date] = params[:diagnosis][:start_date].to_time
    params[:diagnosis][:stop_date]  = params[:diagnosis][:stop_date].to_time
    diagnosis = Diagnosis.create(diagnosis_params)
    if diagnosis.persisted?
      flash[:notice] = 'Diagnosis created successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:diagnosis][:patient_id])
    else
      flash[:error] = diagnosis.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def update_diagnosis
    authorize Diagnosis, :update?
    params[:diagnosis][:start_date] = params[:diagnosis][:start_date].to_time
    params[:diagnosis][:stop_date]  = params[:diagnosis][:stop_date].to_time
    diagnosis = Diagnosis.find(params[:diagnosis][:diagnosis_id])
    if diagnosis.update(diagnosis_params)
      flash[:notice] = 'Diagnosis updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:diagnosis][:patient_id])
    else
      flash[:error] = diagnosis.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def show_patient_medications
    authorize Medication, :show?
    @portions = Portion.all
  end

  def add_patient_medications
    authorize Medication, :create?
    @diagnosis  = Diagnosis.find(params[:diagnosis_id])
    @medication = params[:medication_id].present? ? Medication.find(params[:medication_id]) : Medication.new
  end

  def create_medication
    authorize Medication, :create?
    params[:medication][:start_date] = params[:medication][:start_date].to_time
    params[:medication][:stop_date]  = params[:medication][:stop_date].to_time
    medication = Medication.create(medication_params)
    if medication.persisted?
      diagnosis = Diagnosis.find(params[:medication][:diagnosis_id])
      flash[:notice] = 'Medication created successfully'
      redirect_to add_patient_diagnoses_patient_treatments_path(id: params[:medication][:patient_id], diagnosis_id: diagnosis.id, diagnosis_code_id: diagnosis.diagnosis_code.id)
    else
      flash[:error] = medication.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def update_medication
    authorize Medication, :update?
    params[:medication][:start_date] = params[:medication][:start_date].to_time
    params[:medication][:stop_date]  = params[:medication][:stop_date].to_time
    medication = Medication.find(params[:medication][:medication_id])
    if medication.update(medication_params)
      diagnosis = Diagnosis.find(params[:medication][:diagnosis_id])
      flash[:notice] = 'Medication updated successfully'
      redirect_to add_patient_diagnoses_patient_treatments_path(id: params[:medication][:patient_id], diagnosis_id: diagnosis.id, diagnosis_code_id: diagnosis.diagnosis_code.id)
    else
      flash[:error] = medication.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def show_patient_allergy
    # add Allergy#update?
    authorize Allergy, :create?
    if params[:allergy_id].present?
      @allergy = Allergy.find(params[:allergy_id])
      @url = update_allergy_patient_treatments_path
    else
      @allergy = Allergy.new
      @url = create_allergy_patient_treatments_path
    end
  end

  def create_allergy
    authorize Allergy, :create?
    params[:allergy][:start_date] = params[:allergy][:start_date].to_time
    allergy = Allergy.create(allergy_params)
    if allergy.persisted?
      flash[:notice] = 'Allergy created successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:allergy][:patient_id])
    else
      flash[:error] = allergy.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def update_allergy
    authorize Allergy, :create?
    params[:allergy][:start_date] = params[:allergy][:start_date].to_time
    allergy = Allergy.find(params[:allergy][:id])
    if allergy.update(allergy_params)
      flash[:notice] = 'Allergy updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:allergy][:patient_id])
    else
      flash[:error] = allergy.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def edit_patient_smoking
    authorize SmokingStatus, :update?
  end

  def update_smoking_status
    authorize SmokingStatus, :update?
    params[:smoking_status][:effective_from] = params[:smoking_status][:effective_from].to_time
    smoking_status = SmokingStatus.create(smoking_status_params)
    if smoking_status.persisted?
      flash[:notice] = 'Smoking status updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:smoking_status][:patient_id])
    else
      flash[:error] = smoking_status.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def add_patient_medical_history
    authorize PastMedicalHistory, :update?
  end

  def update_medical_history
    authorize PastMedicalHistory, :update?
    med_history = PastMedicalHistory.find(params[:past_medical_history][:id])
    if med_history.update(past_medical_history_params)
      flash[:notice] = 'Past medical history updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:past_medical_history][:patient_id])
    else
      flash[:error] = med_history.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def add_patient_advanced_directives
    authorize AdvancedDirective, :update?
  end

  def update_advanced_directive
    authorize AdvancedDirective, :update?
    params[:advanced_directive][:record_date] = params[:advanced_directive][:record_date].to_time
    adv_directive = AdvancedDirective.find(params[:advanced_directive][:id])
    if adv_directive.update(adv_directive_params)
      flash[:notice] = 'Advanced directive updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:advanced_directive][:patient_id])
    else
      flash[:error] = adv_directive.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def add_patient_insurance
    authorize :chart, :insurance_show?
  end

  def create_insurance
    authorize :chart, :insurance_show?
    params[:insurance][:claim]          = params[:insurance][:claim].to_i
    params[:insurance][:copay_amount]   = params[:insurance][:copay_amount].to_i
    params[:insurance][:effective_from] = params[:insurance][:effective_from].to_time
    params[:insurance][:effective_to]   = params[:insurance][:effective_to].to_time
    params[:insurance][:employer][:zip] = params[:insurance][:employer][:zip].to_i
    params[:insurance][:subscriber][:zip] = params[:insurance][:subscriber][:zip].to_i
    params[:insurance][:subscriber][:birth] = params[:insurance][:subscriber][:birth].to_time
    insurance = Insurance.create(insurance_params)
    if insurance.persisted?
      employer = Employer.create(employer_params.merge({insurance_id: insurance.id}))
      if employer.persisted?
        subscriber = Subscriber.create(subscriber_params.merge({insurance_id: insurance.id}))
        if subscriber.persisted?
          flash[:notice] = 'Insurance created successfully'
          redirect_to show_patient_main_patient_treatments_path(id: params[:insurance][:patient_id])
        else
          flash[:error] = subscriber.errors.full_messages.to_sentence
          redirect_to :back
        end
      else
        flash[:error] = employer.errors.full_messages.to_sentence
        redirect_to :back
      end
    else
      flash[:error] = insurance.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def add_patient_payer
    authorize :chart, :insurance_show?
  end

  def create_payer
    authorize :chart, :insurance_show?
    payer = Payer.create(payer_params)
    if payer.persisted?
      params[:payer][:claim][:zip] = params[:payer][:claim][:zip].to_i
      claim = Claim.create(claim_params.merge({payer_id: payer.id}))
      if claim.persisted?
        flash[:notice] = 'Payer created successfully'
        redirect_to add_patient_insurance_patient_treatments_path(id: params[:payer][:patient_id])
      else
        flash[:error] = claim.errors.full_messages.to_sentence
        redirect_to :back
      end
    else
      flash[:error] = payer.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def tooth_activity
    authorize :chart, :perio_update?
    ToothTable.find(params[:id]).update(active: params[:active])
    render nothing: true
  end

  def show_patient_full_perio
    authorize Provider, :provider?
    tooth = ToothTable.find(params[:id])
    if tooth.active
      render partial: 'form_patient_full_perio', locals: { tooth: tooth }
    else
      render nothing: true
    end
  end

  def update_full_perio
    authorize :chart, :perio_update?
    flash[:error] = nil
    tooth = ToothTable.find(params[:tooth_table][:id])
    flash[:error] = tooth.errors.full_messages.to_sentence unless tooth.update(fm_f: params[:tooth_table][:fm_f], fm_m: params[:tooth_table][:fm_m])
    params[:tooth_table].each do |field_name, _|
      if %w(pd gm cal mgl).include? field_name
        tooth_field = tooth.send(field_name)
        flash[:error] = tooth_field.errors.full_messages.to_sentence unless tooth_field.update(full_tooth_params(field_name))
      end
    end
    if flash[:error].present?
      redirect_to show_patient_full_perio_patient_treatments_path(id: tooth.id)
    else
      flash[:notice] = 'Tooth updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: tooth.patient_id)
    end
  end

  def show_patient_perio_data_entry
    authorize Provider, :provider?
    field = params[:field]
    if %w(pd gm cal mgl).include? field
      top_teeth    = @patient.tooth_tables.where(:tooth_num.lt => 17)
      bottom_teeth = @patient.tooth_tables.where(:tooth_num.gt => 16).reverse
      render partial: 'form_patient_perio_data_entry', locals: { patient: @patient, field: field, top_teeth: top_teeth, bottom_teeth: bottom_teeth }
    else
      render nothing: true
    end
  end

  def update_tooth
    authorize :chart, :perio_update?
    flash[:error] = nil
    params[:patient][:tooth_tables].each do |index, tooth|
      if tooth[:tooth_field].present?
        tooth_field = ToothTable.find(tooth[:id]).tooth_fields.find(tooth[:tooth_field_id])
        flash[:error] = tooth_field.errors.full_messages.to_sentence unless tooth_field.update(tooth_params(index))
      end
    end
    if flash[:error].present?
      redirect_to show_patient_perio_data_entry_patient_treatments_path(id: params[:patient][:id], field: params[:field])
    else
      flash[:notice] = 'Tooth updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:patient][:id])
    end
  end

  def set_tooth_bsp
    authorize :chart, :perio_update?
    if (1..9).to_a.map{|el| "b_bsp#{el}"}.include?(params[:field_name]) || (1..9).to_a.map{|el| "l_bsp#{el}"}.include?(params[:field_name])
      tooth = ToothTable.find(params[:id])
      bsp = !tooth.send(params[:field_name])
      tooth.update(params[:field_name] => bsp)
      tooth.tooth_fields.update_all(params[:field_name] => bsp)
    end
    render nothing: true
  end

  def add_patient_encounter
    authorize Encounter, :create?
    @procedurs = Procedure.where(:tooth_table_id.in => @patient.tooth_tables.map(&:id))
                          .order_by(:tooth_table_id, date_of_service: :desc)
                          .map{ |p| ["#{p.date_of_service.try(:strftime, '%m/%d/%Y')} #{p.procedure_code} Tooth number: #{p.tooth_table.try(:tooth_num)}", p.try(:id)] }
  end

  def create_patient_encounter
    authorize Encounter, :create?
    encounter = Encounter.create(encounter_params)
    if encounter.persisted?
      Procedure.find(params[:procedure_id]).update(encounter_id: encounter.id)
      vital = Vital.create(vital_params.merge({encounter_id: encounter.id}))
      if vital.persisted?
        if params[:encounter][:procedure_completeds].present?
          params[:encounter][:procedure_completeds].each do |_, proc_code|
            ProcedureCompleted.create(encounter_id: encounter.id, procedure_code: proc_code[:procedure_code])
          end
        end
        if params[:encounter][:procedure_recommends].present?
          params[:encounter][:procedure_recommends].each do |_, proc_code|
            ProcedureRecommended.create(encounter_id: encounter.id, procedure_code: proc_code[:procedure_code])
          end
        end
        flash[:notice] = 'Encounter Note created successfully'
        redirect_to show_patient_main_patient_treatments_path(id: params[:encounter][:patient_id])
      else
        flash[:error] = vital.errors.full_messages.to_sentence
        redirect_to :back
      end
    else
      flash[:error] = encounter.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def update_encounter
    authorize Encounter, :create?
    encounter = Encounter.find(params[:encounter][:id])
    if encounter.update(encounter_params)
      vital = Vital.find(params[:encounter][:vital][:id])
      if vital.update(vital_params)
        flash[:notice] = 'Encounter Note updated successfully'
        redirect_to show_patient_main_patient_treatments_path(id: params[:encounter][:patient_id])
      else
        flash[:error] = vital.errors.full_messages.to_sentence
        redirect_to :back
      end
    else
      flash[:error] = encounter.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def providers
    authorize Provider, :provider?
    providers = if params[:part].present?
                  current_user.provider.all_providers.where(or: [{first_name: /^#{params[:part]}/}, {last_name: /^#{params[:part]}/}])
                else
                  current_user.provider.all_providers.first(10)
                end.map{ |provider| { full_name: provider.full_name, id: provider.id } }
    render json: providers.to_json
  end

  def diagnosis_codes
    authorize Provider, :provider?
    diagnosis_codes = if params[:part].present?
                        DiagnosisCode.where(code: /^#{params[:part]}/)
                      else
                        DiagnosisCode.limit(10)
                      end.map{ |code| { id: code.id, description: code.description, code: code.code } }
    render json: diagnosis_codes.to_json
  end

  def encounters
    authorize Encounter, :show?
    selected_date = Date.parse(params[:created_at])
    render json: @patient.encounters.where(created_at: selected_date.beginning_of_day..selected_date.end_of_day)
                                    .map{ |encounter| { created_at: encounter.created_at.strftime('%m/%d/%Y'),
                                                        id: encounter.id }
                                    }
                                    .to_json
  end

  def procedures
    authorize Procedure, :show?
    procedures = if params[:part].present?
                   Procedure.where(and: [{:tooth_table_id.in => @patient.tooth_tables.map(&:id)},
                                         {procedure_code: /^#{params[:part]}/}])
                 else
                   Procedure.where(:tooth_table_id.in => @patient.tooth_tables.map(&:id)).limit(10)
                 end.map{ |procedure| {full_name: "#{procedure.procedure_code} - #{procedure.description}", id: procedure.id} }
    render json: procedures.to_json
  end

  def procedure_codes
    authorize Procedure, :show?
    procedure_codes = if params[:part].present?
                        PROCEDURE_CODES.select{ |code, _| code.to_s.include?(params[:part]) }
                      else
                        PROCEDURE_CODES.first(10)
                      end.map{ |code, procedure| {full_name: procedure, id: code} }
    render json: procedure_codes.to_json
  end

  def payers
    authorize :chart, :insurance_show?
    patients = if params[:part].present?
                 Patient.find(params[:patient_id]).payers.where(name: /^#{params[:part]}/)
               else
                 Patient.find(params[:patient_id]).payers.first(10)
               end.map{ |payer| { full_name: payer.name, id: payer.id, plan: payer.plan } }
    render json: patients.to_json
  end

  def guarantor
    authorize :chart, :insurance_show?
    render json: @patient.guarantor.to_json
  end

  def portions
    authorize Provider, :provider?
    portions = if params[:part].present?
                Portion.where(drug: /^#{params[:part]}/)
              else
                Portion.limit(10)
              end.map{ |portion| { full_name: "#{portion.drug} #{portion.dose} #{portion.instruction}", id: portion.id } }
    render json: portions.to_json
  end

  def medications
    authorize Provider, :provider?
    medications = if params[:part].present?
      Medication.where(:portion_id.in => Portion.where(drug: /^#{params[:part]}/).map(&:id))
    else
      Medication.limit(10)
    end.map{ |med| { full_name: "#{med.portion.try(:drug)} #{med.portion.try(:dose)} #{med.portion.try(:instruction)}", id: med.id } }
    render json: medications.to_json
  end

  def encounter_full_info
    authorize Provider, :provider?
    render partial: 'encounter_note', locals: { encounter: Encounter.find(params[:encounter_id]), patient: @patient }
  end

  def add_patient_procedure
    authorize Procedure, :create?
    @procedure_code = params[:code]
    @tooth          = @patient.tooth_tables.where(tooth_num: params[:tooth_num]).first
  end

  def show_patient_procedure
    authorize Procedure, :show?
    @procedure = Procedure.find(params[:procedure_id])
  end

  def create_procedure
    authorize Procedure, :create?
    procedure = Procedure.create(procedure_params)
    if procedure.persisted?
      surface = Surface.create(surface_params.merge(procedure_id: procedure.id))
      if surface.persisted?
        pit = Pit.create(pit_params.merge(procedure_id: procedure.id))
        if pit.persisted?
          cusp = Cusp.create(cusp_params.merge(procedure_id: procedure.id))
          if cusp.persisted?
            flash[:notice] = 'Procedure created successfully'
            redirect_to show_patient_main_patient_treatments_path(id: params[:procedure][:patient_id])
          else
            flash[:error] = cusp.errors.full_messages.to_sentence
            redirect_to :back
          end
        else
          flash[:error] = pit.errors.full_messages.to_sentence
          redirect_to :back
        end
      else
        flash[:error] = surface.errors.full_messages.to_sentence
        redirect_to :back
      end
    else
      flash[:error] = procedure.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def update_procedure
    authorize Procedure, :update?
    procedure = Procedure.find(params[:procedure][:id])
    if procedure.update(procedure_params)
      flash[:notice] = 'Procedure updated successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:procedure][:patient_id])
    else
      flash[:error] = procedure.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def update_guarantor
    authorize :chart, :insurance_show?
    params[:guarantor][:birth] = params[:guarantor][:birth].to_time
    guarantor = Patient.find(params[:guarantor][:patient_id]).guarantor
    if guarantor.update(guarantor_params)
      flash[:notice] = 'Guarantor created successfully'
      redirect_to show_patient_main_patient_treatments_path(id: params[:guarantor][:patient_id])
    else
      flash[:error] = guarantor.errors.full_messages.to_sentence
      redirect_to show_patient_main_patient_treatments_path(id: params[:guarantor][:patient_id])
    end
  end

  private

  def find_patient
    @patient = Patient.find(params[:id])
  end

  def diagnosis_params
    params.require(:diagnosis).permit(
      :patient_id,
      :diagnosis_code_id,
      :start_date,
      :stop_date,
      :acute,
      :terminal,
      :note
    )
  end

  def medication_params
    params.require(:medication).permit(
      :diagnosis_id,
      :shorthand,
      :signature,
      :portion_id,
      :start_date,
      :stop_date,
      :note
    )
  end

  def allergy_params
    params.require(:allergy).permit(
      :patient_id,
      :allergen_type,
      :severity_level,
      :onset_at,
      :start_date,
      :active,
      :note
    )
  end

  def tooth_params(index)
    params.require(:patient).require(:tooth_tables).require(index.to_sym).require(:tooth_field).permit(
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
    params.require(:tooth_table).require(tooth_field_name.to_sym).permit(
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
    params.require(:encounter).permit(
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
    params.require(:encounter).require(:vital).permit(
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

  def procedure_params
    params.require(:procedure).permit(
      :tooth_table_id,
      :procedure_code,
      :date_of_service,
      :status
    )
  end

  def surface_params
    params.require(:procedure).require(:surface).permit(
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
    params.require(:procedure).require(:pit).permit(
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
    params.require(:procedure).require(:cusp).permit(
      :procudure_id,
      :mesiobuccal,
      :mesiolingual,
      :distobuccal,
      :distolingual
    )
  end

  def guarantor_params
    params.require(:guarantor).permit(
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
    params.require(:payer).permit(
      :patient_id,
      :name,
      :plan,
      :plan_type
    )
  end

  def claim_params
    params.require(:payer).require(:claim).permit(
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

  def insurance_params
    params.require(:insurance).permit(
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
    params.require(:insurance).require(:employer).permit(
      :name,
      :phone,
      :street_address,
      :city,
      :state,
      :zip
    )
  end

  def subscriber_params
    params.require(:insurance).require(:subscriber).permit(
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

  def smoking_status_params
    params.require(:smoking_status).permit(
      :patient_id,
      :status,
      :effective_from
    )
  end

  def past_medical_history_params
    params.require(:past_medical_history).permit(
        :patient_id,
        :major_events,
        :ongoing_problems,
        :preventitive_care,
        :nutrition_history,
        :developmental_history
    )
  end

  def adv_directive_params
    params.require(:advanced_directive).permit(
      :patient_id,
      :record_date,
      :notes
    )
  end

  def check_role
    redirect_to '/404' if current_user.blank? || current_user.role != :Provider
  end
end
