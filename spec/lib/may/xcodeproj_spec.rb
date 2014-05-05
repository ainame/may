require 'spec_helper'
require 'may/xcodeproj'

describe May::Xcodeproj do
  before do
    Fixtures::Xcodeproj.setup
  end

  after do
    Fixtures::Xcodeproj.teardown
  end

  context 'given xcodeproj' do
    let(:xcodeproj_path) { Fixtures::Xcodeproj.path }
    let(:subject) { May::Xcodeproj.new(xcodeproj_path) }

    it 'should be valid instantiate with a argument' do
      expect(subject).to be_kind_of(May::Xcodeproj)
    end

    context '' do
      let(:fixture_file_path) { Fixtures::Xcodeproj.classes_file_for('SampleViewController.m') }
      it 'should have not ' do
        expect(subject.exists?(fixture_file_path)).to be_false
      end

      it 'should have' do
        FileUtils.cp(Fixtures.file('SampleViewController.m.erb'), fixture_file_path)
        subject.add_file(fixture_file_path)
        subject.save
        expect(subject.exists?(fixture_file_path)).to be_true
      end
    end
  end
end
