require 'spec_helper'

describe Schnitzelpress::Environment do

  subject { object.state }

  let(:object) { described_class.new(env_vars) }

  describe '#current' do

    describe 'rack env test' do
      let(:env_vars) { {'SCHNITZEL_ENV' => 'test'} }

      it { should eql(:test) }
    end

    describe 'rack env development' do
      let(:env_vars) { {'SCHNITZEL_ENV' => 'development'} }

      it { should eql(:development) }
    end

    describe 'rack env production' do
      let(:env_vars) { {'SCHNITZEL_ENV' => 'production'} }

      it { should eql(:production) }
    end

    describe '#current' do

      let(:env_vars) { {'SCHNITZEL_ENV' => '<sdfsdfds>'} }

      it 'throws exception on unknown environment' do
        expect { subject }.to raise_error(RuntimeError, 'Could not determine current environment!')
      end
    end
  end
end
