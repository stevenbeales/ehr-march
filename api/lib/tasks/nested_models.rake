namespace :db do
  task nested_models: :environment do
    person = 'doctor'
    User.create(
      email:                  "#{person}@ehr1medical.com",
      password:               person,
      password_confirmation:  person,
      role:                   :Provider
    )

    person = 'patient'
    User.create(
      email:                  "#{person}@ehr1medical.com",
      password:               person,
      password_confirmation:  person,
      role:                   :Patient
    )
  end
end
