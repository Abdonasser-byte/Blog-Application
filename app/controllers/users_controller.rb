class UsersController < ApplicationController

    skip_before_action :verify_authenticity_token
    def register
        @user = User.create(user_params)
        if @user.save
            response = { message: 'Created is done' }
            render json: response, status: :created
        else
            render json: @user.errors, status: :bad_request
        end
    end
    
    private

    def user_params
    params.permit(
        :name,
        :email,
        :password,
        :image
    )
    end

    def login
        authenticate(params[:email], params[:password])
    end

    def authenticate(email, password)
        command = AuthenticateUser.call(email, password)

        if command.success?
            render json: {
                access_token: command.result,
                message: 'Login Successful'
        }
        else
            render json: { error: command.errors }, status: :unauthorized
        end
    end
end
