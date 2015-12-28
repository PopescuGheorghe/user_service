require 'spec_helper'

describe Api::V1::UsersController do
  describe 'create' do
    it 'should render proper errors' do
      User.any_instance.stub(:destroy).and_return(false)
      user = FactoryGirl.create :user
      binding.pry
      delete :destroy, id: user.id, format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:success]).to eql false
      expect(response.status).to eql 403
    end
  end
end
