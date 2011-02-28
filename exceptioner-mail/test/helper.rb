require 'bundler/setup'
require 'test/unit'
require 'mocha'

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'exceptioner'
require 'exceptioner/test/transport_test_case'
require 'exceptioner-mail'
require 'mock_smtp'
