require 'exceptioner/core_ext/class/attribute_accessors'

module Exceptioner

  class ExceptionerError < StandardError; end

  autoload :Middleware, 'exceptioner/middleware'
  
  module Transport
    autoload :Email, 'exceptioner/transport/email'
  end


end
