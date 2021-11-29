class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

=begin
This will fail when updated_quantity is called because line 11 attempts to call a setter method for @quantity which doesn't exist. Instead, that line 
creates a new local variable called quanitity. There are multiple ways to fix this bug, including:
  - Changing line 11 to @quantity = quantity = updated_count if updated_count >= 0
  - Change the attr_reader to attr_accessor and update line 11 to include self.quantity
  - Manually create a seter method for @quantity and then adjust line 11 as above
=end
