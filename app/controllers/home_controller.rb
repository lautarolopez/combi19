class HomeController < ApplicationController

    def index
    	if current_user != nil && current_user.role == 'driver'
    		@ticket = Ticket.new
    		@travel = current_user.driving_travels.pending.first
    		if @travel != nil && @travel.current
    			render 'travels/current'
    		else
    			render 'travels/next'
    		end
    	else
        	redirect_to travels_path
        end
    end
end
