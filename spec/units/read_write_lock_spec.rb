# frozen_string_literal: true

# rubocop:disable Style/Semicolon
RSpec.describe SmartCore::Engine::ReadWriteLock do
  specify 'write-lock locks all read-locks / read-locks does not lock each other' do
    lock = SmartCore::Engine::ReadWriteLock.new
    output = +''

    lock.read_sync { output << '1' }
    Thread.new { lock.write_sync { sleep(3); output << '2' } }
    sleep(1)

    [
      Thread.new { lock.read_sync { output << '3' } },
      Thread.new { lock.read_sync { output << '4' } },
      Thread.new { lock.read_sync { output << '5' } }
    ].each(&:join)

    Thread.new { lock.write_sync { sleep(3); output << '6' } }
    sleep(1)

    [
      Thread.new { lock.read_sync { output << '7' } },
      Thread.new { lock.read_sync { output << '8' } },
      Thread.new { lock.read_sync { output << '9' } }
    ].each(&:join)

    expect(output[0..1]).to eq('12')
    expect(output[5]).to eq('6')

    expect(output.chars).to contain_exactly(*%w[1 2 3 4 5 6 7 8 9])
  end
end
# rubocop:enable Style/Semicolon
