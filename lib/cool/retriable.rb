module Cool
  module Retriable
    def retry_(new_method, on: StandardError, times: 3, &condition) # rubocop:disable Metrics/MethodLength, Metrics/LineLength
      condition ||= ->(*) { false }
      orig_method = "__retry_orig_#{new_method}".to_sym
      alias_method orig_method, new_method
      define_method(new_method) do |*args, &block|
        (times - 1).times do
          retval =
            begin
              method(orig_method).call(*args, &block)
            rescue on
              next
            end
          return retval unless condition.call(retval)
        end
        return method(orig_method).call(*args, &block)
      end
    end
  end
end
