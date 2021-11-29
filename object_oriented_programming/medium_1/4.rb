class CircularQueue
  def initialize(size)
    @size = size
    @queue = []
  end
  
  def enqueue(obj)
    dequeue if full?
    @queue << obj
  end
  
  def dequeue
    @queue.shift
  end
  
  private
  
  def full?
    @queue.size == @size
  end
end
