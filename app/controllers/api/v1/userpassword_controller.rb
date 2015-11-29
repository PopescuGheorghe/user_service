class Api::V1::UserpasswordController < Api::BaseController

  def update
    user = User.find_by(id: params[:id])
    if user.update_with_password(user_params)
      render json: build_data_object(user), status: 200
    else
      render json: build_error_object(user), status: 403
    end
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
