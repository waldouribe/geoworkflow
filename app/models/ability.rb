class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # Guest user
    
    if user.role? :admin
      can :manage, :all
    else
      can [:create, :index], MyProcess
      can [:create], User
    end
  end
end