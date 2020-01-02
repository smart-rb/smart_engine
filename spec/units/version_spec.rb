# frozen_string_literal: true

RSpec.describe 'SmartCore Engine version' do
  specify { expect(SmartCore::Engine::VERSION).not_to eq(nil) }
end
