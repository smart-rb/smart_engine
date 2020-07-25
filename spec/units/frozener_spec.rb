# frozen_string_literal: true

RSpec.describe SmartCore::Engine::Frozener do
  specify 'singleton: freeze / frozen?' do
    object = BasicObject.new

    expect(SmartCore::Engine::Frozener.frozen?(object)).to eq(false)
    expect(SmartCore::Engine::Frozener.freeze(object)).to eq(object)
    expect(SmartCore::Engine::Frozener.frozen?(object)).to eq(true)
  end

  specify 'mixin: freeze / frozen?' do
    object = Class.new(BasicObject) { include SmartCore::Engine::Frozener::Mixin }.new

    expect(object.frozen?).to eq(false)
    expect(object.freeze).to eq(object)
    expect(object.frozen?).to eq(true)
  end
end
