require 'spec_helper'
require 'may/custom_command'

describe May::CustomCommand do
  before do
    Fixtures::Xcodeproj.setup
  end

  after do
    Fixtures::Xcodeproj.teardown
    May::CustomCommand::Container.clear
  end

  let(:subject) do
    May::CustomCommand.new(MockApplicationContext.new)
  end


  context 'put Mayfile to root dir' do
    let(:input) do
      <<EOS
register_command 'sample' do
  template_name 'Entity'
  description 'this is entity.'
  default_super_class 'AMEEntity'
end
EOS
    end
    before do
      path = File.join(MockApplicationContext.new.root_dir, 'Mayfile')
      File.open(path, 'w+') do |f|
        f.puts input
      end
    end

    context 'loaded Mayfile' do
      before do
        subject.load
      end

      it "load Mayfile" do
        expect(subject.content).to eq(input)
      end

      describe '.eval_custom_file' do
        it "add commands from Mayfile" do
          subject.eval_custom_file
          container = May::CustomCommand::Container
          expect(container.commands.size).to eq(1)
        end
      end
    end
  end
end
