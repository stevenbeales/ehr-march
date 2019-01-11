Rails.application.routes.draw do

  # Only for ENV=development
  # mount Logster::Web => "/logs"

  resources :providers do
    collection do
      get :schedule
      get :add_patient
      get :show_myaccount
      get :request_emergency_access
      patch :update_emergency_access
      get :set_emergency_access
      get :set_status
      get :invite_to_portal
      get :download_pdf
      get :send_invite_email
      get :add_patient_from_appointment
      post :save_message
      get :destroy_message
      get :prev_message
      get :next_message
      get :first_message
      get :patients
      get :lock
      post :unlock
    end
  end

  resources :patients,     only: [:index, :create, :update] do
    collection do
      post :simple_create
      get  :appointments_show
      get  :appointments_status_actions
      get  :new_appointment
      get  :provider_full_info
      get  :myprofile
      patch :update_myprofile
      get  :myhealth
      post :create_emergency_contact
    end
  end

  resources :appointments, only: [:new, :create, :update, :show, :destroy] do
    collection do
      get :referrals
      get :patients
      get :patient_full_info
      get :reschedule
    end
  end

  resources :block_outs, only: [:create]

  resources :referrals,  only: [:new, :create]

  resources :patient_appointments, only: [:create]

  resources :practices, only: [:new, :create, :edit, :update]

  resources :locations, only: [:create, :update] do
    collection do
      get :form
      get :primary_location
    end
  end

  resources :immunizations, except: [:destroy, :show] do
    collection do
      get  :name_block
      post :vaccines
    end
  end

  namespace :settings do
    get   :practice
    get   :access_permissions
    patch :update_permissions
    get   :set_admin
    get   :schedule
    patch :update_schedule
    get   :add_user_added_practice
    get   :set_practice_location_color
    get   :get_schedule_fields
    get   :update_schedule_fields
    get   :update_schedule_color_fields
    get   :add_schedule_fields
    get   :destroy_schedule_fields
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
      post :update_smoking_status
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
      patch :update_encounter
      get  :providers
      get  :procedures
      get  :procedure_codes
      get  :encounters
      get  :add_patient_procedure
      get  :show_patient_procedure
      post :create_procedure
      patch :update_procedure
      get  :encounter_full_info
      patch :update_guarantor
      post :create_payer
      post :create_insurance
      get :payers
      get :guarantor
    end
  end

  resources :representatives do
    collection do
      post :activate
    end
    member do
      post :reset_password
    end
  end

  resources :email_messages, only: [:index, :new, :create] do
    collection do
      get  :add_subject
      get :get_subjects
      get :update_subject
      get :remove_subject
      post :create_main
      post :create_to_practice
      post :create_from_patient_to_practice
      post :create_reply
      get  :patients
      get  :practices
      get  :patient_practices
      get :open_message
      get :new_message_to_patient
      get :forward_message_from_patient
      get :new_message_in_practice
      get :new_message_to_practice
      get :reply_to_message_in_practice_contacts
      get :forward_message_in_practice_contacts
      get :contacts
      get :contacts_pagination
      get :contacts_practices
      get :find_practices
      get :add_contact
      get :new_contact
      get :message
      get :new_tab
      get :to_archive
      get :delete_message
      get :search_message
      get :favorite_contact
      get :mark_as_read
    end
  end

  get 'landings/index'
  get 'admin/index'

  post 'text', to: 'text_messages#create'

  root to: 'landings#index'

  devise_for :users,
    path_names: {
      verify_authy: '/verify-token',
      enable_authy: '/enable-two-factor',
      verify_authy_installation: '/verify-installation'
    },
    controllers: {
      confirmations: 'confirmations',
      passwords:     'passwords',
      registrations: 'registration',
      sessions:      'sessions',
      devise_authy:  'authy'
    }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :calendars do
    collection do
      get :schedule
      get :open_reschedule
      patch :reschedule
      get :get_calendars
      get :filter
      get :new_appointment
      get :targets
    end
    member do
      post :move
      post :resize
    end
  end

  resources :tables, except: [:show] do
    collection do
      get :records
    end
  end

  namespace :sorter do
    get :appointments
    get :messages
    get :todos
  end

  namespace :dashboard do
    get :index
  end

  namespace :practice_sessions do
    get :sign_in
  end

  namespace :zipcode do
    post :city_set
    post :state_set
    post :zip_set
  end

  namespace :web_console do
    get :show_web_console_alert
  end

  match 'admin',    to: 'admin#index',  via: [:get]
  match 'explorer', to: 'tables#index', via: [:get]

  %w( 404 422 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

end
