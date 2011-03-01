# Original mockup from ActionMailer
require 'net/smtp'
class MockSMTP
  
  def self.deliveries
    @@deliveries
  end

  def initialize
    @@deliveries = []
  end

  def sendmail(body, from, to)
    puts "CALLED SEND"
    @@deliveries << Mail.new(:from => from, :to => to, :body => body)
  end

  def start(*args)
    yield self
  end
  
  def self.clear_deliveries
    @@deliveries = []
  end
  
  # in the standard lib: net/smtp.rb line 577
  #   a TypeError is thrown unless this arg is a
  #   kind of OpenSSL::SSL::SSLContext
  def enable_tls(context = nil)
    if context && context.kind_of?(OpenSSL::SSL::SSLContext)
      true
    elsif context
      raise TypeError,
        "wrong argument (#{context.class})! "+
        "(Expected kind of OpenSSL::SSL::SSLContext)"
    end
  end

  def enable_starttls_auto
    true
  end
  
end

class Net::SMTP
  def self.new(*args)
    MockSMTP.new
  end
end


