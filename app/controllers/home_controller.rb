class HomeController < ApplicationController

    def index
    	if current_user != nil && current_user.role == 'driver'
    		@ticket = Ticket.new
    		@travel = Travel.future.where(driver: current_user).first
    		render 'drivers_home'
    	else
        	redirect_to travels_path
        end
    end
end
