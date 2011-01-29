namespace :exceptioner do
  namespace :jabber do
    desc "Register Jabber account used by Exceptioner"
    task :register => :environment do
      Exceptioner::Transport::Jabber.register
    end

    desc "Send subscription request to all Exceptioner recipients"
    task :subscribe => :environment do
      Exceptioner::Transport::Jabber.subscribe
    end
  end
end
