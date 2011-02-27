module Exceptioner
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copy Exceptioner default files'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializers
        copy_file 'exceptioner.rb', 'config/initializers/exceptioner.rb'
      end

    end
  end
end
