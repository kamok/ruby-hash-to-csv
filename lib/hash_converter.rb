require 'csv'
# This class takes in a array of Hash-like objects and returns a .csv
class HashConverter
  def self.call(array_of_hash)
    validate(array_of_hash)
    csv_columns = {} ## unique keys for csv columns

    array_of_hash.each do |hash|
      HashConverter.flatten_hash(hash).keys.each do |key|
        csv_columns[key] = true
      end
    end

    CSV.generate do |csv|
      csv << csv_columns.keys
      array_of_hash.each do |hash|
        row = []
        csv_columns.keys.each do |key|
          flattened = HashConverter.flatten_hash(hash)
          row << (flattened.key?(key) ? flattened[key] : nil)
        end
        csv << row
      end
    end

  rescue RuntimeError => e
    p 'An error has occured: ' + e.message
  end

  private_class_method

  def self.validate(arg)
    raise 'Argument is not an Array' unless arg.is_a?(Array)
    raise 'Not every element is a Hash-like object' unless
      arg.all? { |ele| ele.is_a?(Hash) }
  end

  def self.flatten_hash(param, prefix=nil)
    param.each_pair.reduce({}) do |a, (k, v)|
      v.is_a?(Hash) ? a.merge(flatten_hash(v, "#{prefix}#{k}-")) : a.merge("#{prefix}#{k}".to_sym => v)
    end
  end
end
