Rails.application.routes.draw do
  devise_for :users, skip: [:sessions]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  as :user do
    get 'ingresar', to: 'devise/sessions#new', as: :new_user_session
    post 'ingresar', to: 'devise/sessions#create', as: :user_session
    match 'cerrarsesion', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
  end

  root to: "home#index"
end


