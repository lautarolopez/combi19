class HomeController < ApplicationController

	def index
    	if current_user != nil && current_user.role == 'driver'
    		@ticket = Ticket.new
    		@travel = current_user.current_travel
    		if @travel
    			redirect_to current_travel_path
    		else
                redirect_to next_travel_path
    		end
		else
			render 'index', :layout => 'home_layout'
		end
	end
	
	def contact
		TravelMailer.contact_mail(params[:name], params[:email], params[:message]).deliver_later
		flash[:success] = "Tu mensaje se envió con éxito, te contestaremos lo más pronto posible."
		redirect_back(fallback_location: root_path)
	end
end
