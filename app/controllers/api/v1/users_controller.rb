module Api
  module V1
    class UsersController < Api::BaseController
      respond_to    :json

      def index
        query = 'SELECT row_to_json(u)
                         FROM (
                           SELECT id, email, role FROM users
                         ) u'
         users =  ActiveRecord::Base.connection.execute(query).values.flatten
         users.map!{ |x| JSON.parse(x) }
         render json:  { success: true, data: users} , status: 200
      end

      def show
        respond_with build_data_object(User.find(params[:id]))
      end

      def me
        respond_with build_data_object(current_user)
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: build_data_object(user), status: 201
        else
          render json: build_error_object(user), status: 422
        end
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: build_data_object(user), status: 200
        else
          render json: build_error_object(user), status: 422
        end
      end

      def destroy
        user = User.find(params[:id])
        if user.destroy
          render json: build_data_object([]), status: 200
        else
          render json: build_error_object(user), status: 422
        end
      end

      private

      def user_params
        params.permit(:email, :password, :role)
      end
    end
  end
end
