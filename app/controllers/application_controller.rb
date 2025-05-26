class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  protect_from_forgery with: :null_session
  before_action :require_login

  private

  def require_login
    unless current_user
      # Allow access to login and registration pages only
      if login_or_registration_page?
        return
      end

      respond_to do |format|
        format.json { render json: { error: 'Требуется авторизация' }, status: :unauthorized }
        format.html { redirect_to root_path, alert: 'Пожалуйста, войдите в систему.' }
      end
    end
  end

  def login_or_registration_page?
    # Check if it's the root path (login page) or registration page
    request.path == '/' || request.path == '/registration'
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
