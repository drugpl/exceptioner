require 'tinder'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport

  class Campfire < Base

    def deliver(issue)
      @rooms = config.rooms
      connect do |campfire|
        campfire.rooms.each do |room|
          room.paste render(issue) if @rooms.include?(room.id) || @rooms.include?(room.name)
        end
      end
    end

    protected

    def connect
      params = if config.token.present?
                 { :token => config.token }
               elsif config.username.present? && config.password.present?
                 { :username => config.username, :password => config.password }
               end
      campfire = Tinder::Campfire.new config.subdomain, params
      yield campfire
    end

  end
end
