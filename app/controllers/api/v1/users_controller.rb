class Api::V1::UsersController < ApplicationController
	before_action :find_user_by_id, except: [:create, :index]
	before_action :require_auth, only: [:index, :show, :destroy, :update]
	before_action :require_admin, only: [:destroy, :update]

	# GET /users
	def index
		@users = User.all
		render json: @users, status: :ok
	end

	# GET /users/{id}
	def show
		render json: @user, status: :ok
	end

	# POST /sign_up
	def create
		@user = User.new(user_params)
		if @user.save
			token = JsonWebToken.encode(user_id: @user.id)
			time = Time.now + 24.hours.to_i
			render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
				name: @user.name}, status: :ok  #TODO melhorar a padronização de resposta
		else
			bad_request( errors = @user.errors.full_messages)
		end
	end

	# PATCH /users/{id}
	def update
		if @user.update(user_params) #TODO só pega se eu passar a senha
			render json: @user, status: :ok
		else
			render json: { errors: @user.errors.full_messages },
				 			status: :unprocessable_entity 		#TODO trocar isso depois e padronizar
		end
	end

	# DELETE /users/{id}
	def destroy
		@user.destroy
		render json: @user, status: :ok
	end
	 
	def require_admin
		unless is_admin?
			unauthorized_request(errors = "User does not have sufficient permission administrative for this action")
		end
	end

	private

	def find_user_by_id
		@user = User.find_by_id!(params[:id])
		rescue ActiveRecord::RecordNotFound
			not_found(errors = 'User not found')
	end
  
	def user_params
	  params.permit(:name, :password, :email, :cpf)
	end

	def current_user
		return @current_user
	end
	
	def is_admin?
		return current_user.admin
	end
end