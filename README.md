# Netstring: A netstring parser and emitter

[![Gem Version](https://badge.fury.io/rb/netstring.svg)](https://badge.fury.io/rb/netstring)
[![Build Status](https://secure.travis-ci.org/jpmckinney/netstring.png)](https://travis-ci.org/jpmckinney/netstring)
[![Dependency Status](https://gemnasium.com/jpmckinney/netstring.png)](https://gemnasium.com/jpmckinney/netstring)
[![Coverage Status](https://coveralls.io/repos/jpmckinney/netstring/badge.png)](https://coveralls.io/r/jpmckinney/netstring)
[![Code Climate](https://codeclimate.com/github/jpmckinney/netstring.png)](https://codeclimate.com/github/jpmckinney/netstring)

See the [netstring](http://cr.yp.to/proto/netstrings.txt) specification for details.

## Usage

```ruby
require "netstring"
```

Dump:

```ruby
netstring = Netstring.dump("xyz") # "3:xyz,"
```

Load:

```ruby
string = Netstring.load("3:xyz,") # "xyz"
```

Get the netstring from which the string was loaded:

```ruby
string.netstring # "3:xyz,"
```

Load concatenated netstrings:

```ruby
netstring = "1:x,3:xyz,"
string1 = Netstring.load(netstring1) # "x"
offset = string1.netstring.size
netstring = netstring[offset..-1]
string2 = Netstring.load(netstring) # "xyz"
```

Load concatenated netstrings in a loop:

```ruby
netstring = "1:x,3:xyz,"
strings = []
until netstring.empty?
  strings << Netstring.load(netstring)
  netstring = netstring[strings.last.netstring.size..-1]
end
```

Copyright (c) 2014 James McKinney, released under the MIT license
