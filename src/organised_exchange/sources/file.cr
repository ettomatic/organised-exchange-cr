module OrganisedExchange
  module Sources
    class File
      @location : Path

      def initialize(config : OrganisedExchange::Config)
        @location = Path[config.location].expand(home: true)
      end

      def each
        ::File.each_line(@location) do |line|
          yield line
        end
      end
    end
  end
end
