# encoding: utf-8

require 'spec_helper'
require 'ice_nine'

describe IceNine::Freezer::Range, '.deep_freeze' do
  subject { object.deep_freeze(value) }

  let(:object) { described_class }

  let(:element_class) do
    Class.new do
      attr_reader :number, :range
      protected :number, :range

      def initialize(number)
        @number = number
        @range  = nil
      end

      def succ
        self.class.new(number.succ, range)
      end

      def <=>(other)
        range <=> other.range && number <=> other.number
      end

      # allow for circular references
      def range=(range)
        @range = range
      end
    end
  end

  context 'with a Range' do
    let(:value) { 1..2 }

    context 'without a circular reference' do
      it_behaves_like 'IceNine::Freezer::NoFreeze.deep_freeze'

      it 'returns the object' do
        should be(value)
      end

      it 'does not freeze the object' do
        expect { subject }.to_not change(value, :frozen?).from(value.frozen?)
      end

      it 'does not freeze instance variables' do
        if subject.instance_variable_defined?(:@a)
          expect(subject.instance_variable_get(:@a)).to_not be_frozen
        end
      end
    end
  end
end
