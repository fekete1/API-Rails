class Api::V1::UsersController < ApplicationController
	before_action :find_user_by_id, except: [:create, :index]
	before_action :require_auth, only: [:index, :show, :destroy, :update]
	before_action :require_admin, only: [:destroy, :update]

	# GET /users
	def index
		@users = User.all
		json_response( payload = {users: @users}, status = :ok )
	end

	# GET /users/{id}
	def show
		json_response( payload = {user: @user}, status = :ok )
	end

	# POST /sign_up
	def create
		@user = User.new(user_params)
		if @user.save
			token = JsonWebToken.encode(user_id: @user.id)
			time = Time.now + 24.hours.to_i
			payload = { user: @user, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), user: @user}
			json_response( payload = payload, status = :created)
		else
			bad_request( errors = @user.errors.full_messages)
		end
	end

	# PATCH /users/{id}
	def update
		if @user.update(user_params) #TODO só pega se eu passar a senha
			json_response( payload = @user, status = :ok)
		else
			bad_request( errors = @user.errors.full_messages )
		end
	end

	# DELETE /users/{id}
	def destroy
		@user.destroy
		json_response( payload = {user: @user}, status = :ok)
	end

	def require_admin
		unless is_admin?
			unauthorized_request(errors = "User does not have sufficient permission administrative for this action")
		end
	end
	
	def current_user
		return @current_user
	end
	
	def is_admin?
		return current_user.admin
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


end