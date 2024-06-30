class Loan < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :loan_type

  # Enum for loan status
  enum status: { requested: 0, approved: 1, open: 2, closed: 3, rejected: 4 }

  # Validations
  validates :amount, presence: true
  validates :interest_rate, presence: true
end
