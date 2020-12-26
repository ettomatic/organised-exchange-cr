require "json"

module OrganisedExchange
  class Config
    CONFIG_FILE = Path["~/.organised_exchange.config"].expand(home: true)

    def self.generate
      default_config = {source: "file", location: "~/Downloads/calendar.ics"}
      File.write(CONFIG_FILE, default_config.to_json)
    end

    def initialize
      unless File.exists?(CONFIG_FILE)
        STDERR.puts "#{CONFIG_FILE} not found, run 'organised_exchange init'"
        exit(1)
      end

      json = File.read(CONFIG_FILE)
      @config = Hash(String, String).from_json(json)
    end

    def source
      @config["source"]
    rescue KeyError
      STDERR.puts "ERROR: source not set in #{CONFIG_FILE}"
      exit(1)
    end

    def location
      @config["location"]
    rescue KeyError
      STDERR.puts "ERROR: location not set in #{CONFIG_FILE}"
      exit(1)
    end

    def destination
      @config["destination"]
    rescue KeyError
      STDERR.puts "ERROR: destination not set in #{CONFIG_FILE}"
      exit(1)
    end
  end
end
