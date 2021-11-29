class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end
end

class BullDog < Dog
  def swim
    "Can't Swim!"
  end
end

teddy = BullDog.new
puts teddy.speak           # => "bark!"
puts teddy.swim  