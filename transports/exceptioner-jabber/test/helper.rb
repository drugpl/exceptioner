require 'test/unit'
require 'mocha'
require 'xmpp4r'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'exceptioner'
require 'exceptioner/test/transport_test_case'
require 'exceptioner-jabber'
