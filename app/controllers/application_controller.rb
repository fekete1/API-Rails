class ApplicationController < ActionController::API

	def unauthorized_request(error_code=nil)
		if error_code.nil?
			render json: {errors: "Unauthorized access"}, status: :unauthorized
		else
			render json: {errors: error_code}, status: :unauthorized
		end
	end
end