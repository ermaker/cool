RSpec.describe Cool::Retriable do
  describe '#retry_' do
    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [:no, :no, :yes].to_enum
        end

        def do_it
          @enum.next
        end
        retry_(:do_it) { |retval| retval == :no }
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [:no, :no, :no].to_enum
        end

        def do_it
          @enum.next
        end
        retry_(:do_it) { |retval| retval == :no }
      end

      expect(klass.new.do_it).to eq(:no)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [nil, nil, :yes].to_enum
        end

        def do_it
          @enum.next
        end
        retry_(:do_it, &:nil?)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [[], {}, :yes].to_enum
        end

        def do_it
          @enum.next
        end
        retry_(:do_it, &:empty?)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [:no, :no, :yes].to_enum
        end

        def do_it
          @enum.next.tap { |value| raise if value == :no }
        end
        retry_(:do_it)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [:no, :no, :no].to_enum
        end

        def do_it
          @enum.next.tap { |value| raise if value == :no }
        end
        retry_(:do_it)
      end

      expect { klass.new.do_it }.to raise_error(StandardError)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [:no].to_enum
        end

        def do_it
          @enum.next.tap { |value| raise if value == :no }
        end
        retry_(:do_it, times: 1)
      end

      expect { klass.new.do_it }.to raise_error(StandardError)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [:error, nil, :yes].to_enum
        end

        def do_it
          @enum.next.tap { |value| raise if value == :error }
        end
        retry_(:do_it, &:nil?)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    specify do
      retriable = described_class
      klass = Class.new do
        extend retriable

        def initialize
          @enum = [:yes, :error].to_enum
        end

        def do_it
          @enum.next.tap { |value| raise if value == :error }
        end
        retry_(:do_it)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    specify do
      retriable = described_class
      error1 = Class.new(StandardError)
      error2 = Class.new(StandardError)
      klass = Class.new do
        extend retriable

        def initialize(error1, error2)
          @error1 = error1
          @error2 = error2
          @enum = [:error1, :error2, :yes].to_enum
        end

        def do_it
          @enum.next.tap do |value|
            case value
            when :error1 then raise @error1
            when :error2 then raise @error2
            end
          end
        end
        retry_(:do_it, on: [error1, error2])
      end

      expect(klass.new(error1, error2).do_it).to eq(:yes)
    end

    specify do
      retriable = described_class
      error1 = Class.new(StandardError)
      error2 = Class.new(StandardError)
      klass = Class.new do
        extend retriable

        def initialize(error1, error2)
          @error1 = error1
          @error2 = error2
          @enum = [:error1, :error2, :error, :yes].to_enum
        end

        def do_it
          @enum.next.tap do |value|
            case value
            when :error1 then raise @error1
            when :error2 then raise @error2
            when :error then raise StandardError
            end
          end
        end
        retry_(:do_it, times: 4, on: [error1, error2])
      end

      expect { klass.new(error1, error2).do_it }.to raise_error(StandardError)
    end
  end
end
