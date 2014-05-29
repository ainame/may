# -*- coding: utf-8 -*-
require 'may/service/generate'

module May
  class Command
    class Generate < CLAide::Command
      self.command = 'generate'

      def run(argv)
        p 'a'
        p argv
      end
    end
  end
end
