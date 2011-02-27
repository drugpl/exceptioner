require 'redmine_client'

module Exceptioner
  module Transport
    class Redmine < Base

      def connection(&block)
        RedmineClient::Base.configure(&block)
      end

      def deliver(options = {})
        options = config.attributes.merge(options)
        options[:subject] ||= prefixed_subject(options)
        options[:description] ||= render(options)
        begin
          issue = RedmineClient::Issue.new(
            :subject     => options[:subject],
            :description => options[:description],
            :project_id  => options[:project]
          )
          issue.save
        rescue ActiveResource::UnauthorizedAccess
          puts 'Warning: Unauthorized Access please check http://www.redmine.org/projects/redmine/wiki/Rest_api#Authentication'
        rescue ActiveResource::ResourceNotFound
          puts "Warning: Can't find project #{options[:project]}"
        end
      end
    end
  end
end
