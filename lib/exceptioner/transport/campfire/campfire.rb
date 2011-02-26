require 'tinder'
require 'erb'
require 'exceptioner/transport/base'
require 'exceptioner/transport/helper'

module Exceptioner::Transport
  class Campfire < Base
    class << self
      attr_accessor :subdomain, :token, :username, :password
      attr_accessor :room, :rooms

      def prepare_rooms
        self.rooms = [self.room] if self.room.present?
        self.rooms
      end
    end

    def deliver(options = {})
      @rooms = self.class.prepare_rooms
      connect do |campfire|
        campfire.rooms.each do |room|
          room.paste render(options) if @rooms.include?(room.id) || @rooms.include?(room.name)
        end
      end
    end

    protected

    def connect
      params = if self.class.token.present?
        { :token => self.class.token }
      elsif self.class.username.present? && self.class.password.present?
        { :username => self.class.username, :password => self.class.password }
      end
      campfire = Tinder::Campfire.new self.class.subdomain, params
      yield campfire
    end
  end
end
