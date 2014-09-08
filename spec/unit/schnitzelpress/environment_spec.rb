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

  describe '#test?' do

    let(:env_vars) { {'SCHNITZEL_ENV' => 'test'} }

    specify do
      expect(object.test?).to be(true)
      expect(object.development?).to be(false)
      expect(object.production?).to be(false)
    end
  end

  describe '#production?' do

    let(:env_vars) { {'SCHNITZEL_ENV' => 'production'} }

    specify do
      expect(object.test?).to be(false)
      expect(object.development?).to be(false)
      expect(object.production?).to be(true)
    end
  end

  describe '#development?' do

    let(:env_vars) { {'SCHNITZEL_ENV' => 'development'} }

    specify do
      expect(object.test?).to be(false)
      expect(object.development?).to be(true)
      expect(object.production?).to be(false)
    end
  end
end