def horizontal_winners(numbers)
  n = Integer.sqrt(numbers.size)
  left = (n - 1)
  horizontal = []

  n.times do |x|
    horizontal << numbers[(x * n)..(n * x + left)]
  end
    
  horizontal
end
  
  def vertical_winners(numbers)
    n = Integer.sqrt(numbers.size)
    vertical = []
  
    n.times do |x|
      line = []
      n.times { |y| line << numbers[x + (y * n)] }
      vertical << line
    end
    
    vertical
  end
  
  def diagonal_winners(numbers)
    n = Integer.sqrt(numbers.size)
    diagonals = []
    right = (n + 1)
    left = (n - 1)
  
    n.times { |x| diagonals << numbers[x * right] }
    n.times { |x| diagonals << numbers[left + (left * x)] }
    [diagonals[0..left], diagonals[n..-1]]
  end
  
  def winning_lines(numbers)
    n = numbers
    horizontal_winners(n) + vertical_winners(n) + diagonal_winners(n) 
  end