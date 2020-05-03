# frozen_string_literal: true

# @api public
# @since 0.6.0
module SmartCore::Engine::RescueExt
  # REASON:
  #   {module_funciton} is used to be able to include/extend any module/class
  #   and at the same time to use without any inclusion/extending logic as a service

  module_function

  # @param proks [Array<Proc>]
  # @param error_interceptor [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.6.0
  # rubocop:disable Performance/RedundantBlockCall
  def inline_rescue_pipe(*proks)
    unless proks.all? { |prok| prok.is_a?(::Proc) }
      raise(SmartCore::ArgumentError, 'Invalid proc object')
    end

    interceptable_bloks = proks.to_enum
    pipe_invokation_result = nil
    last_exception = nil

    begin
      while current_block = interceptable_bloks.next
        begin
          pipe_invokation_result = current_block.call
          break
        rescue => error
          last_exception = error
        end
      end

      pipe_invokation_result
    rescue ::StopIteration
      error_interceptor ? error_interceptor.call(last_exception) : raise(last_exception)
    end
  end
  # rubocop:enable Performance/RedundantBlockCall
end
