# Example 1:

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# Example 2:

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# These two examples work exactly the same, but Example 1 is better code because Example 2 includes unnecessary selfs