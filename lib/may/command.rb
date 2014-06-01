require 'claide'

module May
  class Command < CLAide::Command
    require 'may/application_context'
    require 'may/command/generate'

    self.abstract_command = true
    self.command = 'may'
    self.version = VERSION
    self.description = 'may, the Objective-C source code generator.'
  end
end
