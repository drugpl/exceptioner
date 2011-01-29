namespace :exceptioner do
  namespace :jabber do
    desc "Register Jabber account used by Exceptioner"
    task :register => :environment do
      Exceptioner::Transport::Jabber.register
    end
  end
end
