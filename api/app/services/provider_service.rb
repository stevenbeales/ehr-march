class ProviderService
  def self.create
    authy_id = Authy::API.register_user(
      email:        Rails.application.secrets.ehr_provider_email,
      cellphone:    Rails.application.secrets.admin_phone_number,
      country_code: Rails.application.secrets.admin_country_code).id

    user = FactoryGirl.create :user,
      email:          Rails.application.secrets.ehr_provider_email,
      password:       Rails.application.secrets.ehr_provider_password,
      authy_id:       authy_id.to_s,
      authy_enabled:  true

    provider = FactoryGirl.create :provider, user_id: user.id

    3.times do |i|
      FactoryGirl.create :room, provider_id: provider.id, room: "OR#{i + 1}"
    end
    AppointmentStatus.examples.each do |status|
      FactoryGirl.create :appointment_status, provider_id: provider.id, name: status
    end
    AppointmentType.examples.each do |type|
      FactoryGirl.create :appointment_type, provider_id: provider.id, appt_type: type
    end

    5.times { |i| create_practice_location(provider, i) }
  end

  def self.create_patient(i, provider)
    user = FactoryGirl.create :user,
      email:    "patient#{i}@ehr1medical.com",
      password: 'patient',
      role:     :Patient

    patient = FactoryGirl.create :patient, user_id: user.id, provider_id: provider.id

    appointment = FactoryGirl.create(
      :appointment,
      patient_id:         patient.id,
      location:           provider.location1,
      room:               provider.rooms.first,
      appointment_type:   provider.appointment_types.first,
      appointment_status: provider.appointment_statuses.first)

    FactoryGirl.create :referral, appointment_id: appointment.id

    FactoryGirl.create :block_out,  patient_id: patient.id
    FactoryGirl.create :allergy,    patient_id: patient.id

    diagnosis = FactoryGirl.create :diagnosis, patient_id: patient.id

    FactoryGirl.create :medication, diagnosis_id: diagnosis.id

    encounter = FactoryGirl.create :encounter, patient_id: patient.id

    FactoryGirl.create :vital,                  encounter_id: encounter.id
    FactoryGirl.create :procedure_completed,    encounter_id: encounter.id
    FactoryGirl.create :procedure_recommended,  encounter_id: encounter.id

    payer = FactoryGirl.create :payer, patient_id: patient.id
    FactoryGirl.create :claim, payer_id: payer.id

    insurance = FactoryGirl.create :insurance, patient_id: patient.id

    FactoryGirl.create :subscriber, insurance_id: insurance.id
    FactoryGirl.create :employer,   insurance_id: insurance.id

    FactoryGirl.create :smoking_status,        patient_id: patient.id
    FactoryGirl.create :past_medical_history,  patient_id: patient.id
    FactoryGirl.create :advanced_directive,    patient_id: patient.id

    FactoryGirl.create :patient_appointment,   provider_id: provider.id, patient_id: patient.id
  end

  def self.create_practice_location(provider, i)
    location = FactoryGirl.create :location,
      provider_id:      provider.id,
      location_npi:     "FRE32#{i}1",
      location_tin_en:  "DSE#{i}3423"

    Timeslot.weekdays.each do |weekday|
      FactoryGirl.create :timeslot,
        location_id:  location.id,
        weekday:      weekday
    end
  end

  def self.create_practice(provider)
    FactoryGirl.create :practice,
      provider_id:          provider.id,
      practice_location_id: provider.practice_locations.first.id
  end
end
