class DebitOverdrawnLoanJob
  include Sidekiq::Job

  def perform(loan_id)
    loan = Loan.find(loan_id)
    return unless loan.present?

    user = loan.user
    return unless user.present?

    admin = User.admin.first
    return unless admin.present?

    user_balance = user.wallet_balance

    if loan.amount > user_balance
      amount_to_debit = user_balance

      # Debit from user's wallet and credit to admin's wallet
      user.update(wallet_balance: 0)
      admin.update(wallet_balance: admin.wallet_balance + amount_to_debit)

      # Close the loan
      loan.update(status: :closed)

      # Create a notification for the user
      Notification.create(user: user, message: "Loan ID #{loan.id} closed. ₹#{amount_to_debit} debited from your wallet and credited to admin.")
    end
  end
end
