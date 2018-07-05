require_relative '../lib/hash_converter'
require 'csv'

describe 'HashConverter' do
  context 'when argument is invalid' do
    it 'return an error when the argument is not an array' do
      expectation = HashConverter.call(1)
      expect(expectation).to eq 'An error has occured: Argument is not an Array'
    end

    it 'return an error when the argument does not contain an array ' do
      expectation = HashConverter.call([1, 2, 3])
      expect(expectation).to eq 'An error has occured: Not every element is a' +
                                ' Hash-like object'
    end
  end

  context 'when argument is valid' do
    it 'returns the right data for a single object' do
      test_data = [{ 'Col_1' => 1, 'Col_2' => 'Cheese', 'Col_3' => true }]
      csv = HashConverter.call(test_data)
      expectation = [
        ['Col_1', 'Col_2', 'Col_3'],
        ['1', 'Cheese', 'true']
      ]
      expect(CSV.parse(csv)).to eq expectation
    end

    it 'returns the right data for multiple objects' do
      test_data = [
        { 'Col_1' => 1, 'Col_2' => 'Cheese', 'Col_3' => true },
        { 'Col_1' => 2, 'Col_2' => 'Cheese', 'Col_3' => false }
      ]
      csv = HashConverter.call(test_data)
      expectation = [
        ['Col_1', 'Col_2', 'Col_3'],
        ['1', 'Cheese', 'true'],
        ['2', 'Cheese', 'false']
      ]
      expect(CSV.parse(csv)).to eq expectation
    end
  end
end
