require 'redmine_client'
require 'exceptioner/transport/base'

module Exceptioner
  module Transport
    class Redmine < Base

      def deliver(issue)
        options = config.attributes
        options[:subject] ||= prefixed_subject(issue)
        options[:description] ||= render(issue)
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
