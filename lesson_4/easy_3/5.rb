class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer
tv.model

Television.manufacturer
Television.model

# Line 12 returns a NoMethodError because a Class method is being called on an instance of that class
# Line 13 will execute model
# Line 15 will execute self.manufacturer
# Line 16 will return a NoMethodError because an instance method is being called on the class itself