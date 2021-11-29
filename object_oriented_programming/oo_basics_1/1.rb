puts "Hello".class
puts 5.class
puts [1, 2, 3].class

# Alternative

["Hello", 5, [1, 2, 3]].each { |x| puts x.class }