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

p Cat.cats_count
cat_1 = Cat.new("Maine Coon")
p Cat.cats_count
cat_2 = Cat.new("Siamese")
p Cat.cats_count

# the @@cats_count variable is a class variable of the Cat class. When a new instance of the Cat class is instantiated, @@cats_count is incremented
# by 1 (thanks to line 7). The value of @@cats_count will be returned by the Class method self.cats_count when it is called on the Cat class as follows:
# Cat.cats_count