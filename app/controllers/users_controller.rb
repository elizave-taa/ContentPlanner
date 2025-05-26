class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_login, only: [:create]

  EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  PHONE_REGEX = /\A\+?\d{10,15}\z/

  def create
    unless params[:user][:email] =~ EMAIL_REGEX
      return render json: { error: 'Некорректный формат электронной почты' }, status: :unprocessable_entity
    end
    unless params[:user][:phone_number] =~ PHONE_REGEX
      return render json: { error: 'Некорректный формат номера телефона' }, status: :unprocessable_entity
    end
    if params[:user][:password] != params[:user][:password_confirmation]
      return render json: { error: 'Пароль и подтверждение не совпадают' }, status: :unprocessable_entity
    end

    user = User.new(user_params)
    if user.save
      render json: { user: user.slice(:id, :username, :email, :phone_number) }, status: :created
    else
      render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :password, :password_confirmation)
  end
end
