#xmpp4log.rb

=begin

This file is part of XMPP4Log.

XMPP4Log is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

XMPP4Log is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with XMPP4Log.  If not, see <http://www.gnu.org/licenses/>.

Copyright (c) 2009, Lucas Di Cioccio

=end

require	'xmpp4r-simple'
require 'thread'

Thread.abort_on_exception = true

class XMPPLogger < Logger

  attr_accessor :jabber, :users, :rd, :wr, :thread, :mute

  def initialize(login, pass, users)
    @jabber = Jabber::Simple.new(login, pass)
    @users = users
    @mute  = false
    @rd, @wr = IO.pipe
    super(@wr)
    @thread = Thread.new do
      run
    end
  end

  def deliver(msg)
    @users.each {|user| @jabber.deliver(user, msg)} if can_speak?
  end

  def run
    loop do
      r,w,e = select([@rd], nil, nil, 1)
      if r != nil
	msg = r[0].read_nonblock(1024) 
	break if msg.empty? #XXX nothing to read?
	deliver(msg) if msg and not msg.empty?
      end
      handle_commands
    end
  end

  def can_speak?
    not @mute
  end

  def handle_commands
      @jabber.received_messages do |msg|
	case msg.body.downcase
	when 'mute'
	  self.mute = true
	  self << "Logger set muted by #{msg.from}"
	when 'demute'
	  self.mute = false
	  self << "Logger set unmuted by #{msg.from}"
	when 'debug'
	  self.level = Logger::DEBUG
	  self << "Logger set to DEBUG level by #{msg.from}"
	when 'info'
	  self.level = Logger::INFO
	  self << "Logger set to INFO level by #{msg.from}"
	when 'warn'
	  self.level = Logger::WARN
	  self << "Logger set to WARN level by #{msg.from}"
	when 'error'
	  self.level = Logger::ERROR
	  self << "Logger set to ERROR level by #{msg.from}"
	when 'fatal'
	  self.level = Logger::FATAL
	  self << "Logger set to FATAL level by #{msg.from}"
	end
      end
  end

end
