require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'Relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:transactions).through(:invoice) }
    it { should have_many(:bulk_discounts).through(:item) }
    it { should validate_numericality_of :quantity }
    it { should validate_numericality_of :unit_price }
  end

  it 'converts unit price to dollars' do
    expect(InvoiceItem.first.unit_price_to_dollars).to eq('$136.35')
  end

  it 'Checks if it has been discounted' do
    merchant_1 = Merchant.find(1)
    invoice_item_1 = InvoiceItem.find(1)
    invoice_item_2 = InvoiceItem.find(4)
    discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)

    expect(invoice_item_1.discounted?).to eq(true)
    expect(invoice_item_2.discounted?).to eq(false)
  end

  it 'Returns the applied bulk discount' do
    merchant_1 = Merchant.find(1)
    invoice_item_1 = InvoiceItem.find(1)
    invoice_item_2 = InvoiceItem.find(4)
    discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)
    discount_2 = merchant_1.bulk_discounts.create!(percentage_discount: 50, quantity_threshold: 20)

    expect(invoice_item_1.applied_discount).to eq(discount_1)
    expect(invoice_item_2.applied_discount).to eq(nil)
  end
end
