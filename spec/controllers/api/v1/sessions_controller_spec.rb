require 'spec_helper'

describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    before(:each) do
      @user = FactoryGirl.create :user
      @base_uri = ENV['authorization_service']
    end

    context 'when the credentials are correct' do
      before(:each) do
        stub_request(:post, "#{@base_uri}/generate_key")
          .with(body: "id=#{@user.id}")
          .to_return(status: 200, body: {
            'success' => true,
            'data' => {
              'token' => 'token123'
            }
          }.to_json, headers: {})
        credentials = { email: @user.email, password: @user.password }
        post :create, credentials, format: :json
      end

      it 'returns the user record corresponding to the given credentials' do
        @user.reload

        expected_response = {
          'success' => true,
          'data'    => {
            token: 'token123'
          }
        }

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:data]).to eql expected_response['data']
        expect(response.status).to eql 200
      end
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        post :create, email: @user.email, password: 'invalidpassword', format: :json
      end

      it 'returns a json with an error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).to have_key(:errors)
        expect(response.status).to eql 401
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user
    end

    context 'when the credentials are correct' do
      before(:each) do
      stub_request(:delete, "#{ENV['authorization_service']}/delete_key/token123").
         to_return(:status => 200, :body => "", :headers => {})
        delete :destroy, id: 'token123'
      end

      it { should respond_with 200 }
    end
  end
end
