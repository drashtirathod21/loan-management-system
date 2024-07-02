class LoansController < ApplicationController
  load_and_authorize_resource
  before_action :set_loan, except: [:index, :new, :create]
  before_action :set_admin, only: [:confirm_loan, :reject_by_user, :repay]

  def index
    if current_user.admin?
      @loans = Loan.includes(:loan_type).all
    else
      @loans = @current_user.loans.includes(:loan_type)
    end
  end

  def show
  end

  def new
    @loan = @current_user.loans.build
    authorize! :create, @loan
  end

  def create
    @loan = @current_user.loans.build(loan_params)
    authorize! :create, @loan

    if @loan.save
      flash[:notice] = 'Loan requested successfully'
      redirect_to loans_path
    else
      flash[:errors] = @loan.errors.full_messages
      redirect_to new_loan_path(@loan)
    end
  end

  def edit
    authorize! :edit, @loan
  end

  def update
    authorize! :update, @loan
    if params[:loan][:interest_rate].present?
      params[:loan][:interest_rate] = params[:loan][:interest_rate].to_f / 100.0
    end

    if @loan.update(loan_params)
      flash[:notice] = 'Loan updated successfully'
      redirect_to loans_path
    else
      flash[:errors] = @loan.errors.full_messages
      redirect_to edit_loan_path(@loan)
    end
  end

  def destroy
    authorize! :delete, @loan
    if @loan.destroy
      flash[:notice] = 'Loan removed successfully'
      redirect_to loans_path
    else
      flash[:alert] = @loan.errors.full_messages
      redirect_to loans_path
    end
  end

  def approve
    authorize! :approve, @loan
    params[:loan][:interest_rate] = params[:loan][:interest_rate].to_f / 100.0
    @loan.update(status: :approved, interest_rate: params[:loan][:interest_rate])
    redirect_to loans_path, notice: 'Loan approved successfully.'
  end

  def reject
    authorize! :reject, @loan
    @loan.update(status: :rejected)
    redirect_to loans_path, notice: 'Loan rejected'
  end

  def confirm_loan
    authorize! :update, @loan
    @loan_user = @loan.user

    if @loan_user == current_user && @loan.approved?
      ActiveRecord::Base.transaction do
        @loan.update!(status: :open)
        @loan_user.update!(wallet_balance: @loan_user.wallet_balance + @loan.amount)
        @admin.update!(wallet_balance: @admin.wallet_balance - @loan.amount)
      end
      flash[:notice] = "Loan confirmed and amount credited to your wallet"
    else
      flash[:alert] = "You cannot confirm this loan"
    end

    redirect_to loan_path(@loan)
  end

  def reject_by_user
    authorize! :update, @loan
    if @loan.user == current_user && @loan.approved?
      @loan.update(status: :rejected)
      flash[:notice] = "Loan request rejected"
    else
      flash[:alert] = "You cannot reject this loan"
    end
    redirect_to loan_path(@loan)
  end

  def repay
    authorize! :update, @loan
    if current_user == @loan.user && @loan.open?
      total_loan_amount = @loan.amount

      if current_user.wallet_balance >= total_loan_amount
        current_user.update(wallet_balance: current_user.wallet_balance - total_loan_amount)
        @admin.update(wallet_balance: @admin.wallet_balance + total_loan_amount)
        @loan.update(status: :closed)

        flash[:notice] = "Loan repaid successfully. The amount has been debited from your wallet and credited to the admin's wallet."
      else
        flash[:alert] = "Insufficient funds in your wallet to repay the loan."
      end
    else
      flash[:alert] = "You cannot repay this loan."
    end

    redirect_to loan_path(@loan)
  end

  private

  def loan_params
    params.require(:loan).permit(:amount, :loan_type_id, :interest_rate)
  end

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def set_admin
    @admin = User.find_by(role: 'admin')
    unless @admin
      flash[:error] = "No admin available to confirm the loan"
      redirect_to loan_path(@loan)
    end
  end
end
