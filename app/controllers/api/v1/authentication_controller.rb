class Api::V1::AuthenticationController < ApplicationController
	before_action :validate_params, only: [:login]
	before_action :login_params, only: [:login]
  

	def login
    	@user = User.find_by_email((params[:email]))
    	if @user&.authenticate(params[:password])
      		token = JsonWebToken.encode(user_id: @user.id)
      		time = Time.now + 24.hours.to_i
			payload = { user: @user, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), user: @user}
			json_response( payload = payload, status = :created ) 
		else
    		bad_request( errors = 'Login or password invalid' )
    	end
  	end

	private

	def login_params #TODO
    #Accept login with name or email 
		request.params[:user] = ActiveSupport::HashWithIndifferentAccess.new(
			email: params[:email], cpf: params[:cpf], password: params[:password]
		)
	end

  def validate_params
		# Conditions to test and error code if not pass
		conditions = [
			[(params[:name].present? or params[:email].present?), "E-mail or cpf is required"],
			[params[:password].present?, "Password can't be blank"],
			[(params[:name].instance_of?(String) or params[:email].instance_of?(String)), "Invalid parameters"],
			[params[:password].instance_of?(String), "Invalid parameters"]
		]

		errors = conditions.collect { |condition| (condition[1]) unless condition[0] }
		errors = errors.uniq.compact
		unless errors.empty?
			bad_request( errors: errors )
		end
	end
end
