require 'spec_helper'

describe Schnitzelpress::Fixture::FontAwesomeCharMap do

  subject { described_class.all }

  describe '#all' do
    it 'should return a Hash' do
      expect(subject).to be_a(Hash)
    end

    it 'should return a Hash with 140 items' do
      expect(subject.size).to eql(140)
    end
  end
end
