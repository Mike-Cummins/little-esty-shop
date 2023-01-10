class Admin::DashboardController < ApplicationController
  def index
    @info = GithubInfo.new
    @top_customers = Customer.top_5_by_transactions
    @incomplete_invoices = Invoice.incomplete_invoices
  end
end
