class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, User do |subj|
      subj.id == user.id && !subj.guest?
    end

    can :manage, Translation, :user_id => user.id
  end
end
