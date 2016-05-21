require 'spec_helper'

describe Api::BaseController, type: :controller do
  it 'creates abilty for current_user' do
    user = FactoryGirl.create :user
    allow_any_instance_of(Api::BaseController).to receive(:current_user).and_return user
    expect(Api::BaseController.new.current_ability).to be_a_kind_of(Admin)
  end
end
