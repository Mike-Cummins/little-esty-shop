require 'rails_helper'

RSpec.describe "Bulk Discount Show" do
  describe "As a merchant when I visit a discount show page" do
    before :each do
      @merchant_1 = Merchant.first
      @merchant_2 = Merchant.last
      @discount_1 = @merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
      @discount_2 = @merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
      @discount_3 = @merchant_2.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)
    end

    it 'Displays the discount percentage and quantity threshold' do
      visit merchant_bulk_discount_path(@merchant_1, @discount_1)

      expect(page).to have_content(@discount_1.percentage_discount)
      expect(page).to have_content(@discount_1.quantity_threshold)
    end
  end
end