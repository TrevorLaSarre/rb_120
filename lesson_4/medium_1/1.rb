class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is right. Because BankAccount has a getter method for @balance, the balance on line 9 is actually a method call for that method, which returns 
# the value of @balance