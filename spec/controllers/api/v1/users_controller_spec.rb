require 'spec_helper'

describe Api::V1::UsersController, type: :controller do
  before :each do
    @user = FactoryGirl.create :user
    @auth_token = 'token123'
    request.headers['Authorization'] = @auth_token
  end

  describe 'GET #show' do
    it 'returns the information about a reporter on a hash' do
      get :show, id: @user.id, format: :json
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq 200
      expect(user_response[:data][:email]).to eql @user.email
    end
  end

  describe 'GET /me' do
    it 'returns the information about current user' do
      stub_request(:get, "http://localhost:3001/current_user").
        with(:headers => {'Authorization'=>'token123'}).
        to_return(:status => 200, :body => { 'success' => true, 'data' => { 'id' => @user.id}}.to_json, :headers => {"Content-Type"=> "application/json"})
      expected_response = {
        success: true,
        data:    {
          id:    @user.id,
          email: @user.email,
          role:  @user.role
        }
      }

      get :me, format: :json
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq 200
      expect(json_response).to eql expected_response
    end
  end

  describe 'GET #index' do
    it 'returns the information about all users on a hash' do
      user1 = FactoryGirl.create :user
      user2 = FactoryGirl.create :user

      expected_response = {
        success: true,
        data:    [
          {
            id:    @user.id,
            email: @user.email,
            role:  @user.role
          },
          {
            id:    user1.id,
            email: user1.email,
            role:  user1.role
          },
          {
            id:    user2.id,
            email: user2.email,
            role:  user2.role
          }
        ]
      }

      get :index, format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response.sort).to eql expected_response.sort
      expect(response.status).to eql 200
    end
  end

  describe 'POST #create' do
    it 'should successfully create an user' do
      user_attributes = FactoryGirl.attributes_for :user
      params = user_attributes

      expected_response = {
        success: true,
        data:
                 {
                   email: user_attributes[:email],
                   role:  user_attributes[:role]
                 }
      }
      post :create, email: params[:email], password: params[:password], role: params[:role], format: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      json_response[:data] = json_response[:data].except(:id, :auth_token)
      expect(response.status).to eql 201
      expect(json_response).to eql expected_response
    end

    it 'should render proper errors' do
      post :create, format: :json
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eql 422
      expect(json_response).to have_key(:errors)
    end
  end

  describe 'PUT/PATCH #update' do
    it 'should successfully update an user' do
      user = FactoryGirl.create :user
      user_attributes = FactoryGirl.attributes_for :user
      params = user_attributes
    end

    it 'should be possible to only update password' do
      user = FactoryGirl.create :user
      params = { id: user.id, password: 'newpassword', password_confirmation: 'newpassword' }

      patch :update, params, format: :json
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eql 200
      expect(user.reload.valid_password?(params[:password])).to eql true
    end

    it 'should render proper errors' do
      allow_any_instance_of(User).to receive(:update).and_return(false)
      user = FactoryGirl.create :user

      patch :update, id: user.id, format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response).to have_key(:errors)
      expect(response.status).to eql 422
    end
  end

  describe '#DELETE destroy' do
    it 'should successfully delete an user' do
      user = FactoryGirl.create :user

      delete :destroy, id: user.id, format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:success]).to eql true
      expect(json_response[:data]).to eql []
      expect(response.status).to eql 200
    end

    it 'should render proper errors' do
      allow_any_instance_of(User).to receive(:destroy).and_return(false)
      user = FactoryGirl.create :user

      delete :destroy, id: user.id, format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response).to have_key(:errors)
      expect(response.status).to eql 422
    end
  end
end
