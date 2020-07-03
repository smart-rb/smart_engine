# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Engine::Atom
  # @param initial_value [NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(initial_value = nil)
    @value = initial_value
    @barrier = SmartCore::Engine::Lock.new
  end

  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def value
    whith_barrier { @value }
  end

  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def swap(&block)
    with_barrier { @value = yield(@value) }
  end

  private

  def with_barrier(&block)
    @barrier.synchronize(&block)
  end
end
