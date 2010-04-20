module SessionsHelper
    def login (user)
        user.remember_me!
        
        cookies[:remember_token] = {
            :value   => user.remember_token,
            :expires => 23.years.from_now.utc
        }
        
        self.current_user = user
    end

    def logout
        cookies.delete(:remember_token)
        self.current_user = nil
    end

    def logged_in?
        !current_user.nil?
    end

    def current_user
        @current_user ||= user_from_remember_token
    end

    def current_user= (value)
        @current_user = value
    end

    def user_from_remember_token
        remember_token = cookies[:remember_token]
        User.find_by_remember_token(remember_token) unless remember_token.nil?
    end
end
