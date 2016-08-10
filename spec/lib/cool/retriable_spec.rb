RSpec.describe Cool::Retriable do
  describe '#retry_' do
    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [:no, :no, :yes].to_enum
        def do_it
          ENUM.next
        end
        retry_(:do_it) { |retval| retval == :no }
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [:no, :no, :no].to_enum
        def do_it
          ENUM.next
        end
        retry_(:do_it) { |retval| retval == :no }
      end

      expect(klass.new.do_it).to eq(:no)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [nil, nil, :yes].to_enum
        def do_it
          ENUM.next
        end
        retry_(:do_it, &:nil?)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [[], {}, :yes].to_enum
        def do_it
          ENUM.next
        end
        retry_(:do_it, &:empty?)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [:no, :no, :yes].to_enum
        def do_it
          ENUM.next.tap { |value| raise if value == :no }
        end
        retry_(:do_it)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [:no, :no, :no].to_enum
        def do_it
          ENUM.next.tap { |value| raise if value == :no }
        end
        retry_(:do_it)
      end

      expect { klass.new.do_it }.to raise_error(StandardError)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [:no].to_enum
        def do_it
          ENUM.next.tap { |value| raise if value == :no }
        end
        retry_(:do_it, times: 1)
      end

      expect { klass.new.do_it }.to raise_error(StandardError)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [:error, nil, :yes].to_enum
        def do_it
          ENUM.next.tap { |value| raise if value == :error }
        end
        retry_(:do_it, &:nil?)
      end

      expect(klass.new.do_it).to eq(:yes)
    end

    it 'works' do
      retriable = described_class
      klass = Class.new do
        extend retriable

        ENUM = [:yes, :error].to_enum
        def do_it
          ENUM.next.tap { |value| raise if value == :error }
        end
        retry_(:do_it)
      end

      expect(klass.new.do_it).to eq(:yes)
    end
  end
end
