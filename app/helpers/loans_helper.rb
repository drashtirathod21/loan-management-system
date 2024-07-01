module LoansHelper
  def format_as_percentage(decimal_value)
    "#{(decimal_value * 100).round}%"
  end
end
