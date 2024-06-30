class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 1 }
  validates :name, presence: true, uniqueness: true

  after_initialize :set_default_wallet_balance, if: :new_record?

  private

  def set_default_wallet_balance
    if admin?
      self.wallet_balance = 1_000_000
    else
      self.wallet_balance = 10_000
    end
  end
end
