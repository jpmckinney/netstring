require 'delegate'

# A netstring parser and emitter.
#
# @see http://cr.yp.to/proto/netstrings.txt
class Netstring < SimpleDelegator
  class Error < StandardError; end

  # Returns the netstring.
  #
  # @return [String] the netstring
  attr_reader :netstring

  # Dumps a string to a netstring.
  #
  # @param [String] s a string
  # @return [String] a netstring
  def self.dump(s)
    unless String === s
      raise Error, "#{s.inspect} is not a String"
    end
    "#{s.bytesize}:#{s},"
  end

  # Loads a string from a netstring.
  #
  # The netstring may be multiple concatenated netstrings.
  #
  # The return value is a `Netstring` object, whose `#to_s` method returns the
  # string, and whose `#offset` method returns the length of the netstring.
  #
  # @param [String] n a netstring
  # @return [Netstring] a string
  def self.load(n)
    unless String === n
      raise Error, "#{n.inspect} is not a String"
    end
    match = n.match(/\A(\d+):/)
    unless match
      raise Error, 'bad netstring header'
    end
    size = Integer(match[1])
    unless n.byteslice(match.end(0) + size) == ','
      raise Error, 'expected "," delimiter'
    end
    new(n, match.end(0), size)
  end

  # Initializes a netstring.
  #
  # The netstring may be multiple concatenated netstrings.
  #
  # @param [String] n a netstring
  # @param [Integer] start the start of the string in the netstring
  # @param [Integer] length the length of the string in the netstring
  def initialize(n, start, length)
    super(n.byteslice(start, length))

    @netstring = n.byteslice(0, start + length + 1)
  end
end
