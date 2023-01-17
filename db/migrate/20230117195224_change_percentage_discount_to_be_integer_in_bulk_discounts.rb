class ChangePercentageDiscountToBeIntegerInBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    change_column :bulk_discounts, :percentage_discount, :integer
  end
end
