# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Engine::Lock
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def initialize
    @lock = Mutex.new
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def synchronize(&block)
    @lock.owned? ? yield : @lock.synchronize(&block)
  end
end
