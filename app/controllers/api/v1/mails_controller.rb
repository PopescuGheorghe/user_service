module Api
  module V1
    class MailsController < Api::BaseController
      respond_to :json

      def create
        MailingService.new.send mailing_method, mail_params
        render json: build_data_object([]), status: 200
      end

      private

      def mail_params
        params.permit(:email, :template_slug, :url)
      end

      def mailing_method
        "perform_#{params[:template_slug]}"
      end
    end
  end
end