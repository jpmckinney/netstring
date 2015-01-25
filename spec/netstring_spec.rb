# coding: utf-8
require 'spec_helper'

RSpec.describe Netstring do
  let :strings do
    {
      '' => '0:,',
      'x' => '1:x,',
      'xy' => '2:xy,',
    }
  end

  let :netstrings do
    strings.invert
  end

  describe '.dump' do
    it 'should dump a netstring' do
      strings.each do |string,netstring|
        expect(Netstring.dump(string)).to eq(netstring)
      end
    end

    it 'should dump a UTF-8 string' do
      expect(Netstring.dump('é')).to eq('2:é,')
    end

    it 'should not dump a non-string' do
      {
        nil => 'nil',
        true => 'true',
        false => 'false',
        1 => '1',
        1.1 => '1.1',
        [] => '[]',
        {} => '{}',
      }.each do |nonstring,inspect|
        expect{Netstring.dump(nonstring)}.to raise_error(Netstring::Error, "#{inspect} is not a String")
      end
    end
  end

  describe '.load' do
    it 'should load a netstring' do
      netstrings.each do |netstring,string|
        expect(Netstring.load(netstring)).to eq(string)
      end
    end

    it 'should load a UTF-8 string' do
      expect(Netstring.load('2:é,')).to eq('é')
    end

    it 'should not load a nonstring' do
      {
        nil => 'nil',
        true => 'true',
        false => 'false',
        1 => '1',
        1.1 => '1.1',
        [] => '[]',
        {} => '{}',
      }.each do |nonstring,inspect|
        expect{Netstring.load(nonstring)}.to raise_error(Netstring::Error, "#{inspect} is not a String")
      end
    end

    it 'should not load a non-netstring' do
      [
        ['1', ':', 'x', ','],
        ['1', ':', 'xy', ','],
        ['2', ':', 'x', ','],
      ].each do |tokens|
        1.upto(4) do |n|
          tokens.permutation(n) do |p|
            nonnetstring = p.join
            unless ['1:x,'].include?(nonnetstring)
              expect{Netstring.load(nonnetstring)}.to raise_error(Netstring::Error)
            end
          end
        end
      end
    end
  end

  describe '#initialize' do
    it 'should initialize a netstring' do
      expect(Netstring.new('1:x,2:xy,', 2, 1)).to eq('x')
    end

    it 'should initialize a UTF-8 netstring' do
      expect(Netstring.new('4:éè,4:êë,', 2, 4)).to eq('éè')
    end
  end

  describe '#netstring' do
    it 'should return the netstring' do
      expect(Netstring.new('1:x,2:xy,', 2, 1).netstring).to eq('1:x,')
    end

    it 'should return the UTF-8 netstring' do
      expect(Netstring.new('4:éè,4:êë,', 2, 4).netstring).to eq('4:éè,')
    end
  end
end
