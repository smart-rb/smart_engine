# frozen_string_literal: true

RSpec.describe SmartCore::Engine::Cache do
  let(:cache) { SmartCore::Engine::Cache.new }

  describe 'cache #read' do
    specify 'read existing key' do
      test1_value = 123
      test2_value = '123'

      cache.write(:test1, test1_value)
      cache.write(:test2, test2_value)

      expect(cache.read(:test1)).to eq(test1_value)
      expect(cache.read(:test2)).to eq(test2_value)
    end

    specify 'read non-existing key' do
      expect(cache.read(:test3)).to eq(nil)
      expect(cache.read(:test4)).to eq(nil)
    end

    specify 'read an existing key with fallback' do
      value_1 = Object.new
      value_2 = 'another-object'

      cache.write(:test1, value_1)

      expect(cache.read(:test1) { value_2 }).to eq(value_1)
      expect(cache.read(:test1)).to eq(value_1)
    end

    specify 'read a non-existing key with fallback' do
      fallback_value = Object.new

      expect(cache.read(:test1) { fallback_value }).to eq(fallback_value)
      expect(cache.read(:test1)).to eq(fallback_value)
    end

    specify '[] method alias' do
      test1_value = 'test1'
      test2_value = Object

      cache.write(:test1, test1_value)
      expect(cache[:test1]).to eq(test1_value)

      expect(cache[:test2] { test2_value }).to eq(test2_value)
      expect(cache[:test2]).to eq(test2_value)
    end
  end

  describe 'cache #write' do
    specify '#write returns a written value' do
      test1_value = Object.new
      expect(cache.write(:test1, test1_value)).to eq(test1_value)
    end

    specify '#write rewrites existing values' do
      first_value = Object.new
      second_value = Object.new

      cache.write(:test1, first_value)
      expect(cache.read(:test1)).to eq(first_value)

      cache.write(:test1, second_value) # NOTE: rewrite existing value
      expect(cache.read(:test1)).to eq(second_value)
    end

    specify 'rewrite returns written value' do
      test1_value = Object.new
      test2_value = Object.new

      cache.write(:test1, test1_value)
      expect(cache.write(:test1, test2_value)).to eq(test2_value)
    end

    specify 'we can #write a nil object (and fallback is not invoked if passed)' do
      cache.write(:test1, nil)
      expect(cache.read(:test1)).to eq(nil)
      expect(cache.read(:test1) { 'nil-fallback' }).to eq(nil)
    end

    specify '[]= method alias' do
      test1_value = Object.new

      expect(cache[:test1] = test1_value).to eq(test1_value)
    end

    specify 'we can use any object as a cache key and any object as a cachable object' do
      object_key, some_object = Object.new, Object.new
      string_key, some_string = 'test1', 'some-string'
      symbol_key, some_symbol = :test, :some_symbol
      number_key, some_number = 12345, 7776655
      float_key, some_float = 123.456, 555.666
      hash_key, some_hash = { a: 1 }, { b: 100, c: 200 }
      time_key, some_time = Time.now, Time.now
      date_key, some_date = Date.new, Date.new
      nil_key, some_nil = nil, nil

      expect(cache.write(object_key, some_object)).to eq(some_object)
      expect(cache.read(object_key)).to eq(some_object)

      expect(cache.write(string_key, some_string)).to eq(some_string)
      expect(cache.read(string_key)).to eq(some_string)

      expect(cache.write(symbol_key, some_symbol)).to eq(some_symbol)
      expect(cache.read(symbol_key)).to eq(some_symbol)

      expect(cache.write(number_key, some_number)).to eq(some_number)
      expect(cache.read(number_key)).to eq(some_number)

      expect(cache.write(float_key, some_float)).to eq(some_float)
      expect(cache.read(float_key)).to eq(some_float)

      expect(cache.write(hash_key, some_hash)).to eq(some_hash)
      expect(cache.read(hash_key)).to eq(some_hash)

      expect(cache.write(time_key, some_time)).to eq(some_time)
      expect(cache.read(time_key)).to eq(some_time)

      expect(cache.write(date_key, some_date)).to eq(some_date)
      expect(cache.read(date_key)).to eq(some_date)

      expect(cache.write(nil_key, some_nil)).to eq(some_nil)
      expect(cache.read(nil_key)).to eq(some_nil)
    end
  end

  describe 'cache #clear' do
    specify 'cache clearing' do
      cache.write(:test1, 'test1')
      cache.write(:test2, 'test2')

      cache.clear

      expect(cache.read(:test1) { 'new-test1' }).to eq('new-test1') # cache miss => new value
      expect(cache.read(:test2) { 'new-test2' }).to eq('new-test2') # cache miss => new value
    end

    specify 'cache #clear result should be <silent> :))' do
      cache[:test1] = 'test1'
      expect(cache.clear).to eq(nil)
    end
  end
end
