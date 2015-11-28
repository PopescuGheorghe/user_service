module Api
  module V1
    class UsersController < Api::BaseController
      before_filter :authenticate

      def index
       render json: build_data_object(User.all), status: 200
      end
    end
  end
end
