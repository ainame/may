
module May
  class CustomCommand
    class Container
      @commands = Array.new

      class << self
        attr_reader :commands

        def store(command)
          @commands << command
        end

        def clear
          @commands = Array.new
        end
      end
    end
  end
end
