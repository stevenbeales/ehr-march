Rails.application.routes.draw do
  devise_for :users,
    path_names: {
       verify_authy: '/verify-token',
       enable_authy: '/enable-two-factor',
       verify_authy_installation: '/verify-installation'
    },
    controllers: {
       devise_authy:  'authy'
    }

  root to: redirect('/apidocs')

  namespace :admin do
    get :index
  end

  resources :apidocs, only: [:index]

  resources :appointments, only: [:new, :create, :update, :show, :destroy] do
    collection do
      get :referrals
      get :patients
      get :patient_full_info
      get :reschedule
    end
  end

  resources :block_outs, only: [:create]

  resources :calendars do
    collection do
      get :schedule
      get :open_reschedule
      patch :reschedule
      get :get_calendars
      get :filter
      get :targets
    end
    member do
      get :move
      get :resize
    end
  end

  namespace :dashboard do
    get :index
  end

  resources :email_messages, only: [:index, :new, :create] do
    collection do
      get  :add_subject
      get :get_subjects
      get :update_subject
      get :remove_subject
      post :create_to_practice
      post :create_from_patient_to_practice
      post :create_reply
      get  :patients
      get  :patient_practices
      get :forward_message_from_patient
      get :practice
      get :contacts
      get :contacts_practices
      get :find_practices
      get :add_contact
      get :new_tab
      get :to_archive
      get :delete_message
      get :search_message
      get :favorite_contact
      get :mark_as_read
    end
  end

  namespace :errors do
    get :show
  end

  namespace :landings do
    get :index
  end

  resources :locations, only: [:create, :update] do
    collection do
      get :form
      get :primary_location
    end
  end

  resources :patient_appointments, only: [:create]
  resources :patients,     only: [:index, :create, :update] do
    collection do
      post :simple_create
      get  :new_appointment
      get  :provider_full_info
      get  :myhealth
      post :create_emergency_contact
    end
  end

  resources :patient_treatments, only: [:index] do
    collection do
      get  :search_patients
      get  :active_patients
      get  :show_patient_main
      get  :tooth_activity
      get  :show_patient_diagnoses
      get  :diagnosis_codes
      get  :show_patient_medications
      get  :add_patient_diagnoses
      post :create_diagnosis
      patch :update_diagnosis
      get  :add_patient_medications
      post :create_medication
      patch :update_medication
      get  :portions
      get  :medications
      get  :show_patient_allergy
      post :create_allergy
      patch :update_allergy
      get  :edit_patient_smoking
      patch :update_smoking_status
      get  :add_patient_medical_history
      patch :update_medical_history
      get  :add_patient_advanced_directives
      patch :update_advanced_directive
      get  :add_patient_insurance
      get  :add_patient_payer
      get  :show_patient_full_perio
      patch :update_full_perio
      get  :show_patient_perio_data_entry
      patch :update_tooth
      get  :set_tooth_bsp
      get  :add_patient_encounter
      post :create_patient_encounter
      get  :providers
      get  :procedure_codes
      get  :add_patient_procedure
      post :create_procedure
      get  :encounter_full_info
      patch :update_guarantor
      post :create_payer
      post :create_insurance
      get  :payers
      get  :guarantor
    end
  end

  resources :practices, only: [:new, :create, :edit, :update]

  resources :providers, only: [:index, :update] do
    collection do
      get :schedule
      get :add_patient
      get :download_pdf
      get :send_invite_email
      post :save_message
      get :prev_message
      get :next_message
      get :first_message
      get :patients
      get :lock
      post :unlock
    end
  end

  resources :referrals, only: [:new, :create]

  namespace :registration do
    post :create
  end

  namespace :sessions do
    post   :create
    delete :destroy
  end

  namespace :settings do
    get   :practice
    get   :access_permissions
    patch :update_permissions
    get   :set_admin
    get   :schedule
    patch :update_schedule
    get   :add_edit_location_schedule
    get   :add_user_added_practice
    get   :set_practice_location_color
  end

  namespace :sorter do
    get :appointments
    get :messages
    get :todos
  end

  resources :text_messages, only: [:create]

  namespace :zipcodes do
    get :city_set
    get :zip_set
  end
end
