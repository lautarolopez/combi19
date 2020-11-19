<<<<<<< Updated upstream
class CombisController < ApplicationController
	def new
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
		@combi = Combi.new
	end

	def create
		@combi = Combi.create(params.require(:combi).permit(:licence_plate, :category));

		if @combi.save
			flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido creada con éxito!"
			redirect_to combis_path
		else
			@aux = Combi.find_by(licence_plate: @combi.licence_plate)
			if @aux != nil
				flash[:error] = "La combi " + @combi.licence_plate + " ya existe."
			else 
				flash[:error] = "Algo salió mal."
=======
	class CombisController < ApplicationController
		def new
			if current_user == nil || current_user.role != "admin"
				redirect_to root_path
			end
			@combi = Combi.new
		end

		def create
			@combi = Combi.create(params.require(:combi).permit(:licence_plate, :category));

			if @combi.save
				flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido creada con éxito!"
				redirect_to combis_path
			else
				@aux = Combi.find_by(licence_plate: @combi.licence_plate)
				if @aux != nil
					flash[:error] = "La combi " + @combi.licence_plate + " ya existe."
				else 
					if @combi.licence_plate == ""
						flash[:error] = "Falta definir la patente."
					else
						flash[:error] = "Algo salió mal."
					end
				end
				render 'new'
>>>>>>> Stashed changes
			end
		end

<<<<<<< Updated upstream
	def index
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
		@combis = Combi.all
	end

	def edit
		if current_user == nil || current_user.role != "admin"
			redirect_to root_path
		end
		@combi = Combi.find(params[:id])
	end

	def update
		@combi = Combi.find(params[:id])
		
		parametros=params.require(:combi).permit(:licence_plate, :category)
		
		if @combi.update(parametros)
			flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido actualizada con éxito!"
			redirect_to combis_path
        else
			@aux = Combi.find_by(licence_plate: @combi.licence_plate)
			if @aux != nil
				flash[:error] = "La combi " + @combi.licence_plate + " ya existe."
			else 
				flash[:error] = "Algo salió mal."
=======
		def index
			if current_user == nil || current_user.role != "admin"
				redirect_to root_path
			end
			@combis = Combi.all
		end

		def edit
			if current_user == nil || current_user.role != "admin"
				redirect_to root_path
			end
			@combi = Combi.find(params[:id])
		end

		def update
			@combi = Combi.find(params[:id])
			
			parametros=params.require(:combi).permit(:licence_plate, :category)
			
			if @combi.update(parametros)
				flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido actualizada con éxito!"
				redirect_to combis_path
			else				
				if @combi.licence_plate == ""
					flash[:error] = "Falta definir la patente."
				else 
					@aux = Combi.find_by(licence_plate: @combi.licence_plate)
					if @aux != nil
						flash[:error] = "La combi " + @combi.licence_plate + " ya existe."
					else
						flash[:error] = "Algo salió mal."
					end
				end
				render 'edit'
>>>>>>> Stashed changes
			end
		end
<<<<<<< Updated upstream
	end

	def destroy
		@combi = Combi.find(params[:id])
		if (@combi.travels.count > 0)
			flash[:error] = "Combi " + @combi.licence_plate + ", " + @combi.category + " no se puede borrar porque tiene viajes asociados"
		else
			if @combi.destroy
				flash[:success] = "La combi " + @combi.licence_plate + ", " + @combi.category + " ha sido borrada con éxito!"
			else
				if (!flash[:error])
					flash[:error] = "Algo salió mal"
				end
			end
		end
		redirect_to combis_path
	end
end
=======

		def destroy
			@combi = Combi.find(params[:id])
			if (@combi.travels.count > 0)
				flash[:error] = "Combi " + @combi.licence_plate + ", " + @combi.category + " no se puede borrar porque tiene viajes asociados"
			else
				if @combi.destroy
					flash[:success] = "La combi " + @combi.licence_plate + ", " + @combi.category + " ha sido borrada con éxito!"
				else
					if (!flash[:error])
						flash[:error] = "Algo salió mal"
					end
				end
			end
			redirect_to combis_path
		end
	end
>>>>>>> Stashed changes
