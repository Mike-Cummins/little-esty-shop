require 'rails_helper'

RSpec.describe 'Bulk Discounts Edit' do
  describe 'As a merchant when I visit a discount show page' do
    it 'Has a link to edit the discount' do
      merchant_1 = Merchant.first
      discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
      
      visit merchant_bulk_discount_path(merchant_1, discount_1)

      expect(page).to have_content("30.0% off when you buy 15")
      expect(page).to have_link("Edit Discount")
      click_link("Edit Discount")
   
      expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, discount_1))
      fill_in("percentage_discount", with: 50)
      fill_in("quantity_threshold", with: 20)
      click_on("Update Discount")

      expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, discount_1))
      expect(page).to have_content("50.0% off when you buy 20")
    end
  end 
end