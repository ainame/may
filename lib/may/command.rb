require 'claide'

module May
  class Command < CLAide::Command
    require 'may/application_context'
    require 'may/command/generate'

    self.abstract_command = true
    self.command = 'may'
    self.version = VERSION
    self.description = 'may, the Objective-C source code generator.'

    def self.generate(*args)
      Generate.run(ApplicationContext.new, *args)
    end

    def self.parse(argv)
      command = super
      p command
      command
    end

    def initialize(argv)
      @command = argv.shift_argument
      super
    end
  end
end
