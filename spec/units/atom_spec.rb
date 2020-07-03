# frozen_string_literal: true

RSpec.describe SmartCore::Engine::Atom do
  context 'without initial value' do
    let(:atom) { described_class.new }

    specify 'value swap' do
      expect(atom.value).to eq(nil)

      result = atom.swap { 22 }
      expect(atom.value).to eq(22)
      expect(result).to eq(22)

      result = atom.swap { |value| value * 10 }
      expect(atom.value).to eq(220)
      expect(result).to eq(220)
    end
  end

  context 'with initial value' do
    let(:atom) { described_class.new('overwatch') }

    specify 'value swap' do
      expect(atom.value).to eq('overwatch')

      result = atom.swap { |value| value * 2 }
      expect(atom.value).to eq('overwatchoverwatch')
      expect(result).to eq('overwatchoverwatch')

      result = atom.swap(&:reverse)
      expect(atom.value).to eq('hctawrevohctawrevo')
      expect(result).to eq('hctawrevohctawrevo')
    end
  end
end
