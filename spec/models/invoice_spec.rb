require 'rails_helper'

RSpec.describe Invoice do
  describe 'Relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:bulk_discounts).through(:invoice_items) }
  end

  describe 'Class Methods' do
    it 'returns the invoices with not shipped items in order by oldest' do
      expect(Invoice.incomplete_invoices).to be_a ActiveRecord::Relation
      expect(Invoice.incomplete_invoices.count).to eq 70
      expect(Invoice.incomplete_invoices.first).to eq(Invoice.find(10))
    end
  end

  describe 'Instance Methods' do
    it 'returns the total revenue for a specific invoice' do
      expect(Invoice.find(31).total_invoice_revenue).to eq('$28,499.29')
    end

    it 'calulates the total revenue for a merchant' do
      merchant_1 = Merchant.find(1)
      invoice_1 = Invoice.find(1)
      
      expect(invoice_1.invoice_total_by_merchant(merchant_1)).to eq('$21,067.77')
    end

    it 'calulates the total revenue after discount' do
      merchant_1 = Merchant.find(1)
      invoice_1 = Invoice.find(1)
      discount = merchant_1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)

      expect(invoice_1.total_revenue_after_discount_by_merchant(merchant_1)).to eq('$19,234.57')
    end
  end
end
