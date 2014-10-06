class Ability
  include CanCan::Ability

  def initialize(user)
    can :update, User, :id => user.id

    can :update, Translation, :user_id => user.id
  end
end
