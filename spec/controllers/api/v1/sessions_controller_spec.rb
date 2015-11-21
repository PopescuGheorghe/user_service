require 'spec_helper'

describe Api::V1::SessionsController do
  describe 'POST #create' do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when the credentials are correct' do
      before(:each) do
        credentials = { email: @user.email, password: @user.password }
        post :create, credentials
      end

      it 'returns the user record corresponding to the given credentials' do
        @user.reload

        expected_response = {
          'success' => true,
          'data' => {
            id: @user.id,
            email: @user.email,
            auth_token: @user.auth_token
          }
        }

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data]).to eql expected_response['data']
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        credentials = { email: @user.email, password: 'invalidpassword' }
        post :create, credentials
      end

      it 'returns a json with an error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to eql I18n.t('sessions.create.error')
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      @user.generate_authentication_token!
      @user.save
      sign_in @user
      delete :destroy, id: @user.auth_token
    end

    it { should respond_with 204 }
  end
end