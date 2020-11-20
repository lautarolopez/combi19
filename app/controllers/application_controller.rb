class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    add_flash_types	:form_error, :index_error

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :last_name, :dni, :birth_date])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    end
end
