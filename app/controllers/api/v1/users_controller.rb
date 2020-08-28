class Api::V1::UsersController < ApplicationController
    before_action :find_user, only: [:profile, :update, :destroy]
    
    skip_before_action :authorized

    def index
        render json: User.all
    end

    def profile
        render json: { user: UserSerializer.new(current_user) }, status: :accepted
    end

    def create
        user = User.create!(user_params)

        if user.valid? 
            puts 'user is valid'
            token = encode_token(user_id: user.id)
            puts "token created"
            puts "token created"
            puts token
            render json: { user: UserSerializer.new(user) }, status: :created
        else 
            puts 'NOT VALID'
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

