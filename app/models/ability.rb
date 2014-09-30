class Ability
  include CanCan::Ability

  def initialize(user)
    can :update, User do |subject|
      user.id == subject.id
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
  end
end
