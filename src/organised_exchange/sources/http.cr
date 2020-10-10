module OrganisedExchange
  module Sources
    class Http
      def initialize(@config : OrganisedExchange::Config)
      end

      def each
        ::File.each_line(@config.location) do |line|
          yield line
        end
      end
    end
  end
end
