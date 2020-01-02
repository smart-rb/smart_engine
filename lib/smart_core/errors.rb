# frozen_string_literal: true

module SmartCore
  # @api public
  # @since 0.1.0
  Error = Class.new(::StandardError)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(::ArgumentError)

  # @api public
  # @sinc 0.1.0
  FrozenError = Class.new(::FrozenError)
end
