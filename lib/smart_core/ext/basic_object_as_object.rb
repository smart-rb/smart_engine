# frozen_string_literal: true

# @api public
# @since 0.9.0
# @version 0.10.0
module SmartCore::Ext::BasicObjectAsObject
  refine BasicObject do
    _m_obj = ::Object.new

    _is_a        = _m_obj.method(:is_a?).unbind.tap(&:freeze)
    _freeze      = _m_obj.method(:freeze).unbind.tap(&:freeze)
    _frozen      = _m_obj.method(:frozen?).unbind.tap(&:freeze)
    _hash        = _m_obj.method(:hash).unbind.tap(&:freeze)
    _nil         = _m_obj.method(:nil?).unbind.tap(&:freeze)
    _instance_of = _m_obj.method(:instance_of?).unbind.tap(&:freeze)
    _inspect     = _m_obj.method(:inspect).unbind.tap(&:freeze)

    # @note Object#is_a? behavior copy
    # @param klass [Class]
    # @return [Boolean]
    #
    # @api public
    # @since 0.9.0
    define_method(:is_a?) do |klass|
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      _is_a.bind(self).call(klass)
      # rubocop:enable Performance/BindCall
    end
    alias_method :kind_of?, :is_a?

    # @note Object#freeze behavior copy
    # @return [self]
    #
    # @api public
    # @since 0.9.0
    define_method(:freeze) do
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      _freeze.bind(self).call
      # rubocop:enable Performance/BindCall
    end

    # @note Object#frozen? behavior copy
    # @return [Boolean]
    #
    # @api public
    # @since 0.9.0
    define_method(:frozen?) do
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      _frozen.bind(self).call
      # rubocop:enable Performance/BindCall
    end

    # @return [Integer]
    #
    # @api public
    # @since 0.10.0
    define_method(:hash) do
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      _hash.bind(self).call
      # rubocop:enable Performance/BindCall
    end

    # @return [Boolean]
    #
    # @api public
    # @since 0.10.0
    define_method(:nil?) do
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      _nil.bind(self).call
      # rubocop:enable Performance/BindCall
    end

    # @return [Boolean]
    #
    # @api public
    # @since 0.1.0
    define_method(:instance_of?) do |klass|
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      _instance_of.bind(self).call(klass)
      # rubocop:enable Performance/BindCall
    end

    # @return [String]
    #
    # @api public
    # @since 0.12.0
    define_method(:inspect) do
      # rubocop:disable Performance/BindCall
      # NOTE: disabled in order to support older Ruby versions than Ruby@3
      _inspect.bind(self).call
      # rubocop:enable Performance/BindCall
    end
  end
end
