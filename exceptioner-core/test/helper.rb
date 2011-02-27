require 'test/unit'
require 'mocha'
require 'bundler/setup'
Bundler.setup

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'exceptioner'
require 'exceptioner/test/exceptioner_test_case'
require 'rack'
require 'test_transport'
