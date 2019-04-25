Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'homes#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post 'signup' => 'registrations#create'
        post 'signin' => 'sessions#create'
        post 'reset_password' => 'passwords#create'
        put 'update_password' => 'registrations#update'
        delete 'signout' => 'sessions#destroy'
        post 'invite_friend' => 'invitations#create'
        post 'social_authentication' => 'registrations#social_authentication'
      end

      resources :experiences, only: [:index, :show]
      resources :profiles, only: [:edit, :update, :show] do
        member do
          patch :upload_profile_picture
          patch :upload_ids
          #post :create_favourite
        end
        collection do
          get :show_review
        end
      end

      resources :bank_accounts, only: [:edit, :update, :show] do
        collection do
          get :edit
          put :update
        end
      end

      resources :users do
        member do
          post :create_favourite
        end
      end

      resources :categories, only: [] do
        member do
          get :get_property
        end
      end

      resources :places, only: [:index, :show] do
        collection do
          get :get_category_list
        end
        resources :reviews, only: [:index]
      end
      resources :messages, only: [:create]
      resources :account_settings, only: [:edit, :update, :show]
      resources :homes, only: [:index]
      get 'explore/:city' => 'homes#explore_city', :as => :explore_city
      get 'place/:city' => "places#index", :as => :destination_city
      get 'place/:id' => "places#show", :as => :show
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", :invitations => 'users/invitations', :sessions => 'users/sessions', :registrations => "users/registrations", :passwords => "users/passwords", :confirmations => "users/confirmations" }

  get 'place/:city' => "places#index", :as => :destination_city

  resources :places do
    member do
      get :back_step
      post :create_review
      get :address_validation
    end

    collection do
      get :location_fetch
    end
  end

  devise_scope :user do
    get 'failure', to: 'users/sessions#failure'
    get 'users' => 'users/registrations#new'
  end

  resources :experiences do
    collection do
      post :confirm_booking
      get :delete_item
    end
  end

  match '/experience/:category/',to: 'experiences#index',via: [:get], as: :selected_category
  match '/experience/:city/',to: 'experiences#index',via: [:get], as: :selected_city
  match '/experience/:city/:category',to: 'experiences#index',via: [:get], as: :selected_city_and_category

  resources :listings, only: [:index, :update, :show]

  resources :categories, only: [] do
    collection do
      post :get_property
    end
  end

  resources :account_settings, only: [:edit, :update] do
    collection do
      get :settings
      patch :deactivate_account
      patch :reactivate_account
    end

    member do
      get :reactivating_account
    end
  end

  resources :messages, only: [:index, :create, :show]

  get "search" => "homes#search"
  get 'explore/:city' => 'homes#explore_city', :as => :explore_city

  resources :staticpages, only: [] do
    collection do
      get :terms
      get :trust_and_safety
      get :payments_terms_of_service
      get :host_guarantee
      get :guest_refund
      get :ip_policy
      get :cookie_policy
      get :experiences_guest_relief_and_wavier
      get :non_discrimination_policy
      get :privacy_and_policy
      get :traveling_help
      get :how_it_works
      get :suggested_topic_content
      get :hospitality
    end
  end

  resources :profiles, only: [:edit, :update, :show] do
    collection do
      patch :update_trust_and_verification
      patch :generate_otp_for_phone_number_verification
      post :resend_otp
      post :verify_mobile_number
      post :disconnect_from_social_account
      post :connect_to_social_account
      get :show_review
      delete :delete_language
      post :create_favourite
      get :favourites
    end
    member do
      patch :upload_profile_picture
      get :set_profile_picture
      get :set_trust_and_verification
      patch :upload_ids
    end
  end

  resources :bookings do
    member do
      post :express_checkout
      get :after_paypal_chackout
      get :pay_via_braintree
      post :braintree_checkout
      get :check_booking
      post :accept
      post :decline
    end
    collection do
      get :download_invoice
      get :booking_invoice
      get :exp_booking_invoice
      get :booking_history
      get :transaction_history
      get :continue_pending_booking
    end
  end

  get 'booking_history_show/:data' => "bookings#booking_history_show", :as => :booking_history_show

  resources :payments, only: [:new, :create] do
    collection do
      get :confirmation
    end
  end

  get "experience" => "hosts#experience", as: :experience_landing
  get "home" => "hosts#home", as: :place_landing

  resources :bank_accounts, only: [] do
    collection do
      get :edit
      put :update
    end
  end

  resources :hosts, only: [] do
    member do
      get :hosted_places
      get :hosted_experiences
      get :transactions
      match :offers, via: [:get, :post]
      match :offer, via: [:get, :put]
      post :publish_n_unpublish
      get :view_detail
      match :manage_offer, via: [:get, :post]
      match :change_object_offers, via: [:get, :post]
      match :manage_offer_for, via: [:get, :post]
    end

    collection do
      get :dashboard
    end
  end

  get 'sign_out' => "devise/sessions#destroy", as: :sign_out
end
