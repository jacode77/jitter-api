class UsersController < ApplicationController

    # create user details from form
    def create
        @user = User.new(user_params)
        # by default all users are set to false for admin
        @user.is_admin = false
        
        if @user.save
            auth_token = Knock::AuthToken.new payload: {sub: @user.id}
            render json: {username: @user.username, jwt: auth_token.token}, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def sign_in
        @user = User.find_by_email(params[:email])
        if @user && @user.authenticate(params[:password])
            auth_token = Knock::AuthToken.new payload: {sub: @user.id}
            render json: {username: @user.username, jwt: auth_token.token}, status: 200
        else
            # could be more specific but can be better for security to be general
            render json: {error: "Invalid email or password"}
        end
    end

    private

    def user_params
        params.permit(:username, :email, :password, :password_confirmation)
    end
end
