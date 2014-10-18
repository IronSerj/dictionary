class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, User do |subj|
      subj.id == user.id && !subj.guest?
    end

    can :manage, Translation do |subj|
      if user.guest?
        subj.guest_uuid == user.uuid
      else
        subj.user_id == user.id
      end
    end
  end
end
