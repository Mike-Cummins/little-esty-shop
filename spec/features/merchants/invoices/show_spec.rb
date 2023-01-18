require 'rails_helper'

RSpec.describe 'Merchants Invoice Show' do
  it 'Shows all of the information for the specific invoice' do
    merchant = Merchant.find(1)
    invoice = merchant.invoices.first
    visit merchant_invoice_path(merchant, invoice)

    expect(page).to have_content(merchant.name)
    expect(page).to have_content(invoice.id)
    expect(page).to have_content(invoice.status.capitalize)
    expect(page).to have_content(invoice.created_at.strftime('%A, %B %-d, %Y'))
    expect(page).to have_content(invoice.customer.first_name)
    expect(page).to have_content(invoice.customer.last_name)
  end

  it 'Shows information for each individual item on the invoice' do
    merchant = Merchant.find(1)
    invoice = merchant.invoices.first
    visit merchant_invoice_path(merchant, invoice)

    invoice.items.each do |item|
      expect(page).to have_content(item.name).once
    end

    invoice.invoice_items.each do |invoice_item|
      expect(page).to have_content(invoice_item.quantity)
      expect(page).to have_content(invoice_item.unit_price_to_dollars)
      expect(page).to have_content(invoice_item.status.capitalize)
    end

    not_invoice = Merchant.find(2).invoices.second

    not_invoice.items.each do |item|
      expect(page).to_not have_content(item.name)
    end
  end

  it 'Shows the total revenue for the specific invoice' do
    visit merchant_invoice_path(Merchant.find(8), Invoice.find(31))

    expect(page).to have_content('Total invoice revenue: $28,499.29')
  end

  it 'Has a field to update the status of an item on the invoice' do
    visit merchant_invoice_path(Merchant.find(8), Invoice.find(31))

    invoice_item = Invoice.find(31).invoice_items.first

    expect(invoice_item.status).to eq('shipped')

    within("#item_#{invoice_item.id}") do
      expect(page).to have_select('invoice_item[status]', selected: 'Shipped')
      select('Pending', from: 'invoice_item[status]')
      click_button 'Update Item Status'
    end

    expect(current_path).to eq(merchant_invoice_path(Merchant.find(8), Invoice.find(31)))
    within("#item_#{invoice_item.id}") do
      expect(page).to have_content('Pending')
      expect(page).to have_select('invoice_item[status]', selected: 'Pending')
    end
  end

  it 'Displays the total revenue after discounts' do
    merchant_1 = Merchant.find(1)
    invoice_1 = Invoice.find(1)
    discount = merchant_1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)
   
    visit merchant_invoice_path(merchant_1, invoice_1)

    expect(page).to have_content("Total invoice revenue after discounts: $19,234.57")
  end

  it 'Displays the discount applied as a link to its show page' do
    merchant_1 = Merchant.find(1)
    invoice_1 = Invoice.find(1)
    discount = merchant_1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 5)
    invoice_item_1 = invoice_1.invoice_items.first

    visit merchant_invoice_path(merchant_1, invoice_1)

    within "#item_#{invoice_item_1.id}" do
      expect(page).to have_content("10% off.")
      click_link("10% off.")
    end

    expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, discount))
  end
end
