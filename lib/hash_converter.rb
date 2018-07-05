require 'csv'
# This class takes in a array of Hash-like objects and returns a .csv
class HashConverter
  def self.call(array_of_hash)
    validate(array_of_hash)
    csv_columns = {} ## unique keys for csv columns
    array_of_hash.each do |hash|
      hash.keys.each do |key|
        csv_columns[key] = true
      end
    end

    CSV.generate do |csv|
      csv << csv_columns.keys
      array_of_hash.each do |hash|
        row = []
        csv_columns.keys.each do |key|
          hash.key?(key) ? row << hash[key] : row << nil
        end
        csv << row
      end
    end

  rescue StandardError => e
    'An error has occured: ' + e.message
  end

  private_class_method

  def self.validate(arg)
    raise 'Argument is not an Array' unless arg.is_a?(Array)
    raise 'Not every element is a Hash-like object' unless
      arg.all? { |ele| ele.is_a?(Hash) }
  end
end

# csv = HashConverter.call()
