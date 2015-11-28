class Api::V1::UserpasswordController < Api::BaseController

  def update
    @user = User.find_by(id: params[:id])
    binding.pry
    if @user.update(params)
      render json: build_data_object(@user), status: 200
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password)
  end
end
