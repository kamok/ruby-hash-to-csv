# This class takes in a array of Hash-like objects and returns a .csv
class HashConverter
  def self.call(arg)
    validate(arg)
  rescue UncaughtThrowError => e
    p e
  end

  private_class_method

  def self.validate(arg)
    throw 'Argument is not an Array' unless arg.is_a?(Array)
    throw 'Not every element is a Hash-like object' unless
      arg.all? { |ele| ele.is_a?(Hash) }
  end
end

HashConverter.([{}, {}])