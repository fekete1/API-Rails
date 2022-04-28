class ApplicationController < ActionController::API

	def json_response( payload ,status, errors=nil )

		if errors.nil? #Sucessfull request
			render json: {status: "sucess", payload: payload}, status: status
		else #Failed request
			render json: {status: "failure", payload: payload, errors: errors}, status: status
		end
	end

	# 404
	def not_found(errors=nil)
		if errors.nil?
			json_response(errors = "Resource not found", status = :not_found)
		else
			json_response(errors =  errors , status = :not_found)
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
		auth_error = "Invalid authentication"
		
		begin
		  @decoded = JsonWebToken.decode(header)
		  @current_user = User.find(@decoded[:user_id])
		rescue ActiveRecord::RecordNotFound => e
			unauthorized_request([auth_error, e.message])
		rescue JWT::DecodeError => e
			unauthorized_request([auth_error, e.message]) #Return JWT errors
		end
	end

end