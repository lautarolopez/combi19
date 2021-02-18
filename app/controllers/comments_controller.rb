class CommentsController < ApplicationController
	def new
		@comment = Comment.new
		@travel = Travel.find(params[:id])
	end

	def create
		@comment = Comment.create(params.require(:comment).permit(:text, :travel_id))
		@comment.user = current_user
		@travel = @comment.travel
		@duration = calculate_duration(@travel.date_departure, @travel.date_arrival)
        @comments = @travel.comments
        @ticket = Ticket.find_by(travel: @travel, user: current_user)
        if @ticket == nil
            @ticket = Ticket.new
        end

		if @comment.save
			flash[:successes] = []
			flash[:successes] << "Comentario creado con éxito!"
			redirect_to travel_path(@comment.travel)
		else
			if @comment.errors
				flash[:form_error] = @comment.errors.full_messages
			else
				if @comment.text == nil					
					flash[:form_error] = "El comentario no puede estar vacio."
				else 
					flash[:form_error] = "Algo salió mal."
				end
			end
			render 'travels/show'
		end
	end

	def index
		@comments = Comment.all
	end

	def destroy
		@comment = Comment.find(params[:id])
		@travel = @comment.travel
		if @comment.destroy
			flash[:success]=[]
			flash[:success] << "El comentario ha sido borrado con éxito!"
		else
			flash[:error] = "Algo salió mal"
		end		
		redirect_to travel_path(@travel)
	end

	def calculate_duration(departure, arrival)
        duration_hours = ((arrival.to_time - departure.to_time) / 1.hour).floor
        duration_minutes = (((arrival.to_time - departure.to_time) / 1.minute).round) - (duration_hours * 60)
        duration = [duration_hours, duration_minutes]
        return duration
    end
end
