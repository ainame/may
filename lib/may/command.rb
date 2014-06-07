require 'claide'

module May
  class Command < CLAide::Command
    require 'may/application_context'
    require 'may/command/init'
    require 'may/command/generate'
    require 'may/custom_command'

    self.abstract_command = true
    self.command = 'may'
    self.version = VERSION
    self.description = 'may, the Objective-C source code generator.'

    custom = May::CustomCommand.new(ApplicationContext.new)
    custom.load
    custom.eval_custom_file
    May::CustomCommand::Definer::Generate.new(May::Command::Generate).define
  end
end
