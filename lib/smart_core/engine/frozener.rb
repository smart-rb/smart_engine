# frozen_string_literal: true

# @api public
# @since 0.8.0
# @version 0.9.0
module SmartCore::Engine::Frozener
  # @api public
  # @since 0.8.0
  module Mixin
    # @return [self]
    #
    # @api public
    # @since 0.8.0
    def freeze
      SmartCore::Engine::Frozener.freeze(self)
    end

    # @return [Boolean]
    #
    # @api public
    # @since 0.8.0
    def frozen?
      SmartCore::Engine::Frozener.frozen?(self)
    end
  end

  # @return [UnboundMethod]
  #
  # @api private
  # @since 0.8.0
  FROZENER = Object.new.method(:freeze).unbind.tap(&:freeze)

  # @return [UnboundMethod]
  #
  # @api private
  # @since 0.8.0
  FROZEN_CHECK = Object.new.method(:frozen?).unbind.tap(&:freeze)

  class << self
    # @param object [Any]
    # @return [object]
    #
    # @api public
    # @since 0.8.0
    # @version 0.9.0
    def freeze(object)
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      FROZENER.bind(object).call
      # rubocop:enable Performance/BindCall
    end

    # @param object [Any]
    # @return [Boolean]
    #
    # @api public
    # @since 0.8.0
    # @version 0.9.0
    def frozen?(object)
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      FROZEN_CHECK.bind(object).call
      # rubocop:enable Performance/BindCall
    end
  end
end
