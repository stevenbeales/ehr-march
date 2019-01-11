class PatientService

  def self.create
    current_provider = Provider.first

    authy_id = Authy::API.register_user(
      email:        Rails.application.secrets.ehr_patient_email,
      cellphone:    Rails.application.secrets.admin_phone_number,
      country_code: Rails.application.secrets.admin_country_code).id

    user = FactoryGirl.create :user,
      email:          Rails.application.secrets.ehr_patient_email,
      password:       Rails.application.secrets.ehr_patient_password,
      role:           :Patient,
      authy_id:       authy_id.to_s,
      authy_enabled:  true

    patient = FactoryGirl.create :patient, user_id: user.id, provider_id: current_provider.id

    appointment = FactoryGirl.create(
      :appointment,
      patient_id:         patient.id,
      location:           current_provider.location1,
      room:               current_provider.rooms.first,
      appointment_type:   current_provider.appointment_types.first,
      appointment_status: current_provider.appointment_statuses.first)

    FactoryGirl.create :referral, appointment_id: appointment.id

    FactoryGirl.create :block_out,  patient_id: patient.id
    FactoryGirl.create :allergy,    patient_id: patient.id

    diagnosis = FactoryGirl.create :diagnosis, patient_id: patient.id
    FactoryGirl.create :medication, diagnosis_id: diagnosis.id

    payer = FactoryGirl.create :payer, patient_id: patient.id
    FactoryGirl.create :claim, payer_id: payer.id

    FactoryGirl.create :next_kin,           patient_id: patient.id
    FactoryGirl.create :guarantor,          patient_id: patient.id
    FactoryGirl.create :emergency_contact,  patient_id: patient.id

    FactoryGirl.create :smoking_status,        patient_id: patient.id
    FactoryGirl.create :past_medical_history,  patient_id: patient.id
    FactoryGirl.create :advanced_directive,    patient_id: patient.id
    FactoryGirl.create :immunization,          patient_id: patient.id

    insurance = FactoryGirl.create :insurance, patient_id: patient.id

    FactoryGirl.create :subscriber, insurance_id: insurance.id
    FactoryGirl.create :employer,   insurance_id: insurance.id

    encounter = FactoryGirl.create :encounter, patient_id: patient.id

    FactoryGirl.create :vital,                  encounter_id: encounter.id
    FactoryGirl.create :procedure_completed,    encounter_id: encounter.id
    FactoryGirl.create :procedure_recommended,  encounter_id: encounter.id

    FactoryGirl.create :patient_appointment, patient_id: patient.id

    create_test_messages(current_provider.user, user)
  end

  def self.create_test_messages(provider, patient)
    FactoryGirl.create :email_message,  to_id: provider.id, from_id: patient.id
    FactoryGirl.create :urgent,         to_id: patient.id,  from_id: provider.id
    FactoryGirl.create :archive,        to_id: patient.id,  from_id: provider.id
  end
end
