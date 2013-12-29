require 'spec_helper'

describe Schnitzelpress::Environment do

  subject { object.current }

  let(:object) { described_class.new(environment) }

  describe '#current rack env test' do

    let(:environment) { {'RACK_ENV' => 'test'} }

    specify do
      should eql(:test)
    end
  end

  describe '#current rack env development' do

    let(:environment) { {'RACK_ENV' => 'development'} }

    specify do
      should eql(:development)
    end
  end

  describe '#current rack env production' do

    let(:environment) { {'RACK_ENV' => 'production'} }

    specify do
      should eql(:production)
    end
  end

  describe '#current' do

    let(:environment) { {'RACK_ENV' => '<sdfsdfds>'} }

    it 'throws exception on unknown environment' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end
end