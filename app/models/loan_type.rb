class LoanType < ApplicationRecord
  # Associations
  has_many :loans

  # Validations
  validates :name, presence: true, uniqueness: true
end
