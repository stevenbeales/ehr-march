AdminService.create
puts "CREATED USER: Admin, #{Rails.application.secrets.admin_email}"

ProviderService.create
puts "CREATED USER: Provider, #{Rails.application.secrets.ehr_provider_email}"

PatientService.create
puts "CREATED USER: Patient, #{Rails.application.secrets.ehr_patient_email}"

PracticeService.create
puts "CREATED USER: Practice, #{Rails.application.secrets.ehr_practice_email}"
