namespace :exceptioner do
  namespace :jabber do
    desc "Register new Jabber account and send subscription requests to all recipients"
    task :setup => [:register, :subscribe]

    desc "Register Jabber account used by Exceptioner"
    task :register => :environment do
      Exceptioner.transport_instance(:jabber).register
    end

    desc "Send subscription request to all Exceptioner recipients"
    task :subscribe => :environment do
      Exceptioner.transport_instance(:jabber).subscribe
    end
  end
end
