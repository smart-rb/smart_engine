# frozen_string_literal: true

# @api public
# @since 0.13.0
class SmartCore::Engine::Cache
  # @return [void]
  #
  # @api public
  # @since 0.13.0
  def initialize
    @store = {}
  end

  # @param key [Any]
  # @apram value [Any]
  # @return [Any]
  #
  # @api public
  # @since 0.13.0
  def write(key, value)
    @store[key] = value
  end
  alias_method :[]=, :write

  # @param key [Any]
  # @param fallback [Block]
  # @return [Any, NilClass]
  #
  # @api public
  # @since 0.13.0
  # rubocop:disable Style/NestedTernaryOperator
  def read(key, &fallback)
    # @note
    #   key?-flow is a compromise used to provide an ability to cache `nil` objects too.
    @store.key?(key) ? @store[key] : (block_given? ? write(key, yield) : nil)
  end
  alias_method :[], :read
  # rubocop:enable Style/NestedTernaryOperator

  # @return [NilClass]
  #
  # @api public
  # @since 0.13.0
  def clear
    @store.clear
    nil
  end
end
