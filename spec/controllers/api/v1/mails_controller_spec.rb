require 'spec_helper'

describe Api::V1::MailsController do
  describe 'Welcome email' do

    it 'should validate params' do

      post :create, template_slug: "welcome" ,format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eql 403
      expect(json_response[:errors][0]).to eql "Error params"
    end

    it 'should validate presence of user' do

      post :create, email: "wrong@mail.com", template_slug: "welcome", url:"", format: :json

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eql 403
      expect(json_response[:errors][0]).to eql "Error user"
    end
    it 'does something' do
      message = {"merge_vars"=>[{"vars"=>[{"content"=>"www.google.ro", "name"=>"url"}], "rcpt"=>"user@example.com"}],
             "to"=>[{"type"=>"to", "email"=>"user@example.com"}],
             "from_email"=>"no-reply@digital-education.com"}

      template_content = [{"content"=>"www.google.ro", "name"=>"url"}]

      BaseMailer.any_instance.stub(:send_mail).and_return('success')
      #expect(obj.send_mail('welcome', 'template_content', 'messages')).to eql 'success'
      user = FactoryGirl.create :user
      params = {email: user.email, template_slug: "welcome",url: "www.google.ro"}

      post :create, email: user.email, template_slug: "welcome", url:"", format: :json
    end
  end
end