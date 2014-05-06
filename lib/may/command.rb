require 'may/application_context'
require 'may/command/generate'

module May
  class Command
    def self.generate(*args)
      Generate.run(ApplicationContext.new, *args)
    end
  end
end
