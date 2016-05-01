module Api
  module V1
    class PublicController < Api::BaseController
      respond_to :json

      def ping
        render json: { success:true }, status: 200
      end

    end
  end
end
