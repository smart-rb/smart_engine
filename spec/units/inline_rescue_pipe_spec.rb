# frozen_string_literal: true

RSpec.describe SmartCore::Engine::RescueExt do
  describe 'pipe-lined inline rescue wrapper' do
    specify 'returns the first non-failed proc result' do
      result = SmartCore::Engine::RescueExt.inline_rescue_pipe(
        -> { raise },
        -> { raise },
        -> { :pipe3 },
        -> { :pipe4 },
        -> { raise }
      )

      expect(result).to eq(:pipe3)
    end

    specify 'provides custom error wrapper' do
      stub_const('SmartCoreCustomError', Class.new(StandardError))

      result = SmartCore::Engine::RescueExt.inline_rescue_pipe(
        -> { raise },
        -> { raise },
        -> { raise },
        -> { raise(SmartCoreCustomError, 'test message') }
      ) { |error| error }

      expect(result).to be_a(SmartCoreCustomError)
      expect(result.message).to eq('test message')
    end

    specify 'fails with the last exception when the error wrapper is not provided' do
      stub_const('NoCustomSmartErrorceptor', Class.new(StandardError))

      expect do
        SmartCore::Engine::RescueExt.inline_rescue_pipe(
          -> { raise },
          -> { raise },
          -> { raise },
          -> { raise(NoCustomSmartErrorceptor) }
        )
      end.to raise_error(NoCustomSmartErrorceptor)
    end

    specify 'fails when at least one of passed proc object is not a proc' do
      expect do
        SmartCore::Engine::RescueExt.inline_rescue_pipe(
          -> {},
          -> {},
          123,
          -> {}
        ) { |error| error }
      end.to raise_error(SmartCore::ArgumentError)
    end
  end
end
