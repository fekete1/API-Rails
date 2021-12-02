class Api::V1::UsersController < ApplicationController
	before_action :find_user, except: %i[create index]

	# GET /users
	def index
		@users = User.all
		render json: @users, status: :ok
	end

	# GET /users/{name}
	def show
		render json: @user, status: :ok
	end

	# POST /sign_in
	def create
		@user = User.new(user_params)
		if @user.save
			token = encode_token({user_id: @user.id})
		  	render json: {user: @user, token: token}, status: :created
		else
			render json: {errors: @user.errors.full_messages},
				 			status: :unprocessable_entity
		end
	end
  
	private

	def find_user
		@user = User.find_by_id!(params[:id])
		rescue ActiveRecord::RecordNotFound
		  render json: { errors: 'User not found' }, status: :not_found
	  end
  
	def user_params
	  params.permit(:name, :password, :email, :cpf)
	end
  
end