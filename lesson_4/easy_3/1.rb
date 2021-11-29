class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

hello = Hello.new
hello.hi

# On line 19, a new instance of the Hello class is instantiated. Simultaneously, the local variable hello is initalized to this new Hello object. 
# On the line 20, the hi method is invoked upon hello, which causes the greet method to be called and passed the string "Hello" as an argument. greet
# is a method defined within the Greeting class, and becasue Hello inherits from the Greeting class, Hello has access to methods defined within Greeting.
# Therefore, greet is successfully called on line 9, and "Hello" is printed to the screen.

hello = Hello.new
hello.bye

# The bye method is called on an instance of the Hello class. Because Hello objects do not have access to a bye method, a NoMethod Error is displayed.

hello = Hello.new
hello.greet

# The greet method is called upon an instance of the Hello class. Because greet is not defined within the Hello class, Ruby continues down the method
# lookup path and searches Greeting (which is a class that Hello inherits from), where it finds greet. However, because greet has no argument passed to it
# on line 33, an ArgumentError is displayed

hello = Hello.new
hello.greet("Goodbye")

# This example follows the same path as the previous, except it provides an argument to greet. Therefor, "Goodbye" i printed to the screen

Hello.hi

# This throws an NoMethodError because hi is an instance method, not a class method