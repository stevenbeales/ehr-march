require 'api_documentation_helper'

RSpec.resource 'Patient treatement' do
  header 'Content-Type', 'application/vnd.api+json'

  get '/patient_treatments' do
    before do
      User.destroy_all
      provider = create :provider
      3.times { create :patient, provider_id: provider.id }
    end
    let(:provider) { Provider.first }

    parameter :auth_token, 'Authentication Token',    scope: :data,   required: true
    parameter :page,       'Pagination, page number', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:page) { 0 }

    example_request 'Index' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Patient.all, is_collection: true).to_json
    end
  end

  get '/patient_treatments/show_patient_main' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient  }

    parameter :auth_token, 'Authentication Token',     scope: :data,   required: true
    parameter :patient_id, 'Patient id',               scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:patient_id) { patient.id }

    example_request 'Search patient' do
      expect(status).to eq 200
    end
  end

  get '/patient_treatments/search_patients' do
    before do
      User.destroy_all
    end
    let!(:provider) { create :provider }
    let!(:patient1) { create :patient, first_name: 'David',  last_name: 'Markus',   provider_id: provider.id }
    let!(:patient2) { create :patient, first_name: 'Rachel', last_name: 'Marend',   provider_id: provider.id }
    let!(:patient3) { create :patient, first_name: 'Glory',  last_name: 'Daviand',  provider_id: provider.id }

    parameter :auth_token, 'Authentication Token',                           scope: :data,   required: true
    parameter :page,       'Pagination, page number',                        scope: :data,   required: true
    parameter :part,       'A part of first name or last name of a patient', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:page)       { 0 }
    let(:part)       { 'Dav' }

    example_request 'Search patient' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize([patient1, patient3], is_collection: true).to_json
    end
  end

  get '/patient_treatments/active_patients' do
    before do
      User.destroy_all
    end
    let!(:provider) { create :provider }
    let!(:patient1) { create :patient, provider_id: provider.id, active: true }
    let!(:patient2) { create :patient, provider_id: provider.id, active: true }
    let!(:patient3) { create :patient, provider_id: provider.id, active: false }

    parameter :auth_token, 'Authentication Token',                           scope: :data,   required: true
    parameter :page,       'Pagination, page number',                        scope: :data,   required: true
    parameter :active,     'Boolean, if true - get active patients',         scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:page)       { 1 }
    let(:active)     { true }

    example_request 'Get active or inactive patients' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize([patient1, patient2], is_collection: true).to_json
    end
  end

  get '/patient_treatments/add_patient_diagnoses' do
    before do
      User.destroy_all
      Diagnosis.destroy_all
    end
    let!(:provider)  { create :provider }
    let!(:diagnosis) { create :diagnosis }

    parameter :auth_token,         'Authentication Token',                                          scope: :data,   required: true
    parameter :patient_id,         'Patient id',                                                    scope: :data,   required: true
    parameter :diagnosis_id,       'Diagnosis id, this or diagnosis code id should be present',     scope: :data
    parameter :diagnosis_code_id,  'Diagnosis code id, this or diagnosis id should be present',     scope: :data

    let(:auth_token)         { provider.user.auth_token }
    let(:patient_id)         { diagnosis.patient.id }
    let(:diagnosis_id)       { diagnosis.id }
    let(:diagnosis_code_id)  { nil }

    example_request 'Add patient diagnoses' do
      expect(status).to eq 200
      expect(response_body).to eq({ data: { diagnosis: Diagnosis.find(diagnosis_id), diagnosis_code: Diagnosis.find(diagnosis_id).diagnosis_code } }.to_json)
    end
  end

  post '/patient_treatments/create_diagnosis' do
    before do
      User.destroy_all
      Diagnosis.destroy_all
    end
    let!(:provider)  { create :provider }
    let!(:diagnosis) { create :diagnosis }

    parameter :auth_token,         'Authentication Token',                              required: true
    parameter :patient_id,         'Patient id',                                        required: true
    parameter :diagnosis_code_id,  'Diagnosis code id',           scope: :diagnosis
    parameter :start_date,         'Start date',                  scope: :diagnosis
    parameter :stop_date,          'Stop date',                   scope: :diagnosis
    parameter :acute,              'Boolean, if true - acute',    scope: :diagnosis
    parameter :terminal,           'Boolean, if true - terminal', scope: :diagnosis
    parameter :note,               'Note',                        scope: :diagnosis

    let(:auth_token)         { provider.user.auth_token }
    let(:patient_id)         { diagnosis.patient.id }
    let(:diagnosis_code_id)  { diagnosis.diagnosis_code_id }
    let(:start_date)         { diagnosis.start_date }
    let(:stop_date)          { diagnosis.stop_date }
    let(:acute)              { diagnosis.acute }
    let(:terminal)           { diagnosis.terminal }
    let(:note)               { diagnosis.note }

    example_request 'Create patient diagnoses' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Diagnosis.last).to_json
    end
  end

  patch '/patient_treatments/update_diagnosis' do
    before do
      User.destroy_all
      Diagnosis.destroy_all
    end
    let!(:provider)  { create :provider }
    let!(:diagnosis) { create :diagnosis }

    parameter :auth_token,         'Authentication Token',                              required: true
    parameter :diagnosis_id,       'Diagnosis id',                scope: :diagnosis,    required: true
    parameter :patient_id,         'Patient id',                                        required: true
    parameter :diagnosis_code_id,  'Diagnosis code id',           scope: :diagnosis
    parameter :start_date,         'Start date',                  scope: :diagnosis
    parameter :stop_date,          'Stop date',                   scope: :diagnosis
    parameter :acute,              'Boolean, if true - acute',    scope: :diagnosis
    parameter :terminal,           'Boolean, if true - terminal', scope: :diagnosis
    parameter :note,               'Note',                        scope: :diagnosis

    let(:auth_token)         { provider.user.auth_token }
    let(:diagnosis_id)       { diagnosis.id }
    let(:patient_id)         { diagnosis.patient.id }
    let(:diagnosis_code_id)  { diagnosis.diagnosis_code_id }
    let(:start_date)         { Time.now }
    let(:stop_date)          { Time.now }
    let(:acute)              { diagnosis.acute }
    let(:terminal)           { diagnosis.terminal }
    let(:note)               { diagnosis.note }

    example_request 'Update patient diagnoses' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Diagnosis.last).to_json
    end
  end

  get '/patient_treatments/show_patient_medications' do
    before do
      User.destroy_all
      Portion.destroy_all
      3.times { create :portion }
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }

    parameter :auth_token, 'Authentication Token',   scope: :data,   required: true
    parameter :patient_id, 'Patient id',             scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:patient_id) { patient.id }

    example_request 'Show patient medications' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Portion.all, is_collection: true).to_json
    end
  end

  get '/patient_treatments/add_patient_medications' do
    before do
      User.destroy_all
      Diagnosis.destroy_all
      Medication.destroy_all
      Portion.destroy_all
    end
    let(:provider)   { create :provider }
    let(:patient)    { create :patient }
    let(:diagnosis)  { create :diagnosis }
    let(:medication) { create :medication }

    parameter :auth_token,    'Authentication Token',   scope: :data,   required: true
    parameter :patient_id,    'Patient id',             scope: :data,   required: true
    parameter :diagnosis_id,  'Diagnosis id',           scope: :data,   required: true
    parameter :medication_id, 'Medication id',          scope: :data

    let(:auth_token)     { provider.user.auth_token }
    let(:patient_id)     { patient.id }
    let(:diagnosis_id)   { diagnosis.id }
    let(:medication_id)  { medication.id }

    example_request 'Add patient medications' do
      expect(status).to eq 200
      expect(response_body).to eq({ data: { diagnosis: Diagnosis.first, medication: Medication.first } }.to_json)
    end
  end

  post '/patient_treatments/create_medication' do
    before do
      User.destroy_all
      Diagnosis.destroy_all
      Medication.destroy_all
      Portion.destroy_all
    end
    let(:provider)   { create :provider }
    let(:medication) { create :medication }

    parameter :auth_token,         'Authentication Token',                              required: true
    parameter :patient_id,         'Patient id',                                        required: true
    parameter :diagnosis_id,       'Diagnosis id',           scope: :medication
    parameter :portion_id,         'Portion id',             scope: :medication
    parameter :shorthand,          'Shorthand',              scope: :medication
    parameter :signature,          'Signature',              scope: :medication
    parameter :start_date,         'Start date',             scope: :medication
    parameter :stop_date,          'Stop date',              scope: :medication
    parameter :note,               'Note',                   scope: :medication

    let(:auth_token)     { provider.user.auth_token }
    let(:patient_id)     { medication.diagnosis.patient.id }
    let(:diagnosis_id)   { medication.diagnosis.id }
    let(:portion_id)     { medication.portion.id }
    let(:shorthand)      { medication.shorthand }
    let(:signature)      { medication.signature }
    let(:start_date)     { Time.now }
    let(:stop_date)      { Time.now }
    let(:note)           { medication.note }

    example_request 'Create patient medication' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Medication.last).to_json
    end
  end

  patch '/patient_treatments/update_medication' do
    before do
      User.destroy_all
      Diagnosis.destroy_all
      Medication.destroy_all
      Portion.destroy_all
    end
    let(:provider)   { create :provider }
    let(:medication) { create :medication }

    parameter :auth_token,         'Authentication Token',                              required: true
    parameter :medication_id,      'Medication id',          scope: :medication,        required: true
    parameter :patient_id,         'Patient id',                                        required: true
    parameter :diagnosis_id,       'Diagnosis id',           scope: :medication
    parameter :portion_id,         'Portion id',             scope: :medication
    parameter :shorthand,          'Shorthand',              scope: :medication
    parameter :signature,          'Signature',              scope: :medication
    parameter :start_date,         'Start date',             scope: :medication
    parameter :stop_date,          'Stop date',              scope: :medication
    parameter :note,               'Note',                   scope: :medication

    let(:auth_token)     { provider.user.auth_token }
    let(:medication_id)  { medication.id }
    let(:patient_id)     { medication.diagnosis.patient.id }
    let(:diagnosis_id)   { medication.diagnosis.id }
    let(:portion_id)     { medication.portion.id }
    let(:shorthand)      { medication.shorthand }
    let(:signature)      { medication.signature }
    let(:start_date)     { Time.now }
    let(:stop_date)      { Time.now }
    let(:note)           { medication.note }

    example_request 'Update patient medication' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Medication.last).to_json
    end
  end

  post '/patient_treatments/create_allergy' do
    before do
      User.destroy_all
      Allergy.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient }
    let(:allergy)  { create :allergy }

    parameter :auth_token,         'Authentication Token',                              required: true
    parameter :patient_id,         'Patient id',                                        required: true
    parameter :allergen_type,      'Allergen type',           scope: :allergy
    parameter :severity_level,     'Severity level',          scope: :allergy
    parameter :onset_at,           'Onset at',                scope: :allergy
    parameter :start_date,         'Start date',              scope: :allergy
    parameter :active,             'Active',                  scope: :allergy
    parameter :note,               'Note',                    scope: :allergy

    let(:auth_token)     { provider.user.auth_token }
    let(:patient_id)     { patient.id }
    let(:allergen_type)  { allergy.allergen_type }
    let(:severity_level) { allergy.severity_level }
    let(:onset_at)       { allergy.onset_at }
    let(:start_date)     { Time.now }
    let(:active)         { allergy.active }
    let(:note)           { allergy.note }

    example_request 'Create patient allergy' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Allergy.last).to_json
    end
  end

  patch '/patient_treatments/update_allergy' do
    before do
      User.destroy_all
      Allergy.destroy_all
    end
    let(:provider)    { create :provider }
    let(:patient)     { create :patient }
    let(:allergy)     { create :allergy }
    let(:old_allergy) { create :allergy }

    parameter :auth_token,         'Authentication Token',                              required: true
    parameter :patient_id,         'Patient id',                                        required: true
    parameter :id,                 'Allergy id',              scope: :allergy,          required: true
    parameter :allergen_type,      'Allergen type',           scope: :allergy
    parameter :severity_level,     'Severity level',          scope: :allergy
    parameter :onset_at,           'Onset at',                scope: :allergy
    parameter :start_date,         'Start date',              scope: :allergy
    parameter :active,             'Active',                  scope: :allergy
    parameter :note,               'Note',                    scope: :allergy

    let(:auth_token)     { provider.user.auth_token }
    let(:patient_id)     { patient.id }
    let(:id)             { old_allergy.id }
    let(:allergen_type)  { allergy.allergen_type }
    let(:severity_level) { allergy.severity_level }
    let(:onset_at)       { allergy.onset_at }
    let(:start_date)     { Time.now }
    let(:active)         { allergy.active }
    let(:note)           { allergy.note }

    example_request 'Create patient allergy' do
      expect(status).to eq 200
    end
  end

  post '/patient_treatments/create_insurance' do
    before do
      User.destroy_all
      Insurance.destroy_all
      Subscriber.destroy_all
      Employer.destroy_all
    end
    let(:provider)       { create :provider }
    let(:patient)        { create :patient }
    let(:insurance_ex)   { create :insurance }
    let(:subscriber_ex)  { create :subscriber }
    let(:employer_ex)    { create :employer }

    parameter :auth_token,          'Authentication Token',                         required: true
    parameter :patient_id,          'Patient id',                                   required: true
    parameter :insurance,           'Insurance params',                             required: true
    parameter :subscriber,          'Subscriber params',                            required: true
    parameter :employer,            'Employer params',                              required: true

    parameter :worker_compensation, 'Worker compensation',     scope: :insurance
    parameter :insurance_number,    'Insurance number',        scope: :insurance
    parameter :relation,            'Relation',                scope: :insurance
    parameter :effective_from,      'Effective from',          scope: :insurance
    parameter :effective_to,        'Effective to',            scope: :insurance
    parameter :copay_type,          'Copay type',              scope: :insurance
    parameter :copay_amount,        'Copay amount',            scope: :insurance
    parameter :claim,               'Claim',                   scope: :insurance
    parameter :note,                'Note',                    scope: :insurance
    parameter :active,              'Active',                  scope: :insurance

    parameter :first_name,          'First name',              scope: :subscriber
    parameter :middle_name,         'Last name',               scope: :subscriber
    parameter :last_name,           'Middle name',             scope: :subscriber
    parameter :birth,               'Birth date',              scope: :subscriber
    parameter :gender,              'Gender',                  scope: :subscriber
    parameter :social_number,       'Social number',           scope: :subscriber
    parameter :phone,               'Phone',                   scope: :subscriber
    parameter :street_address,      'Street address',          scope: :subscriber
    parameter :city,                'City',                    scope: :subscriber
    parameter :state,               'State',                   scope: :subscriber
    parameter :zip,                 'Zip',                     scope: :subscriber

    parameter :name,                'Name',                    scope: :employer
    parameter :phone,               'Phone',                   scope: :employer
    parameter :street_address,      'Street address',          scope: :employer
    parameter :city,                'City',                    scope: :employer
    parameter :state,               'state',                   scope: :employer
    parameter :zip,                 'Zip',                     scope: :employer

    let(:auth_token)  { provider.user.auth_token }
    let(:patient_id)  { patient.id }
    let(:insurance)   { {
      worker_compensation: insurance_ex.worker_compensation,
      insurance_number:    insurance_ex.insurance_number,
      relation:            insurance_ex.relation,
      effective_from:      insurance_ex.effective_from,
      effective_to:        insurance_ex.effective_to,
      copay_type:          insurance_ex.copay_type,
      copay_amount:        insurance_ex.copay_amount,
      claim:               insurance_ex.claim,
      note:                insurance_ex.note,
      active:              insurance_ex.active
    } }

    let(:subscriber) { {
      first_name:     subscriber_ex.first_name,
      middle_name:    subscriber_ex.middle_name,
      last_name:      subscriber_ex.last_name,
      birth:          subscriber_ex.birth,
      gender:         subscriber_ex.gender,
      social_number:  subscriber_ex.social_number,
      phone:          subscriber_ex.phone,
      street_address: subscriber_ex.street_address,
      city:           subscriber_ex.city,
      state:          subscriber_ex.state,
      zip:            subscriber_ex.zip
     } }

    let(:employer) { {
      name:           employer_ex.name,
      phone:          employer_ex.phone,
      street_address: employer_ex.street_address,
      city:           employer_ex.city,
      state:          employer_ex.state,
      zip:            employer_ex.zip
    } }


    example_request 'Create patient insurance' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Insurance.last).to_json
    end
  end

  post '/patient_treatments/create_payer' do
    before do
      User.destroy_all
      Payer.destroy_all
      Claim.destroy_all
    end
    let(:provider)  { create :provider }
    let(:patient)   { create :patient }
    let(:payer_ex)  { create :payer }
    let(:claim_ex)  { create :claim }

    parameter :auth_token,     'Authentication Token',                    required: true
    parameter :patient_id,     'Patient id',                              required: true
    parameter :payer,          'Payer params',                            required: true
    parameter :claim,          'Claim params',                            required: true

    parameter :name,           'Name',                  scope: :payer
    parameter :plan,           'Plan',                  scope: :payer
    parameter :plan_type,      'Plan type',             scope: :payer

    parameter :first_name,      'First name',           scope: :claim
    parameter :middle_name,     'Middle name',          scope: :claim
    parameter :last_name,       'Last name',            scope: :claim
    parameter :street_address1, 'Street address #1',    scope: :claim
    parameter :street_address2, 'Street address #2',    scope: :claim
    parameter :phone,           'Phone',                scope: :claim
    parameter :fax,             'Fax',                  scope: :claim
    parameter :ext1,            'Ext 1',                scope: :claim
    parameter :ext2,            'Ext 2',                scope: :claim
    parameter :city,            'City',                 scope: :claim
    parameter :state,           'State',                scope: :claim
    parameter :zip,             'Zip',                  scope: :claim
    parameter :notes,           'Notes',                scope: :claim

    let(:auth_token)  { provider.user.auth_token }
    let(:patient_id)  { patient.id }
    let(:payer) { {
        name:      payer_ex.name,
        plan:      payer_ex.plan,
        plan_type: payer_ex.plan_type
    } }

    let(:claim) { {
        first_name:      claim_ex.first_name,
        middle_name:     claim_ex.middle_name,
        last_name:       claim_ex.last_name,
        street_address1: claim_ex.street_address1,
        street_address2: claim_ex.street_address2,
        phone:           claim_ex.phone,
        fax:             claim_ex.fax,
        ext1:            claim_ex.ext1,
        ext2:            claim_ex.ext2,
        city:            claim_ex.city,
        state:           claim_ex.state,
        zip:             claim_ex.zip,
        notes:           claim_ex.notes,
    } }

    example_request 'Create patient payer' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Payer.last).to_json
    end
  end

  get '/patient_treatments/add_patient_encounter' do
    before do
      User.destroy_all
      Procedure.destroy_all
      patient = create :patient
      3.times { create :procedure, tooth_table_id: patient.tooth_tables.first.id }
    end
    let(:provider) { create :provider }
    let(:patient)  { Patient.first }

    parameter :auth_token, 'Authentication Token',    scope: :data,   required: true
    parameter :patient_id, 'Patient id',              scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:patient_id) { patient.id }

    example_request 'Get active or inactive patients' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  post '/patient_treatments/create_patient_encounter' do
    before do
      User.destroy_all
      Encounter.destroy_all
      Vital.destroy_all
      ProcedureRecommended.destroy_all
      ProcedureCompleted.destroy_all
    end
    let(:provider)      { create :provider }
    let(:patient)       { create :patient }
    let(:procedure)     { create :procedure }
    let(:encounter_ex)  { create :encounter }
    let(:vital_ex)      { create :vital }
    let(:procedure_completed_ex)    { create :procedure_completed }
    let(:procedure_recommended_ex)  { create :procedure_recommended }

    parameter :auth_token,     'Authentication Token',                    required: true
    parameter :patient_id,     'Patient id',                              required: true
    parameter :procedure_id,   'Procedure id',                            required: true
    parameter :encounter,      'Encounter params',                        required: true
    parameter :vital,          'Vital params',                            required: true
    parameter :procedure_completed,   'Procedure completed params',       required: true
    parameter :procedure_recommended, 'Procedure recommended params',     required: true

    parameter :provider_id,       'Provider id',            scope: :encounter
    parameter :notes,             'Notes',                  scope: :encounter
    parameter :med_completed,     'Medication completed',   scope: :encounter
    parameter :patient_education, 'Patient education',      scope: :encounter
    parameter :clinical_summary,  'Clinical summary',       scope: :encounter
    parameter :to_provider_id,    'To provider id',         scope: :encounter
    parameter :from_provider_id,  'From provider id',       scope: :encounter
    
    parameter :height_major,      'Height major',           scope: :vital
    parameter :height_minor,      'Height minor',           scope: :vital
    parameter :weight,            'Weight',                 scope: :vital
    parameter :units_system,      'Units system',           scope: :vital
    parameter :bp_left,           'Bp left',                scope: :vital
    parameter :bp_right,          'Bp right',               scope: :vital
    parameter :temp,              'Temp',                   scope: :vital
    parameter :pulse,             'Pulse',                  scope: :vital
    parameter :rr,                'RR',                     scope: :vital
    parameter :sat,               'SAT',                    scope: :vital
    parameter :temp_type,         'Temp type',              scope: :vital
    parameter :ra_type,           'RA type',                scope: :vital
    parameter :blood,             'Blood',                  scope: :vital
    
    parameter :procedure_code,    'Procedure code',         scope: :procedure_completed
    parameter :procedure_code,    'Procedure code',         scope: :procedure_recommended

    let(:auth_token)    { provider.user.auth_token }
    let(:patient_id)    { patient.id }
    let(:procedure_id)  { procedure.id }

    let(:encounter) { {
        provider_id:       provider.id,
        notes:             encounter_ex.notes,
        med_completed:     encounter_ex.med_completed,
        patient_education: encounter_ex.patient_education,
        clinical_summary:  encounter_ex.clinical_summary,
        to_provider_id:    encounter_ex.to_provider_id,
        from_provider_id:  encounter_ex.from_provider_id
    } }

    let(:vital) { {
        height_major: vital_ex.height_major,
        height_minor: vital_ex.height_minor,
        weight:       vital_ex.weight,
        units_system: vital_ex.units_system,
        bp_left:      vital_ex.bp_left,
        bp_right:     vital_ex.bp_right,
        temp:         vital_ex.temp,
        pulse:        vital_ex.pulse,
        rr:           vital_ex.rr,
        sat:          vital_ex.sat,
        temp_type:    vital_ex.temp_type,
        ra_type:      vital_ex.ra_type,
        blood:        vital_ex.blood
    } }

    let(:procedure_completed) { {
        procedure_code: procedure_completed_ex.procedure_code
    } }

    let(:procedure_recommended) { {
        procedure_code: procedure_recommended_ex.procedure_code
    } }

    example_request 'Create patient encounter' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Encounter.last).to_json
    end
  end

  get '/patient_treatments/providers' do
    before do
      User.destroy_all
    end
    let!(:provider)  { create :provider, first_name: 'Mark',   last_name: 'Spenser' }
    let!(:provider1) { create :provider, first_name: 'David',  last_name: 'Markus'  }
    let!(:provider2) { create :provider, first_name: 'Rachel', last_name: 'Marend'  }
    let!(:provider3) { create :provider, first_name: 'Glory',  last_name: 'Daviand' }

    parameter :auth_token, 'Authentication Token',                            scope: :data,   required: true
    parameter :part,       'A part of first name or last name of a provider', scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'Dav' }

    example_request 'Search providers' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize([provider1, provider3], is_collection: true).to_json
    end
  end

  get '/patient_treatments/diagnosis_codes' do
    before do
      User.destroy_all
    end
    let!(:provider)  { create :provider }

    parameter :auth_token, 'Authentication Token',         scope: :data,   required: true
    parameter :part,       'A part of diagnosis code',     scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'A00' }

    example_request 'Search diagnosis codes' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 3
    end
  end

  get '/patient_treatments/procedure_codes' do
    before do
      User.destroy_all
    end
    let!(:provider)  { create :provider }

    parameter :auth_token, 'Authentication Token',         scope: :data,   required: true
    parameter :part,       'A part of procedure code',     scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'D51' }

    example_request 'Search procedure codes' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data']['procedure_codes'].count).to eq 3
    end
  end

  get '/patient_treatments/payers' do
    before do
      User.destroy_all
      Payer.destroy_all
      patient = create :patient
      2.times { create :payer, name: 'Gaetano', patient_id: patient.id }
      2.times { create :payer, name: 'Pretto',  patient_id: patient.id }
    end
    let(:provider)  { create :provider }
    let(:patient)   { Patient.last }

    parameter :auth_token, 'Authentication Token',    scope: :data,   required: true
    parameter :part,       'A part of payer name',    scope: :data,   required: true
    parameter :patient_id, 'Patient id',              scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'Gae' }
    let(:patient_id) { patient.id }

    example_request 'Search payer names' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 2
    end
  end

  get '/patient_treatments/portions' do
    before do
      User.destroy_all
      Portion.destroy_all
      2.times { create :portion, drug: 'Voluptatem' }
      2.times { create :portion, drug: 'Tenetur' }
    end
    let(:provider)  { create :provider }

    parameter :auth_token, 'Authentication Token',       scope: :data,   required: true
    parameter :part,       'A part of portion drug',     scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'Volup' }

    example_request 'Search portion drugs' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 2
    end
  end

  get '/patient_treatments/medications' do
    before do
      User.destroy_all
      Medication.destroy_all
      Portion.destroy_all
      2.times { create :medication, portion: create(:portion, drug: 'Voluptatem') }
      2.times { create :medication, portion: create(:portion, drug: 'Tenetur')    }
    end
    let(:provider)  { create :provider }

    parameter :auth_token, 'Authentication Token',       scope: :data,   required: true
    parameter :part,       'A part of portion drug',     scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:part)       { 'Volup' }

    example_request 'Search medications' do
      expect(status).to eq 200
      expect(JSON.parse(response_body)['data'].count).to eq 2
    end
  end

  get '/patient_treatments/encounter_full_info' do
    before do
      User.destroy_all
      Encounter.destroy_all
    end
    let(:provider)  { create :provider }
    let(:patient)   { create :patient }
    let(:encounter) { create :encounter }

    parameter :auth_token, 'Authentication Token',  scope: :data,   required: true
    parameter :id,         'Encounter id',          scope: :data,   required: true
    parameter :patient_id, 'Patient id',            scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:id)         { encounter.id }
    let(:patient_id) { patient.id }

    example_request 'Get encounter by id' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(Encounter.find(encounter.id)).to_json
    end
  end

  get '/patient_treatments/add_patient_procedure' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient  }

    parameter :auth_token, 'Authentication Token',                             scope: :data,   required: true
    parameter :patient_id, 'Patient id',                                       scope: :data,   required: true
    parameter :code,       'Procedure code, the same code you will get back',  scope: :data,   required: true
    parameter :tooth_num,  'Tooth number',                                     scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:patient_id) { patient.id }
    let(:code)       { PROCEDURE_CODES.keys.first.to_s }
    let(:tooth_num)  { patient.tooth_tables.first.tooth_num }

    example_request 'Get tooth and procedure code for creating procedure' do
      expect(status).to eq 200
    end
  end

  post '/patient_treatments/create_procedure' do
    before do
      User.destroy_all
    end
    let(:provider)     { create :provider  }
    let(:procedure_ex) { create :procedure }
    let(:surface_ex)   { create :surface   }
    let(:pit_ex)       { create :pit       }
    let(:cusp_ex)      { create :cusp      }

    parameter :auth_token, 'Authentication Token',     required: true
    parameter :procedure,  'Procedure params',         required: true
    parameter :surface,    'Surface params',           required: true
    parameter :pit,        'Pit params',               required: true
    parameter :cusp,       'Cusp params',              required: true

    let(:auth_token) { provider.user.auth_token }
    let(:procedure)  { {
      procedure_code:  procedure_ex.procedure_code,
      description:     procedure_ex.description,
      date_of_service: procedure_ex.date_of_service,
      status:          procedure_ex.status
    } }
    
    let(:surface)  { {
      mesial:     surface_ex.mesial,
      incisal:    surface_ex.incisal,
      distal:     surface_ex.distal,
      lingual:    surface_ex.lingual,
      facial:     surface_ex.facial,
      class_five: surface_ex.class_five
    } }
    
    let(:pit)     { {
      mesial:        pit_ex.mesial,
      mesiobuccal:   pit_ex.mesiobuccal,
      mesiolingual:  pit_ex.mesiolingual,
      distal:        pit_ex.distal,
      distobuccal:   pit_ex.distobuccal,
      distolingual:  pit_ex.distolingual
    } }
    
    let(:cusp)       { {
        mesiobuccal:   cusp_ex.mesiobuccal,
        mesiolingual:  cusp_ex.mesiolingual,
        distobuccal:   cusp_ex.distobuccal,
        distolingual:  cusp_ex.distolingual
    } }

    example_request 'Get tooth and procedure code for creating procedure' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Procedure.last).to_json
    end
  end

  get '/patient_treatments/guarantor' do
    before do
      User.destroy_all
    end
    let(:provider) { create :provider }
    let(:patient)  { create :patient  }

    parameter :auth_token, 'Authentication Token',      scope: :data,   required: true
    parameter :patient_id, 'Patient id',                scope: :data,   required: true

    let(:auth_token) { provider.user.auth_token }
    let(:patient_id) { patient.id }

    example_request 'Get tooth and procedure code for creating procedure' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(patient.guarantor).to_json
    end
  end

  patch '/patient_treatments/update_guarantor' do
    before do
      User.destroy_all
    end
    let(:provider)     { create :provider  }
    let(:guarantor_ex) { create :guarantor }

    parameter :auth_token, 'Authentication Token',                           required: true
    parameter :guarantor,  'Guarantor params',                               required: true

    parameter :patient_id,     'Patient id',       scope: :guarantor,        required: true
    parameter :first_name,     'First name',       scope: :guarantor
    parameter :middle_name,    'Middle name',      scope: :guarantor
    parameter :last_name,      'Last name',        scope: :guarantor
    parameter :birth,          'Birth date',       scope: :guarantor
    parameter :gender,         'Gender',           scope: :guarantor
    parameter :social_number,  'Social number',    scope: :guarantor
    parameter :relation,       'Relation',         scope: :guarantor
    parameter :phone,          'Phone number',     scope: :guarantor
    parameter :email,          'Email',            scope: :guarantor
    parameter :street_address, 'Street address',   scope: :guarantor
    parameter :city,           'City',             scope: :guarantor
    parameter :state,          'State',            scope: :guarantor
    parameter :zip,            'Zip',              scope: :guarantor

    let(:auth_token) { provider.user.auth_token }
    let(:guarantor)  { {
      patient_id:      guarantor_ex.patient.id,
      first_name:      guarantor_ex.first_name,
      middle_name:     guarantor_ex.middle_name,
      last_name:       guarantor_ex.last_name,
      birth:           guarantor_ex.birth,
      gender:          guarantor_ex.gender,
      social_number:   guarantor_ex.social_number,
      relation:        guarantor_ex.relation,
      phone:           guarantor_ex.phone,
      email:           guarantor_ex.email,
      street_address:  guarantor_ex.street_address,
      city:            guarantor_ex.city,
      state:           guarantor_ex.state,
      zip:             guarantor_ex.zip
    } }

    example_request 'Update guarantor' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(Guarantor.find(guarantor_ex.id)).to_json
    end
  end

  patch '/patient_treatments/update_smoking_status' do
    before do
      User.destroy_all
    end
    let(:provider)          { create :provider  }
    let(:smoking_status_ex) { create :smoking_status }

    parameter :auth_token,         'Authentication Token',                               required: true
    parameter :smoking_status,     'Smoking status params',                              required: true

    parameter :smoking_status_id,  'Smoking status id',       scope: :smoking_status,    required: true
    parameter :effective_from,     'Effective from date',     scope: :smoking_status

    let(:auth_token) { provider.user.auth_token }
    let(:smoking_status)  { {
      smoking_status_id:  smoking_status_ex.id,
      status:             smoking_status_ex.status,
      effective_from:     smoking_status_ex.effective_from
    } }

    example_request 'Update smoking status' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(SmokingStatus.find(smoking_status_ex.id)).to_json
    end
  end

  patch '/patient_treatments/update_medical_history' do
    before do
      User.destroy_all
    end
    let(:provider)           { create :provider  }
    let(:medical_history_ex) { create :past_medical_history }

    parameter :auth_token,             'Authentication Token',                                    required: true
    parameter :past_medical_history,   'Medical history params',                                  required: true

    parameter :id,                     'Medical history id',       scope: :past_medical_history,  required: true
    parameter :major_events,           'Major events',             scope: :past_medical_history
    parameter :ongoing_problems,       'Ongoing problems',         scope: :past_medical_history
    parameter :preventitive_care,      'Preventitive care',        scope: :past_medical_history
    parameter :nutrition_history,      'Nutrition history',        scope: :past_medical_history
    parameter :developmental_history,  'Development history',      scope: :past_medical_history

    let(:auth_token) { provider.user.auth_token }
    let(:past_medical_history)  { {
        id:                     medical_history_ex.id,
        major_events:           medical_history_ex.major_events,
        ongoing_problems:       medical_history_ex.ongoing_problems,
        preventitive_care:      medical_history_ex.preventitive_care,
        nutrition_history:      medical_history_ex.nutrition_history,
        developmental_history:  medical_history_ex.developmental_history
    } }

    example_request 'Update past medical history' do
      expect(status).to eq 200
      expect(response_body).to eq JSONAPI::Serializer.serialize(PastMedicalHistory.find(medical_history_ex.id)).to_json
    end
  end

  patch '/patient_treatments/update_advanced_directive' do
    before do
      User.destroy_all
    end
    let(:provider)              { create :provider  }
    let(:advanced_directive_ex) { create :advanced_directive }

    parameter :auth_token,             'Authentication Token',                                      required: true
    parameter :advanced_directive,     'Advanced directive params',                                 required: true

    parameter :id,                     'Advanced directive id',       scope: :advanced_directive,   required: true
    parameter :record_date,            'Record date',                 scope: :advanced_directive
    parameter :notes,                  'Notes',                       scope: :advanced_directive

    let(:auth_token) { provider.user.auth_token }
    let(:advanced_directive)  { {
      id:          advanced_directive_ex.id,
      record_date: advanced_directive_ex.record_date,
      notes:       advanced_directive_ex.notes
    } }

    example_request 'Update advanced directive' do
      expect(status).to eq 200
      # expect(response_body).to eq JSONAPI::Serializer.serialize(AdvancedDirective.find(advanced_directive_ex.id)).to_json
    end
  end
end