module Api
  module V1
    class SessionsController < Api::BaseController
      respond_to :json

      def create
        user_password = params[:password]
        user_email    = params[:email]
        user          = User.find_by(email: user_email) if user_email.present?

        if user.present? && user.valid_password?(user_password)
          sign_in user
          response = AuthKey.new.generate_auth_key(user.id)
          user.auth_token = response.parsed_response['data']['token']
          user.save!
          render json: response.parsed_response, status: 200
        else
          raise InvalidAPIRequest.new(I18n.t('sessions.create.error'), 401)
        end
      end

      def destroy
        id = params[:id]
        response = AuthKey.new.delete_key(id)
        render json: response.parsed_response, status: response.code
      end

      def sign_in(resource)
        Devise::Mapping.find_scope!(resource)
      end
    end
  end
end
