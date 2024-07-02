# Lend Money with Interest

This project implements a loan management system where multiple users can request loans from an admin, who can approve or reject them with customized interest rates. The system ensures proper tracking of loan states and automatic interest calculation.

## Story Points

- There are multiple Users and one Admin.
- Admin starts with a wallet of 10 lakh rupees, while each User starts with 10 thousand rupees.
- Loan states include Requested, Approved, Open, Closed, and Rejected (initial state is Requested).
- Users can request loans, which start in the Requested state.
- Admin can approve/reject loan requests and modify the interest rate (default rate is 5%).
- Once approved, the User can confirm the loan, moving it to the Open state and transferring funds from Admin to User.
- Interest is calculated every 5 minutes on the principal loan amount.
- Users can see the total amount (principal + interest) to repay.
- Users can repay loans, transferring funds back to Admin and closing the loan.
- If the loan amount exceeds the User's wallet, the remaining amount is debited from User and closed.

## Implementation Details

### Functionality Implemented

- Two Sidekiq/Resque jobs:
  - One for calculating interest periodically.
  - One for debiting excess loan amounts from User wallets.
- Authentication for Admin and User pages.
- User Interface:
  - Loan request, confirmation/rejection of interest rate set by Admin, loan repayment.
  - View current & previous loan details and wallet balance.
- Admin Interface:
  - View loan requests, approve loans, view active & repaid loans with details, and manage wallet balance.
