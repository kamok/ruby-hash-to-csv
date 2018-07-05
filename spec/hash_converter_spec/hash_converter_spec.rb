require_relative '../../lib/hash_converter'
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

  context 'when argument is valid for one level hash' do
    let(:single_1_level) do
      File.new(File.join(File.dirname(__FILE__), 'test_files', 'single_1_level.csv'))
    end
    let(:multiple_1_level) do
      File.new(File.join(File.dirname(__FILE__), 'test_files', 'multiple_1_level.csv'))
    end
    let(:multiple_1_level_missing) do
      File.new(File.join(File.dirname(__FILE__), 'test_files', 'multiple_1_level_missing.csv'))
    end
    it 'returns the right data for a single object' do
      test_data = [{ 'Col_1' => 1, 'Col_2' => 'Cheese', 'Col_3' => true }]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(single_1_level)
    end

    it 'returns the right data for multiple objects' do
      test_data = [
        { 'Col_1' => 1, 'Col_2' => 'Cheese', 'Col_3' => true },
        { 'Col_1' => 2, 'Col_2' => 'Cheese', 'Col_3' => false }
      ]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(multiple_1_level)
    end

    it 'returns the right data when key order is inconsistent' do
      test_data = [
        { 'Col_1' => 1, 'Col_2' => 'Cheese', 'Col_3' => true },
        { 'Col_2' => 'Cheese', 'Col_3' => false, 'Col_1' => 2 }
      ]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(multiple_1_level)
    end

    it 'returns the right data when keys are missing in some objects' do
      test_data = [
        { 'Col_1' => 1, 'Col_2' => 'Cheese', 'Col_3' => true },
        { 'Col_2' => 'Cheese' }
      ]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(multiple_1_level_missing)
    end
  end

  context 'when argument is valid for multi-level hash' do
    let(:single_multi_level) do
      File.new(File.join(File.dirname(__FILE__), 'test_files', 'single_multi_level.csv'))
    end
    let(:multiple_multi_level) do
      File.new(File.join(File.dirname(__FILE__), 'test_files', 'multiple_multi_level.csv'))
    end
    let(:multiple_multi_level_missing) do
      File.new(File.join(File.dirname(__FILE__), 'test_files', 'multiple_multi_level_missing.csv'))
    end

    it 'returns the right data for a single object' do
      test_data = [
        {
          'Col_1' => 1,
          'Col_2' => 'Cheese',
          'Col_3' => {
            'Col_3a' => 'Sub1',
            'Col_3b' => 'Sub2'
          }
        }
      ]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(single_multi_level)
    end

    it 'returns the right data for multiple objects' do
      test_data = [
        { 'Col_1' => 1,
          'Col_2' => 'Cheese',
          'Col_3' => {
            'Col_3a' => 'Sub1',
            'Col_3b' => 'Sub2'
          }
        },
        {
          'Col_1' => 2,
          'Col_2' => 'Cheese',
          'Col_3' => {
            'Col_3a' => 'Sub3',
            'Col_3b' => 'Sub4'
          }
        }
      ]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(multiple_multi_level)
    end

    it 'returns the right data when key order is inconsistent' do
      test_data = [
        { 'Col_1' => 1,
          'Col_2' => 'Cheese',
          'Col_3' => {
            'Col_3a' => 'Sub1',
            'Col_3b' => 'Sub2'
          }
        },
        {
          'Col_2' => 'Cheese',
          'Col_3' => {
            'Col_3b' => 'Sub4',
            'Col_3a' => 'Sub3'
          },
          'Col_1' => 2
        }
      ]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(multiple_multi_level)
    end

    it 'returns the right data when keys are missing in some objects' do
      test_data = [
        { 'Col_1' => 1,
          'Col_2' => 'Cheese',
          'Col_3' => {
            'Col_3a' => 'Sub1',
            'Col_3b' => 'Sub2'
          }
        },
        {
          'Col_3' => {
            'Col_3b' => 'Sub4'
          },
          'Col_1' => 2
        }
      ]
      csv = HashConverter.call(test_data)

      expect(CSV.parse(csv)).to eq CSV.parse(multiple_multi_level_missing)
    end
  end
end
