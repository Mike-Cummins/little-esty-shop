class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy
  has_many :bulk_discounts, through: :invoice_items
  
  enum status: { 'in progress' => 0, completed: 1, cancelled: 2 }

  def self.incomplete_invoices
    Invoice.left_joins(:invoice_items)
           .where.not(invoice_items: { status: 2 })
           .distinct.order(:updated_at)
  end

  def total_invoice_revenue
    number_to_currency(total_revenue_calculated)
  end

  def total_revenue_calculated
    self.invoice_items.sum('invoice_items.quantity * invoice_items.unit_price') / 100.0
  end

  def invoice_total_by_merchant(merchant)
    number_to_currency(self.items.where(merchant_id: merchant.id).sum('invoice_items.quantity * invoice_items.unit_price') / 100.0)
  end

  def merchant_discounted_revenue(merchant)
    case_statement = self.invoice_items.left_joins(item: :bulk_discounts).where('items.merchant_id = ?', merchant.id)
      .select('invoice_items.*, min(0.01 * invoice_items.quantity * invoice_items.unit_price * (CASE 
        WHEN invoice_items.quantity >= bulk_discounts.quantity_threshold 
        THEN (1 - bulk_discounts.percentage_discount / 100.00) 
        ELSE 1 
        END)) as revenue').group(:id)
    
    number_to_currency(Item.from(case_statement).sum('revenue'))
  end  
end
