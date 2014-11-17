module Cool
  class Work
    def initialize(code)
      @code = code
    end

    def execute
      instance_eval @code
    end
  end
end
