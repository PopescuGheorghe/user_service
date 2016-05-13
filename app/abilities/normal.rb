class Normal < Ability
  def initialize(user)
  can :read, :all
    can :create, User
    can :manage, User, id: user.id
  end
end
