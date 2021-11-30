class Api::V1::SessionsController < Devise::SessionsController
  before_action :validate_params, only: [:create]
	before_action :pass_params_to_user, only: [:create]

  respond_to :json

  def create
		self.resource = warden.authenticate(auth_options)
		if resource.nil?
			unauthorized_request("Login or password incorrect")

		else
			sign_in(resource_name, resource)
			payload = {token: jwt_token}
			render json: {payload: payload}, status: :ok
		end
	end

	def respond_to_on_destroy
		head :no_content
	end

	private

	def pass_params_to_user
    #Accept login with name or emal
		request.params[:user] = ActiveSupport::HashWithIndifferentAccess.new(
			name: params[:name], email: params[:email], password: params[:password]
		)
	end

	def jwt_token
		request.env['warden-jwt_auth.token']
	end

	def validate_params
		# Conditions to test and error code if not pass
		conditions = [
			[(params[:name].present? or params[:email].present?), "Name or E-mail is required"],
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