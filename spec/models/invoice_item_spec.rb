require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'Relationships' do
    it {should belong_to :invoice}
    it {should belong_to :item}
    it {should validate_numericality_of :quantity}
    it {should validate_numericality_of :unit_price}
  end
end