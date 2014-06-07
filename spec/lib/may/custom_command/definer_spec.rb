require 'spec_helper'
require 'may/custom_command/definer'
require 'ostruct'

describe May::CustomCommand::Definer::Generate do
  before do
    class Foo
      class << self
        attr_accessor :command, :template_name,
         :description, :default_super_class, :arguments
      end
    end
    May::CustomCommand::Container.clear
  end

  describe ".define_command" do
    context 'given mock command' do
      let(:command) do
        OpenStruct.new({
          command_name: 'aaa', template_name: 'bbb',
          description: 'ccc', default_super_class: 'ddd'
          })
      end

      it "define subclass of Foo" do
        May::CustomCommand::Definer::Generate.new(Foo).define_commad(command)
        expect(Foo::Aaa.command).to eq('aaa')
        expect(Foo::Aaa.template_name).to eq('bbb')
        expect(Foo::Aaa.description).to eq('ccc')
        expect(Foo::Aaa.default_super_class).to eq('ddd')
      end
    end
  end
end
