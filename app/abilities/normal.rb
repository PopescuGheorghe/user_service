class Normal < Ability
  def initialize(user)
    can :read, :all
    can :manage, User, id: user.id
  end
end
