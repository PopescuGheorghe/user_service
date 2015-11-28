module Api
  module V1
    class UsersController < Api::BaseController
      before_filter :authenticate

      def index
       render json: build_data_object(User.all), status: 200
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: build_data_object(user), status: 200
        else
          render json: build_error_object(user), status: 403
        end
      end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end

    end
  end
end
