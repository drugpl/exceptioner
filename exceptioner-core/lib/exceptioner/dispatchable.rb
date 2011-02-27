module Exceptioner
  module Dispatchable

    def dispatchers
      @dispatchers ||= []
    end

    def clear_dispatchers
      @dispatchers = []
    end

    def add_dispatcher(clear = false, &block)
      clear_dispatchers if clear
      dispatchers << block
    end

    def run_dispatchers(exception)
      dispatchers.all? { |dispatcher| dispatcher.call(exception) != false }
    end

  end
end
