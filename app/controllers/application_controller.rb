class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    
    protected
        # Make current_user available in templates as a helper
        helper_method :current_user
        
        # Make logged_in? available in templates as a helper
        helper_method :logged_in?
      
        # Returns the currently logged in user or nil if there isn't one
        def current_user
            return unless session[:user_id]
            @current_user ||= User.find_by_id(session[:user_id])
            ## @current_user доступен в тех контроллерах где вызывается или среди всех наследников апплик
            ## откуда берется :user_id для сессии
        end
      
      
        # Filter method to enforce a login requirement
        # Apply as a before_action on any controller you want to protect
        def authenticate
            logged_in? || access_denied
        end
      
        # Predicate method to test for a logged in user
        def logged_in?
            current_user.is_a? User
        end
      
        def access_denied
            redirect_to login_path, notice: "Please log in to continue" and return false
        end
end