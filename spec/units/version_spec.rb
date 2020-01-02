# frozen_string_literal: true

RSpec.describe 'SmartCore Engine version' do
  specify { expect(SmartCore::Engine::VERSION).to eq('0.1.0') }
end
