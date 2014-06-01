require 'spec_helper'
require 'may/path_resolver'

describe May::ProjectResolver do
  context '.new with the root dir path as argument' do
    let(:root_dir) { Dir.pwd }
    let(:subject) { May::ProjectResolver.new(root_dir) }
    it { should be_kind_of(May::ProjectResolver) }

    describe '#source_project' do
      context 'call with project name' do
        it 'should return path which it concat with project name' do
          expect(subject.source_project('project')).to eq(File.join(root_dir, 'project') )
        end
      end

      context 'call without argument' do
        it 'should return path which it concat with current directory name' do
          expect(subject.source_project).to eq(File.join(root_dir, File.basename(root_dir)))
        end
      end
    end

    describe '#test_project' do
      context 'call with project name' do
        it 'should return path which it concat with project name and Tests suffix' do
          expect(subject.test_project('project')).to eq(File.join(root_dir, 'projectTests') )
        end
      end

      context 'call without argument' do
        it 'should return path which it concat with current directory name and Tests suffix' do
          expect(subject.test_project).to eq(File.join(root_dir, File.basename(root_dir) + 'Tests'))
        end
      end
    end
  end

  context '.new without argument' do
    it 'should raise error' do
      expect { May::ProjectResolver.new }.to raise_error
    end
  end
end

describe May::FileResolver do
  context '.new with base dir' do
    let(:base_dir) { Dir.pwd }
    let(:subject)  { May::FileResolver.new(base_dir, '/path/to/destination') }
    it { should be_kind_of(May::FileResolver) }

    let(:some_file_path) { 'SampleViewController.m.erb' }
    describe '#header_file' do
      context 'call with path' do
        it 'should return path as .h file' do
          subject.stub(:join)
          subject.header_file
          expect(subject).to have_received(:join).with('/path/to/destination' + '.h').once
        end
      end
    end

    describe '#implementation_file' do
      context 'call with path' do
        it 'should return path as .m file' do
          subject.stub(:join)
          subject.implementation_file
          expect(subject).to have_received(:join).with('/path/to/destination' + '.m').once
        end
      end
    end

    describe '#test_file' do
      context 'call with path' do
        it 'should return path as Tests.m file' do
          subject.stub(:join)
          subject.test_file
          expect(subject).to have_received(:join).with('/path/to/destination' + 'Tests.m').once
        end
      end
    end
  end
end
