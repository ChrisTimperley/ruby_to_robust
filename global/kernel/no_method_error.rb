# Augments the functionality of NoMethodError instances so that the name of the missing method
# and the name of its context (if it has one) can be quickly and easily inspected.
class NoMethodError

  # Returns the name of the missing method.
  def method_name
    message[/\`(.*?)'/, 1]
  end

  # Returns the details of the method owner (if it has one).
  def method_owner
    message.partition('for ')[2]
  end

end