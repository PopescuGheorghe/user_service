class Api::V1::UserpasswordController < Api::BaseController

  def update
    @user = User.find_by(id: params[:id])

    # ToDO check for password match

    if @user.update(user_params)
      render json: build_data_object(@user), status: 200
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password)
  end
end
