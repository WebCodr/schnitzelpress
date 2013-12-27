require 'spec_helper'

describe Schnitzelpress::Environment do

  subject { object.current }

  let(:object) { described_class.new(environment) }

  describe '#current Circle CI' do

    let(:environment) { {'CI' => true, 'CIRCLECI' => true} }

    specify do
      should eql(:circle)
    end
  end

  describe '#current Circle CI' do

    let(:environment) { {'CI' => true, 'TRAVIS' => true} }

    specify do
      should eql(:travis)
    end
  end

  describe '#current drone.io' do

    let(:environment) { {'CI' => true, 'DRONE' => true} }

    specify do
      should eql(:drone)
    end
  end

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
      expect {subject}.to raise_error(RuntimeError)
    end
  end
end