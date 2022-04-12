class Minilang
  OPERATIONS = { 'ADD' => '+', 'SUB' => '-', 'MULT' => '*', 'DIV' => '/', 'MOD' => '%' }

  def initialize(commands)
    @commands = commands.split
    @register = 0
    @stack = []
  end

  def eval
    @commands.each do |command|
      if command.to_i.to_s == command || OPERATIONS.has_key?(command)
        set_register(command)
      else
        break unless execute(command)
      end
    end
  end

  private

  def set_register(x)
    @register = (x.to_i.to_s == x ? x.to_i : [@register, pop].inject(OPERATIONS[x]))
  end

  def execute(command)
    begin
      self.send(command.downcase)
    rescue NoMethodError
      puts "Invalid token: #{command}"
    end
  end

  def pop
    begin
      @register = (@stack.empty? ? raise("Empty Stack!") : @stack.shift)
    rescue RuntimeError => e
      puts e.message
    end
  end

  def print
    puts @register
  end

  def push
    @stack << @register
  end
end