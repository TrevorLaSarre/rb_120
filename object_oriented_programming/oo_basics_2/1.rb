class Cat
  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end
end

Cat.generic_greeting

# Further Exploration

kitty = Cat.new
kitty.class.generic_greeting

=begin
The code above prints "Hello! I'm a cat!" to the screen because generic_creeting is being called up 
the return value of kitty.class, which is Cat
=end