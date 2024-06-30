# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, Loan
      cannot :create, Loan
    else
      can :manage, Loan, user_id: user.id
    end
  end
end
