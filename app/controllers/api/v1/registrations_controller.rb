class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(register_params)

    resource.save
    if resource.persisted?		
      render json: {}, status: :created
    else
      render json: {errors: resource.errors.full_messages}, status: :bad_request
    end
  end

  private

  def register_params
		params.permit(
			:name, :password, :email, :cpf
		)
  	end
end
