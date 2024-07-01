# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, Loan
      cannot :create, Loan
      can :approve, Loan
      can :reject, Loan
      cannot [:confirm_loan, :reject_by_user], Loan
    else
      can :manage, Loan, user_id: user.id
      can :update, Loan, user_id: user.id
      cannot :approve, Loan
      cannot :reject, Loan
      can :confirm_loan, Loan, user_id: user.id
      can :reject_by_user, Loan, user_id: user.id
    end
  end
end
