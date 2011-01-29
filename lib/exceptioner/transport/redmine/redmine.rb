require 'erb'
require 'redmine_client'

module Exceptioner::Transport

  class Redmine < Base
    class_attribute :project # id_or_identifier of redmine project
    class_attribute :options # redmine issue options

    def self.connection(&block)
      RedmineClient::Base.configure(&block)
    end

    def self.deliver(options = {})
      options[:subject] ||= prefixed_subject(options)
      options[:description] ||= render(options)
      begin
        issue = RedmineClient::Issue.new(
          :subject     => options[:subject],
          :description => options[:description],
          :project_id  => self.project
        )
        issue.save
      rescue ActiveResource::UnauthorizedAccess
        puts 'Warning: Unauthorized Access please check http://www.redmine.org/projects/redmine/wiki/Rest_api#Authentication'
      rescue ActiveResource::ResourceNotFound
        puts "Warning: Can't find project #{self.project}"
      end
    end
  end

end
