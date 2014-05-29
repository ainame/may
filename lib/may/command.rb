require 'claide'
require 'may/application_context'
require 'may/command/generate'

module May
  class Command < CLAide::Command
    self.abstract_command = true
    self.command = 'may'
    self.version = VERSION
    self.description = 'May, the Objective-C source code generator.'
    self.plugin_prefix = 'may'

    def self.generate(*args)
      Generate.run(ApplicationContext.new, *args)
    end

    def self.parse(argv)
      command = super
      p command
      command
    end

  end
end
