require 'spec_helper'
require 'may/templator'

describe May::Template do
  context 'given file as a argument' do
    let(:file) { Fixtures.file('SampleViewController.m.erb') }
    let(:subject) { May::Template.new(file) }
    it { should be_kind_of May::Template }

    describe '#body' do
      its(:body) { should_not be_empty }
    end
  end

  context 'given nil as a argument' do
    let(:subject) { May::Template.new(nil) }
    it { should be_kind_of May::Template }

    describe '#body' do
      its(:body) { should be_empty }
    end
  end
end

describe May::Generator do
  context 'given template file' do
    let(:binding)  { May::RenderBinding.new(class_name: 'SampleViewController') }
    let(:template) { May::Template.new(Fixtures.file('SampleViewController.m.erb')) }
    let(:subject)  { May::Generator.new(binding) }

    describe 'generate' do
      it 'should render' do
        expect(subject.generate(template)).to eq((<<RENDER).chomp)
@implementation SampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
RENDER
      end
    end
  end
end
