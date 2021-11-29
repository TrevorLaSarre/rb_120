class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# In the code above, self refers to an instance of the Cat class (i.e. a Cat object). The make_one_year_older method, when called on a Cat object
# will increment the age of that Cat object (stored in the @age instance variable) by 1.