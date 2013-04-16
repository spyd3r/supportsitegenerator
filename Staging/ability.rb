class Ability
  include CanCan::Ability

  def initialize(current_user)
    current_user ||= User.new
    if current_user.admin?
      can :manage, :all
    else
      can :read, :all
      can :create, Tip
    end
  end
end
