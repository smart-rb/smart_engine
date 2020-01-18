# frozen_string_literal: true

RSpec.describe SmartCore::Engine::Lock do
  specify 'multi-threading access' do
    counter = Class.new do
      def initialize
        @lock = SmartCore::Engine::Lock.new
        @counter = 0
      end

      def state
        @counter
      end

      def up
        @lock.synchronize { @counter += 1 }
      end
    end.new

    Array.new(1000) { Thread.new { counter.up } }.each(&:join)

    expect(counter.state).to eq(1000)
  end
end
