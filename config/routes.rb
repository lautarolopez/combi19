Rails.application.routes.draw do

  get 'tickets/edit'
  get 'tickets/update'
  devise_for :users, skip: [:sessions, :registrations, :passwords]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  as :user do
    get 'ingresar', to: 'devise/sessions#new', as: :new_user_session
    post 'ingresar', to: 'devise/sessions#create', as: :user_session
    match 'cerrarsesion', to: 'devise/sessions#destroy', as: :destroy_user_session, via: Devise.mappings[:user].sign_out_via
    get 'cancelarregistro', to: 'devise/registrations#cancel', as: :cancel_user_registration
    get 'registrarse', to: 'devise/registrations#new', as: :new_user_registration
    get 'perfil', to: 'devise/registrations#edit', as: :edit_user_registration
    patch 'registrarse', to: 'devise/registrations#update', as: :user_registration
    put 'registrarse', to: 'devise/registrations#update'
    delete 'registrarse', to: 'devise/registrations#destroy'
    post 'registrarse', to: 'devise/registrations#create'
    get 'contraseña/nueva', to: 'devise/passwords#new', as: :new_user_password
    get 'contraseña/editar', to: 'devise/passwords#edit', as: :edit_user_password
    put 'contraseña', to: 'devise/passwords#update', as: :user_password
    post 'contraseña', to: 'devise/passwords#create'

    ## Choferes
    get 'choferes', to: 'drivers#index', as: :drivers
    get 'chofer/:id', to: 'drivers#show', as: :driver
    get 'registrarchofer', to: 'drivers#new_driver', as: :new_driver_registration
    post 'registrarchofer', to: 'drivers#create_driver', as: :create_driver
    delete 'chofer/:id', to: 'drivers#destroy', as: :destroy_driver
  end

  resources :extras
  resources :cities
  resources :routes
  resources :combis
  resources :comments, only: [:index, :create,:new,:destroy]

  as :travel do
    get 'travels/step_new', to: 'travels#step_new', as: :step_new_travel
    get 'travels/:id/step_edit/', to: 'travels#step_edit', as: :step_edit_travel
    get 'travels/previous', to: 'travels#previous', as: :previous_travels
    get 'travels/history', to: 'travels#history', as: :travels_history
    get 'travels/booked', to: 'travels#booked', as: :booked_travels
    get 'travels/:id/book', to: 'tickets#book', as: :book_travel
    get 'travels/discarded', to: 'travels#discarded', as: :discarded_travels
    get 'travels/next', to: 'travels#next', as: :next_travel
    get 'travels/current', to: 'travels#current', as: :current_travel
    get 'travels/:id/delete_recurrrents', to: 'travels#destroy_recurrents', as: :destroy_recurrent_travels
  end
  resources :travels
  #as :payment_method do
    #get 'mismetodosdepago', to: 'payment_methods#index', as: :payment_methods
    #post 'mismetodosdepago', to: 'payment_method#create'
  #end
  # si le pongo metodos de pago medio que me generaba errores con las otras vistas, y personalizar todas las vistas me parece al pedo
  resources :payment_methods#, except: [:index, :create]

  as :payment_method do
    get 'solicitarsuscripción', to: 'payment_methods#new_subscription', as: :new_subscription
    post 'solicitarsuscripción', to: 'payment_methods#create_subscription', as: :create_subscription
    get 'payment_method/:id/cambiarsuscripción', to: 'payment_methods#change_subscription', as: :change_subscription
    get 'eliminarsuscripción', to: 'payment_methods#cancel_subscription', as: :cancel_subscription
  end
  
  resources :tickets, only: [:create, :destroy]
  as :ticket do
    get 'tickets/:id/passenger_absent', to: 'tickets#absent', as: :passenger_absent
    get 'tickets/:id/passenger', to: 'tickets#passenger', as: :ticket_passenger
    post 'tickets/:id', to: 'tickets#resolve', as: :resolve_ticket
    get 'ventaexpress', to: 'tickets#express_sell', as: :express_sell
    post 'registrarpasajero', to: 'tickets#create_passenger', as: :create_passenger
    post 'encontrarpasajero', to: 'tickets#find_passenger', as: :find_passenger
    post 'express_ticket', to: 'tickets#finish_ticket', as: :finish_ticket
  end

  post '/', to: 'home#contact', as: :contact_message

  root to: "home#index"
end