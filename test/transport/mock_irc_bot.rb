$LOAD_PATH.unshift 'lib'
require 'isaac'
require 'rubygems'
require 'test/unit'
require 'contest'
require 'timeout'

begin
  require 'ruby-debug'
rescue LoadError; end

module Test::Unit::Assertions
  def assert_empty_buffer(io)
    assert_raise(Errno::EAGAIN) { io.read_nonblock 1 }
  end
end

class MockSocket
  def self.pipe
    socket1, socket2 = new, new
    socket1.in, socket2.out = IO.pipe
    socket2.in, socket1.out = IO.pipe
    [socket1, socket2]
  end

  attr_accessor :in, :out
  def gets()
    Timeout.timeout(1) {@in.gets}
  end
  def puts(m) @out.puts(m) end
  def print(m) @out.print(m) end
  def eof?() @in.eof? end
  def empty?
    begin
      @in.read_nonblock(1)
      false
    rescue Errno::EAGAIN
      true
    end
  end
  def closed?; false end
  def close; end
  def write(m); print(m) end
end
