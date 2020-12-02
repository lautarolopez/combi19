class CommentsController < ApplicationController
	def new
		@comment = Comment.new
	end

	def create
		@comment = Comment.create(params.require(:comment).permit(:text, :travel, :user));

		if @comment.save
			flash[:success] = "Comentario creado con éxito!"
			#redirect_to comments_path
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

		if @comment.destroy
			flash[:success] = "El comentario ha sido borrado con éxito!"
		else
			flash[:index_error] = "Algo salió mal"
		end		
		#redirect_to comments_path
	end
end
