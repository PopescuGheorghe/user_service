require 'spec_helper'

describe BaseMailer do
  let(:base_mailer) { BaseMailer.new }
  subject { base_mailer }

  it 'should build content correctly' do
    params = { 'url' => 'www.google.ro', 'first_name' => 'Admin' }

    expected_result = [{ 'content' => 'www.google.ro', 'name' => 'url' }, { 'content' => 'Admin', 'name' => 'first_name' }]
    result = base_mailer.build_content(params)
    result.should eql expected_result
  end
  it 'should build message correctly' do
    params = { 'email' => 'admin@example.com', 'url' => 'www.google.ro' }

    expected_result =
    {
      'merge_vars' =>
        [{ 'vars' =>
          [{
            'content' => 'www.google.ro',
            'name' => 'url'
          }],
           'rcpt' => 'admin@example.com' }],
      'to' =>
        [{
          'type' => 'to',
          'email' => 'admin@example.com'
        }],
      'from_email' => 'no-reply@digital-education.com'
    }

    result = base_mailer.build_message(params)
    result.should eql expected_result
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

    MailingService.new.perform_welcome(params)
  end
end