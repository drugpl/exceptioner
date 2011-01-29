require 'tinder'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport
  
  class Campfirenow < Base
    
    class << self
        attr_accessor :subdomain, :token, :username, :password
        attr_accessor :room, :rooms

        def deliver(options = {})
          rooms = prepare_rooms
          connect do |campfirenow|
            campfirenow.rooms.each do |room|
              room.paste render(options) if rooms.include?(room.id) || rooms.include?(room.name)
            end
          end
        end

        protected

        def prepare_rooms
          self.rooms = [self.room] if self.room.present?
          self.rooms
        end
        
        def connect
          params = if token.present?
            { :token => token }
          elsif username.present? && password.present?
            { :username => username, :password => password }
          end
          campfirenow = Tinder::Campfirenow.new subdomain, params
          yield campfirenow
        end

    end

  end

end
