class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_login, only: [:create, :destroy]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { user: user.slice(:id, :username, :email, :phone_number) }, status: :ok
    else
      render json: { error: 'Неверная почта или пароль' }, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Вы успешно вышли из системы'
  end
end
