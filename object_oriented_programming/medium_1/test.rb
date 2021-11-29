class Cat
  def initialize(name)
    @name = name
  end
  
  def name=(new_name)
    @name = new_name.upcase!
  end
  
  def tester
    check = (self.name = 'fuzzy')
    puts check
  end
end

cat = Cat.new("Ollie")

cat.tester