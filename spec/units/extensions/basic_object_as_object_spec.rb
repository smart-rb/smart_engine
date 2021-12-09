# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject # NOTE: testing this functionality

RSpec.describe SmartCore::Ext::BasicObjectAsObject do
  it 'provides support for #frozen/#freeze?/#is_a?/#kind_of?' do
    # we will use two different objects for the test clarity
    basic_obj_a = ::BasicObject.new
    basic_obj_b = ::BasicObject.new

    aggregate_failures 'frozen state' do
      expect(basic_obj_a.frozen?).to eq(false)
      expect(basic_obj_b.frozen?).to eq(false)

      expect(basic_obj_a.freeze).to eq(basic_obj_a)
      expect(basic_obj_a.frozen?).to eq(true)
      expect(basic_obj_b.frozen?).to eq(false)

      expect(basic_obj_b.freeze).to eq(basic_obj_b)
      expect(basic_obj_b.frozen?).to eq(true)
      expect(basic_obj_a.frozen?).to eq(true)
    end

    aggregate_failures 'support for type checking' do
      expect(basic_obj_a.is_a?(::Object)).to eq(false)
      expect(basic_obj_b.is_a?(::Object)).to eq(false)

      expect(basic_obj_a.is_a?(::Integer)).to eq(false)
      expect(basic_obj_b.is_a?(::String)).to eq(false)

      expect(basic_obj_a.is_a?(::BasicObject)).to eq(true)
      expect(basic_obj_b.is_a?(::BasicObject)).to eq(true)
    end

    aggregate_failures 'support for #hash' do
      expect(basic_obj_a.hash).to be_a(::Integer)
      expect(basic_obj_b.hash).to be_a(::Integer)

      expect(basic_obj_a.hash).to eq(basic_obj_a.hash)
      expect(basic_obj_b.hash).to eq(basic_obj_b.hash)

      expect(basic_obj_a.hash).not_to eq(basic_obj_b.hash)
    end

    # rubocop:disable Style/NilComparison
    aggregate_failures 'support for #nil?' do
      expect(basic_obj_a.nil?).to eq(false)
      expect(basic_obj_b.nil?).to eq(false)
    end
    # rubocop:enable Style/NilComparison

    aggregate_failures 'support for #instance_of?' do
      expect(basic_obj_a.instance_of?(::Object)).to eq(false)
      expect(basic_obj_a.instance_of?(::BasicObject)).to eq(true)
      expect(basic_obj_b.instance_of?(::Object)).to eq(false)
      expect(basic_obj_b.instance_of?(::BasicObject)).to eq(true)
    end

    aggregate_failures 'support for #inspect' do
      expect(basic_obj_a.inspect).to include("BasicObject")
      expect(basic_obj_b.inspect).to include("BasicObject")
    end
  end
end
