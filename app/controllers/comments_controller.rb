class CommentsController < ApplicationController
	def new
		@comment = Comment.new
		@travel = Travel.find(params[:id])
		@travels = Travel.where(id: @travel.id)
	end

	def create
		@comment = Comment.create(params.require(:comment).permit(:text,:travel_id))
		@comment.user = current_user

		if @comment.save
			flash[:success] = []
			flash[:success] << "Comentario creado con éxito!"
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
			render 'new'
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
end
