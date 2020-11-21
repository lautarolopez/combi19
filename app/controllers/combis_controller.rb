	class CombisController < ApplicationController
		def new
			if current_user == nil || current_user.role != "admin"
				redirect_to root_path
			end
			@combi = Combi.new
		end

		def create
			@combi = Combi.create(params.require(:combi).permit(:licence_plate, :category, :capacity));

			if @combi.save
				flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido creada con éxito!"
				redirect_to combis_path
			else
				flash[:form_error] = []
				if @combi.errors
					if @combi.errors[:licence_plate] != []
						flash[:form_error] << "Patente " + @combi.errors[:licence_plate][0]
					end
					if @combi.errors[:capacity] != []
						flash[:form_error] << "La capacidad " + @combi.errors[:capacity][0]
					end
				else
					@aux = Combi.find_by(licence_plate: @combi.licence_plate.upcase)
					if @aux != nil
						flash[:form_error] << "La combi " + @combi.licence_plate.upcase + " ya existe."
					else 
						flash[:form_error] << "Algo salió mal."
					end
				end
				render 'new'
			end
		end

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
			@combi.attributes = params.require(:combi).permit(:licence_plate, :category, :capacity)
			
			if @combi.save
				flash[:success] = "Combi " + @combi.licence_plate + ", " + @combi.category + " ha sido actualizada con éxito!"
				redirect_to combis_path
			else	
				flash[:form_error] = []
				if @combi.errors
					if @combi.errors[:licence_plate] != []
						flash[:form_error] << "Patente " + @combi.errors[:licence_plate][0]
					end
					if @combi.errors[:capacity] != []
						flash[:form_error] << "La capacidad " + @combi.errors[:capacity][0]
					end
				else
					@aux = Combi.find_by(licence_plate: @combi.licence_plate.upcase)
					if @aux != nil
						flash[:form_error] << "La combi " + @combi.licence_plate.upcase + " ya existe."
					else 
						flash[:form_error] << "Algo salió mal."
					end
				end
				render 'edit'
			end
		end

		def destroy
			@combi = Combi.find(params[:id])
			if (@combi.travels.count > 0)
				flash[:index_error] = "Combi " + @combi.licence_plate + ", " + @combi.category + " no se puede borrar porque tiene viajes asociados"
			else
				if @combi.destroy
					flash[:success] = "La combi " + @combi.licence_plate + ", " + @combi.category + " ha sido borrada con éxito!"
				else
					flash[:index_error] = "Algo salió mal"
				end
			end
			redirect_to combis_path
		end
	end
