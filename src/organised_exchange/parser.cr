module OrganisedExchange
  class Parser
    def self.parse(source)
      parser = self.new

      source.each do |line|
        parser << line
      end

      parser.formatted
    end

    def initialize
      @events = [] of Event

      @event = Event.new
      @parsing = false
    end

    def <<(line)
      case line
      when "BEGIN:VEVENT"
        @parsing = true
        @event = Event.new
      when "END:VEVENT"
        @parsing = false

        unless @event.nil?
          if @event.valid?
            @events << @event
          end
        end
        @event = Event.new
      else
        parse(line)
      end
    end

    def formatted
      @events.sort_by { |ev| ev.start_time }.each { |ev| puts ev.to_org }
    end

    def parse(line)
      parse_summary(line)
      parse_start(line)
      parse_end(line)
      parse_location(line)
      parse_description(line)
    end

    def parse_summary(line)
      content = line.split("SUMMARY:")

      if content.size > 1
        @event.title = content[1]
      end
    end

    # DTSTART;TZID=GMT Standard Time:20190927T103000
    def parse_start(line)
      content = %r{DTSTART;TZID=GMT Standard Time:(\d+T\d+)}.match(line)

      if content
        @event.start_time = Time.parse_iso8601 "#{content[1]}+0100"
      end
    end

    # DTEND;TZID=GMT Standard Time:20191001T113000
    def parse_end(line)
      content = %r{DTEND;TZID=GMT Standard Time:(\d+T\d+)}.match(line)

      if content
        @event.end_time = Time.parse_iso8601 "#{content[1]}+0100"
      end
    end

    def parse_location(line)
      content = line.split("LOCATION:")

      if content.size > 1
        @event.location = content[1]
      end
    end

    def parse_description(line)
      content = line.split("DESCRIPTION:")

      if content.size > 1
        @event.description = content[1]
      end
    end
  end
end
