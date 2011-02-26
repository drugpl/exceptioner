require 'erb'
require 'redmine_client'

module Exceptioner::Transport

  class Redmine < Base
    class_attribute :project # id_or_identifier of redmine project
    class_attribute :options # redmine issue options

    def connection(&block)
      RedmineClient::Base.configure(&block)
    end

    def deliver(options = {})
      options[:subject] ||= prefixed_subject(options)
      options[:description] ||= render(options)
      begin
        issue = RedmineClient::Issue.new(
          :subject     => self.options[:subject],
          :description => self.options[:description],
          :project_id  => self.class.project
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
