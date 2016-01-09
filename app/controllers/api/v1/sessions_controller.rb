module Api
  module V1
    class SessionsController < Api::BaseController
      respond_to :json

      def create
        user_password = params[:password]
        user_email    = params[:email]
        user          = User.find_by(email: user_email) if user_email.present?

        if user.present? and user.valid_password? user_password
          sign_in user
          user.generate_authentication_token!
          user.save

          render json: build_data_object(user), status: 200
        else
         fail InvalidAPIRequest.new(I18n.t('sessions.create.error'), 401)
        end
      end

      def destroy
        user = User.find_by(auth_token: params[:id])
        if user.present?
          user.generate_authentication_token!
          user.save
          head 204
        else
           fail InvalidAPIRequest.new(I18n.t('sessions.destroy.error'), 401)
        end
      end

      def sign_in(resource)
        Devise::Mapping.find_scope!(resource)
      end
    end
  end
end