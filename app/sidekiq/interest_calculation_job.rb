require 'bigdecimal'
class InterestCalculationJob
  include Sidekiq::Job

  def perform(*args)
    loans = Loan.where(status: 'open')

    loans.each do |loan|
      calculate_and_update_interest(loan)
    end
  end

  private

  def calculate_and_update_interest(loan)
    principal = BigDecimal(loan.amount.to_s)
    interest_rate = BigDecimal(loan.interest_rate.to_s)

    # Calculate interest for 5 minutes
    time_period_in_minutes = BigDecimal(5.to_s)
    annual_time_period_in_minutes = BigDecimal((365 * 24 * 60).to_s)

    # Calculate interest
    interest = ((principal * interest_rate) / BigDecimal(100.to_s)) * (time_period_in_minutes / annual_time_period_in_minutes)

    # Update loan amount with interest
    new_amount = principal + interest
    loan.update(amount: new_amount.to_d)

    # Check if the total loan amount exceeds the user's wallet balance
    user = loan.user
    if loan.amount > user.wallet_balance
      DebitOverdrawnLoanJob.perform_async(loan.id)
    end
  end
end
