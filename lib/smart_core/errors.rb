# frozen_string_literal: true

module SmartCore
  # @api public
  # @since 0.1.0
  Error = Class.new(::StandardError)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(::ArgumentError)

  # @api public
  # @since 0.3.0
  NameError = Class.new(::NameError)

  # @api public
  # @since 0.5.0
  TypeError = Class.new(::TypeError)

  # @api public
  # @since 0.2.0
  FrozenError = # rubocop:disable Naming/ConstantName
    # :nocov:
    # rubocop:disable Layout/CommentIndentation
    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.5.0')
      Class.new(::FrozenError)
    else
      Class.new(::RuntimeError)
    end
    # :nocov:
    # rubocop:enable Layout/CommentIndentation
end
