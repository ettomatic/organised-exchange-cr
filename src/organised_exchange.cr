require "option_parser"
require "./organised_exchange/**"

# TODO: Write documentation for `OrganisedExchange`
module OrganisedExchange
  VERSION = "0.1.0"

  # TODO: Put your code here
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

   parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

puts "starting...\n"


OrganisedExchange::Config.new.source
