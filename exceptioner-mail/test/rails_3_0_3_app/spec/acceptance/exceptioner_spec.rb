require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Exceptioner" do
  scenario "Scenario name" do
    Net::SMTP.should_receive(:new).once
    begin
      get '/crashes'
    rescue Exception
      #it's fine, believe me
    end
  end
end
