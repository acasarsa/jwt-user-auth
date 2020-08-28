class ApplicationController < ActionController::API
    before_action :authorized

    def encode_token(payload)
        JWT.encode(payload, 'my_s3cript')
    end

    def auth_header
        request.headers['Authorization']
    end

    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                # allows us to rescue out of an exception in Ruby. if invalid token occurs this returns nil instead of crashing server
                JWT.decode(token, 'my_s3cr3t', true, algorithm: 'HS256')
            rescue JWT::DecodeError
                puts "FAILED"
                puts "FAILED"
                puts "FAILED"
                puts "FAILED"
                nil
            end
        end
    end

    def current_user 
        if decoded_token
            user_id = decoded_token[0]['user_id']
            user = User.find_by(id: user_id)
            user
        end
    end

    def logged_in?
        !!current_user
    end

    def authorized
        puts 'IN APPLICATION CONTROLLER DOING AUTHORIZED METHOD!!'
        puts 'IN APPLICATION CONTROLLER DOING AUTHORIZED METHOD!!'
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

end
