class Cube
  attr_accessor :volume
  
  def initialize(volume)
    @volume = volume
  end
end

# ALternatively:

class Cube
  def initialize(volume)
    @volume = volume
  end
  
  def get_volume
    @volume
  end
end