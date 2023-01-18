require 'rails_helper'

RSpec.describe 'Bulk Discounts Index' do
  describe 'As a merchant when I visit my dashboard' do
    before :each do
      @merchant_1 = Merchant.first
      @merchant_2 = Merchant.last
      @discount_1 = @merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
      @discount_2 = @merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
      @discount_3 = @merchant_2.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)
    end
    it 'Has a link to view all bulk discounts' do
      visit merchant_dashboard_path(@merchant_1.id)
      click_link("View all Discounts")
   
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1.id))

      within "#discount_#{@discount_1.id}" do
        expect(page).to have_content("30% off when you buy 15")
      end

      within "#discount_#{@discount_2.id}" do
        expect(page).to have_content("20% off when you buy 10")
      end

      expect(page).to_not have_content("10% off when you buy 5")
    end

    it 'Index has a link to view each discounts show page' do
      visit merchant_bulk_discounts_path(@merchant_1.id)

      click_on("30% off when you buy 15")

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))
    end

    it 'Index has a link to create a new discount' do
      visit merchant_bulk_discounts_path(@merchant_1.id)

      expect(page).to have_content("Create New Discount")
      click_link("Create New Discount")

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))

      fill_in('Percent Off', with: 50)
      fill_in('Quantity Needed', with: 20)
      click_on("Create Discount")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1.id))
      expect(page).to have_content("50% off when you buy 20")
    end

    it 'Has a button to delete a discount' do
      visit merchant_bulk_discounts_path(@merchant_1.id)

      expect(page).to have_content("20% off when you buy 10")
      expect(page).to have_content("30% off when you buy 15")

      within "#discount_#{@discount_1.id}" do
        click_on("Delete Discount")
      end
save_and_open_page
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1.id))
      expect(page).to_not have_content("30% off when you buy 15")
    end
  end
end
