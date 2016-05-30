require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:role) }
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to be_valid }
end
