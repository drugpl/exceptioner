module Exceptioner::Transport
  module Helper
    extend self

    def format_env(env)
      unless env.empty?
        max_length = env.keys.max_by { |key| key.to_s.size }.size
        env.keys.sort.collect do |key|
          "* #{"%-*s: %s" % [max_length, key, env[key].to_s.strip[0..50]]}"
        end
      end.join("\n\t")
    end

    def title(text)
      length = text.size + 5
      char = '#'
      "#{char * length}\n#{text}:\n#{char * length}\n"
    end



  end
end
