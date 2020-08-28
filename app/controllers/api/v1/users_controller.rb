class Api::V1::UsersController < ApplicationController
    before_action :find_user, only: [:update, :destroy]
    # byebug
    skip_before_action :authorized

    def profile
        render json: User.all
    end

    def create
        user = User.create(user_params)
        if user.valid? 
            token = encode_token(user_id: user.id)
            render json: { user: UserSerializer.new(user) }, status: :created
        else 
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end

    def update
        # add routes
        user.update(user_params)

        if user.valid?
            token = encode_token(user_id: user.id)
            render json: { user: UserSerializer.update(user) }, status: :updated
        else 
            render json: { error: 'failed to update user' }, status: :not_acceptable
        end
    end

    def destroy
        # add routes
        token = encode_token(user_id: user.id)
        user.destroy
    end

    private 

    def find_user
        user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :password, :bio, :avatar )
    end

end

