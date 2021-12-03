class ApplicationController < ActionController::API

	# 404
	def not_found(errors=nil)
		if errors.nil?
			render json: {errors: "Resource not found"}, status: :not_found
		else
			render json: {errors: errors, }, status: :not_found
		end
	end

	#400
	def bad_request(errors=nil)
		if errors.nil?
			render json: {errors: "Bad request"}, status: :bad_request
		else
			render json: {errors: errors}, status: :bad_request
		end
	end
	
	# 401
	def unauthorized_request(errors=nil)
		if errors.nil?
			render json: {errors: "Unauthorized access"}, status: :unauthorized
		else
			render json: {errors: errors}, status: :unauthorized
		end
	end


	def require_auth
		header = request.headers['Authorization']
		header = header.split(' ').last if header
		begin
		  @decoded = JsonWebToken.decode(header)
		  @current_user = User.find(@decoded[:user_id])
		rescue ActiveRecord::RecordNotFound => e
			unauthorized_request(e.message)

		rescue JWT::DecodeError => e
			unauthorized_request(e.message) #Return erros: {1 : nil JSON web token}
		end
	end
end