class EmailsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    email = user.emails.build(email_params)
    if email.save
      render json: email, status: :created
    else
      render json: email.errors, status: :unprocessable_entity
    end
  end

  private

  def email_params
    params.require(:email).permit(:address)
  end
end
