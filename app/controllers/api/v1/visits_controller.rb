class Api::V1::VisitsController < ApplicationController
    before_action :require_auth
    before_action :require_admin, only: [:create]

    # GET /visits
    def index
        @visits = Visit.all
        render json: @visits, status: :ok
    end 

    # GET /visits/{id}
    def show
        render json: @visit, status: :ok
    end

    # POST /visits
    def create
        @visit = Visit.new(visit_params)

        if @visit.save
            render json: @visit, status: :created
        else
            bad_request( errors = @visit.errors.full_messages )
        end
    end

    # PATCH /visits/{id}
    def update
    end

    # DELETE /visits/{id}
    def destroy
    end

    private

    def find_visit_by_id
		@visit = Visit.find_by_id!(params[:id])
		rescue ActiveRecord::RecordNotFound
			not_found(errors = 'Visit not found')
	end
  
	def visit_params
	  params.permit(:data, :user_id, :status, :checkin_at, :checkout_at)
	end

end
