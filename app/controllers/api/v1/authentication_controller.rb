class Api::V1::AuthenticationController < ApplicationController
  before_action :validate_params, only: [:login]
	before_action :login_params, only: [:login]

  class JsonWebToken
    SECRET_KEY = Rails.application.secrets.secret_key_base. to_s
  
    def self.encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
    end
  
    def self.decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new decoded
    end
  end

  # POST /auth/login
  def login
    @user = User.find_by_email((params[:email]))
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     name: @user.name }, status: :ok
    else
      render json: { error: 'errou' }, status: :unauthorized
    end
  end

  private

	def login_params
    #Accept login with name or emal
		request.params[:user] = ActiveSupport::HashWithIndifferentAccess.new(
			name: params[:name], email: params[:email], password: params[:password]
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
			render json: {errors: errors}, status: :bad_request
		end
	end
end
