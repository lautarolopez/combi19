Rails.application.routes.draw do
  get 'combis/new'
  get 'combis/index'
  get 'combis/edit'
  devise_for :users, skip: [:sessions, :registrations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  as :user do
    get 'ingresar', to: 'devise/sessions#new', as: :new_user_session
    post 'ingresar', to: 'devise/sessions#create', as: :user_session
    match 'cerrarsesion', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
    get 'cancelarregistro', to: 'devise/registrations#cancel', as: :cancel_user_registration
    get 'registrarse', to: 'devise/registrations#new', as: :new_user_registration
    get 'editarregistro', to: 'devise/registrations#edit', as: :edit_user_registration
    patch 'registrarse', to: 'devise/registrations#update', as: :user_registration
    put 'registrarse', to: 'devise/registrations#update'
    delete 'registrarse', to: 'devise/registrations#destroy'
    post 'registrarse', to: 'devise/registrations#create'
  end

  resources :extras
  resources :cities
  resources :routes
  resources :combis

  root to: "home#index"
end


