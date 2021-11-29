module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  
  def go_slow
    puts "I am safe and driving slow."
  end
end

Car.new.go_fast

# The code above prints "I am a Car and going super fast" because the go_fast method in SPEED uses string interpolation to print the return value
# of the #class method being called one self. In the code above, self refers to the object created by calling new on Car, which is an object of the 
# Car class.