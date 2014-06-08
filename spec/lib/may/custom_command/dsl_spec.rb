# -*- coding: utf-8 -*-
require 'spec_helper'
require 'may/custom_command/dsl'

describe May::CustomCommand::DSL do
  before(:each) do
    May::CustomCommand::Container.clear
  end

  describe ".register" do
    context "register a sample command" do
      let(:subject) do
        May::CustomCommand::DSL.register_command 'sample' do
          template    'NSObject'
          description 'お寿司が好きです'
          super_class 'AMEURLSession'
        end
      end

      it "register to subject" do
        expect(subject).to be_kind_of(May::CustomCommand::TemplateCommand)
        expect(subject.template_name).to eq('NSObject')
        expect(subject.description).to eq('お寿司が好きです')
        expect(subject.default_super_class).to eq('AMEURLSession')
      end
    end

    context "register two sample command" do
      before(:each) do
        May::CustomCommand::DSL.register_command 'sample' do
        end
        May::CustomCommand::DSL.register_command 'sample2' do
        end
      end

      it "stored two commands obj to container" do
        container = May::CustomCommand::Container
        expect(container.commands.size).to eq(2)
      end
    end
  end

  describe ".get_binding" do
    context "register from string" do
      let(:input) do
        str=<<EOS
        register_command 'sample' do
          template    'Entity'
          description 'this is entity.'
          super_class 'AMEEntity'
        end
EOS
      end

      it "should return binding to eval from string" do
        eval input, May::CustomCommand::DSL.get_binding
        container = May::CustomCommand::Container
        expect(container.commands.size).to eq(1)
        command = container.commands[0]
        expect(command.command_name).to eq('sample')
        expect(command.template_name).to eq('Entity')
        expect(command.description).to eq('this is entity.')
        expect(command.default_super_class).to eq('AMEEntity')
      end
    end
  end
end
