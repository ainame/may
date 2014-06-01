# -*- coding: utf-8 -*-
module May
  class Command
    class Generate < Command
      require 'may/command/generate/nsobject'

      self.abstract_command = true
      self.command = 'generate'
    end
  end
end
