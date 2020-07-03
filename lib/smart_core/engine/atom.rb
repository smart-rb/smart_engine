# frozen_string_literal: true

# @api public
# @since 0.7.0
class SmartCore::Engine::Atom
  # @param initial_value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.7.0
  def initialize(initial_value = nil)
    @value = initial_value
    @barrier = SmartCore::Engine::Lock.new
  end

  # @return [Any]
  #
  # @api public
  # @since 0.7.0
  def value
    with_barrier { @value }
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.7.0
  def swap(&block)
    with_barrier { @value = yield(@value) }
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def with_barrier(&block)
    @barrier.synchronize(&block)
  end
end
