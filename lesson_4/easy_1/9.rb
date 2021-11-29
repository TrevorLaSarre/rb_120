class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# The self in the cats_count method name indicates that cats_count is a Class method which can be called on the Cat class 
# (as opposed to an instance method which can be called on an instance of the Cat class). Therefore, self in ths context
# refers to the Cat class itself