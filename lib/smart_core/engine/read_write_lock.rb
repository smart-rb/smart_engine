# frozen_string_literal: true

# @api public
# @since 0.14.0
class SmartCore::Engine::ReadWriteLock
  # @return [void]
  #
  # @api public
  # @sicne 0.14.0
  def initialize
    # NOTE:
    #   ivars has no readers cuz we want to avoid
    #   Ruby VM's context-switching during reade-method invokation.
    @active_reader = false
    @write_lock = ::Mutex.new
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.14.0
  def read_sync(&block)
    @active_reader = true
    while @write_lock.locked? do; end
    yield
  ensure
    @active_reader = false
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.14.0
  def write_sync(&block)
    while @active_reader do; end
    @write_lock.synchronize do
      @active_reader = true
      begin
        yield
      ensure
        @active_reader = false
      end
    end
  end
end