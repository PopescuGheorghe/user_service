require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable, type: :controller do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe 'unauthorized authentication' do
    before do
      user = FactoryGirl.create :user
      authentication.stub(:current_user).and_return(nil)
      response.stub(:response_code).and_return(401)
      response.stub(:body).and_return({ success: false, 'errors' => I18n.t('api.response.unauthorized') }.to_json)
      authentication.stub(:response).and_return(response)
    end

    it 'renders a json error message' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:success]).to eql false
      expect(json_response[:errors]).to eql I18n.t('api.response.unauthorized')
      expect(response.response_code).to eql 401
    end
  end

  describe 'authorized authentication' do
    before do
      user = FactoryGirl.create :user
      authentication.stub(:current_user).and_return(user)
      response.stub(:response_code).and_return(200)
      response.stub(:body).and_return({ success: true }.to_json)
      authentication.stub(:response).and_return(response)
    end

    it 'renders successful response' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:success]).to eql true
      expect(response.status).to eql 200
    end
  end

  describe 'After 24h' do
    before do
      @user = FactoryGirl.create :user
      @user.generate_authentication_token!
      @user[:token_created_at] = Time.now - 25.hours
      @user.save!
    end

    it 'it should render unauthorized' do
      response = authentication.validate_token(@user.auth_token)
      expect(response).to eql false
    end
  end
end