module Api
  module V1
    class UsersController < Api::BaseController
      before_filter :authenticate
      respond_to    :json

      swagger_controller :users, "Users"

      swagger_api :index do
        summary "Fetches all users"
        response :unauthorized
        response :not_acceptable
      end

      def index
       respond_with build_data_object(User.all)
      end

      swagger_controller :users, "Users"

      swagger_api :show do
        summary "Fetches user by id"
        param :path, :id, :integer, :required, "User ID"
        param :header, :Authorization, :required, "Authentication Token"
        response :unauthorized
        response :not_acceptable
      end

      def show
        respond_with build_data_object(User.find(params[:id]))
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: build_data_object(user), status: 201
        else
          render json: build_error_object(user), status: 403
        end
      end

      def destroy
        user = User.find(params[:id])
        if user.destroy
          render json: build_data_object(user), status: 201
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
