require 'spec_helper'
require 'cancan_matchers'

describe 'User' do
  describe 'abilities' do
    context 'when is an admin' do
      user = FactoryGirl.create :user, :admin
      subject(:ability) { Ability.build_ability_for(user) }
      other_user = FactoryGirl.create :user
      it { is_expected.to have_abilities([:create, :read, :update, :destroy, :password, :me], user) }
      it { is_expected.to have_abilities([:create, :read, :update, :destroy, :password, :me], other_user) }
    end
    context 'when is an normal user' do
      user = FactoryGirl.create :user, :normal
      subject(:ability) { Ability.build_ability_for(user) }
      other_user = FactoryGirl.create :user
      it { is_expected.to have_abilities([:create, :read, :update, :destroy, :password, :me], user) }
      it { is_expected.to not_have_abilities([:create, :update, :destroy, :password, :me], other_user) }
      it { is_expected.to have_abilities([:read]), other_user }
    end
  end
end
