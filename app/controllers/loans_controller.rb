class LoansController < ApplicationController
  load_and_authorize_resource
  before_action :set_loan, only: [:show, :edit, :update, :destroy]

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

  private

  def loan_params
    params.require(:loan).permit(:amount, :loan_type_id, :interest_rate)
  end

  def set_loan
    @loan = Loan.find(params[:id])
  end
end
