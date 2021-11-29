class Banner
  def initialize(message)
    @message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+" + "-" * (@message.size + 2) + "+"
  end

  def empty_line
    "|" + " " * (@message.size + 2) + "|"
  end

  def message_line
    "| #{@message} |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

# Further Exploration

class Banner
  def initialize(message, width = message.size + 2)
    @message = message
    @width = width
  end

  def to_s
    if @width >= @message.size
      [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
    else
      "Your banner isn't wide enough!"
    end
  end

  private

  def horizontal_rule
    "+#{'-' * @width}+"
  end

  def empty_line
    "|#{' ' * @width}|"
  end

  def message_line
    "|#{@message.center(@width)}|"
  end
end

banner1 = Banner.new('To boldly go where no one has gone before.')
puts banner1

banner2 = Banner.new('To boldly go where no one has gone before.', 60)
puts banner2

banner3 = Banner.new('To boldly go where no one has gone before.', 10)
puts banner3