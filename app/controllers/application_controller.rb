class ApplicationController < ActionController::API

	def not_found
		render json: format_response(errors: "Resource not found"), status: :not_found
	end

	def unauthorized_request(errors=nil)
		if error_code.nil?
			render json: {errors: "Unauthorized access"}, status: :unauthorized
		else
			render json: {errors: errors}, status: :unauthorized
		end
	end

	def authorize_request
		header = request.headers['Authorization']
		header = header.split(' ').last if header
		begin
		  @decoded = JsonWebToken.decode(header)
		  @current_user = User.find(@decoded[:user_id])

		rescue ActiveRecord::RecordNotFound => e
			unauthorized_request(e.message)

		rescue JWT::DecodeError => e
			unauthorized_request(e.message)
		end
	  end
  
end