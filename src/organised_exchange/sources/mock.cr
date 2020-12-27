module OrganisedExchange
  module Sources
    class Mock
      @location : Path

      def initialize(fixture_file)
        @location = fixture_file
      end

      def each
        ::File.each_line(@location) do |line|
          yield line
        end
      end
    end
  end
end
