require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it {should have_many :items}
    it {should validate_presence_of :name}
  end

  describe '#top_five_customers' do
    it 'returns the top 5 customers with most successful transactions with given merchant' do
      top5 = Merchant.find(2).top_five_customers

      expect(top5.length).to eq(5)
      expect(top5).to eq([Customer.find(12), Customer.find(10), Customer.find(1), Customer.find(3), Customer.find(11)])
      expect(top5[0].transaction_count).to eq(9)
      expect(top5[4].transaction_count).to eq(3)
    end
  end

  describe '#ready_to_ship_items' do
    it 'returns the items that are ordered but not shipped for the given merchant' do
      merchants_ready_items = Merchant.find(1).ready_to_ship_items

      merchants_ready_items.each do |item|
        expect(item).to be_a Item
        expect(item.merchant_id).to eq(1)
        expect(item.status).to eq(1)
      end

      expect(merchants_ready_items.length).to eq(16)
    end

    it 'returns the items in order of oldest to newest' do
      merchants_ready_items = Merchant.find(1).ready_to_ship_items
      first_item = merchants_ready_items.first
      second_item = merchants_ready_items.second
      last_item = merchants_ready_items.last

      expect(first_item.invoice_created_at < second_item.invoice_created_at).to eq true
      expect(second_item.invoice_created_at < last_item.invoice_created_at).to eq true
    end
  end

  describe '#top_5_by_revenue' do
    it 'returns the top 5 merchants by revenue' do
      expect(Merchant.top_5_by_revenue).to eq([Merchant.find(8), Merchant.find(2), Merchant.find(7), Merchant.find(3), Merchant.find(4)])
    end
  end

  describe '#get_enabled_items' do
    it 'returns all of a merchants enabled items' do
      merchant = Merchant.find(1)
      expect(merchant.get_enabled_items).to eq(merchant.items)
      expect(merchant.get_enabled_items.length).to eq(15)
      Item.find(1).update(enabled: false)
      expect(merchant.get_enabled_items.length).to eq(14)
    end
  end

  describe '#get_disabled_items' do
    it 'returns all of a merchants disabled items' do
      merchant = Merchant.find(1)
      expect(merchant.get_disabled_items.length).to eq(0)
      item_1 = merchant.items.create!(name: "bob", description: "very good at things", unit_price: 9999, enabled: false)
      item_2 = merchant.items.create!(name: "bob2", description: "very better at things", unit_price: 99999, enabled: false)
      item_3 = merchant.items.create!(name: "bob3", description: "very best at things", unit_price: 99999, enabled: false)
      item_4 = merchant.items.create!(name: "bob4", description: "very okay at things", unit_price: 999, enabled: false)
      expect(merchant.get_disabled_items).to eq([item_1, item_2, item_3, item_4])
    end
  end
  
  describe '#best_day_by_revenue' do
    it 'returns the best day by revenue for a given merchant' do
      expect(Merchant.find(8).best_day_by_revenue).to eq('3/13/2012')
    end
  end

  describe '#revenue_in_dollars' do
    it 'returns the total revenue for a given merchant in dollars' do
      expect(Merchant.top_5_by_revenue.first.revenue_in_dollars).to eq('$227,757.77')
    end
  end

  describe '#top_5_items' do
    it 'returns the top 5 items by revenue for a given merchant' do
      merchant = Merchant.find(1)
      top_5 = merchant.top_5_items

      expect(top_5.size).to eq(5)

      top5.each do |item|
        expect(item).to be_a Item
      end

      expect(Merchant.find(10).top_5_items).to eq([])
    end
  end
end

# Then I see the names of the top 5 most popular items ranked by total revenue generated
# And I see that each item name links to my merchant item show page for that item
# And I see the total revenue generated next to each item name

# Notes on Revenue Calculation:

# Only invoices with at least one successful transaction should count towards revenue
# Revenue for an invoice should be calculated as the sum of the revenue of all invoice 
# items

# Revenue for an invoice item should be calculated as the invoice item unit price 
# multiplied by the quantity (do not use the item unit price)