require "option_parser"
require "./organised_exchange/**"

# TODO: Write documentation for `OrganisedExchange`
module OrganisedExchange
  VERSION = "0.1.0"

  # TODO: Put your code here
  def self.run
    config = Config.new
    case config.source
    when "file"
      source = Sources::File
    when "http"
      source = Sources::Http
    else
      STDERR.puts "Source #{config.source} not recognised"
      exit(1)
    end

    org = Parser.parse(source.new(config))
    File.open(Path[config.destination].expand(home: true), "w+") do |f|
      org.each { |element| f.puts(element) }
    end
  end
end

options = OptionParser.parse do |parser|
  parser.banner = "Import Exchange ics into Org"

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "init", "Creates config file in ~/.organised_exchange.config" do
    OrganisedExchange::Config.generate
    exit
  end

  parser.on "generate", "Generates org file" do
    puts "starting...\n"
    OrganisedExchange.run
    exit
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

puts "starting...\n"

OrganisedExchange.run
