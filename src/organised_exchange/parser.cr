module OrganisedExchange
  class Parser
    def self.parse(source, time : Time)
      parser = self.new(time)

      source.each do |line|
        parser << line
      end

      parser.formatted
    end

    def initialize(time : Time)
      @now = time
      @events = [] of Event

      @event = Event.new(@now)
      @parsing = false
    end

    def <<(line)
      case line
      when "BEGIN:VEVENT"
        @parsing = true
        @event = Event.new(@now)
      when "END:VEVENT"
        @parsing = false

        unless @event.nil?
          if @event.valid? && @event.scheduled?
            @events << @event
          end
        end
        @event = Event.new(@now)
      else
        parse(line)
      end
    end

    def formatted
      @events.sort_by { |ev| ev.start_time }.map { |ev| ev.to_org }
    end

    def parse(line)
      matched = matcher.match(line)
      op = matched.try &.["op"]
      value = matched.try &.["value"]

      case op
      when "SUMMARY"
        @event.title = value
      when "DTSTART"
        @event.start_time = Time.parse_iso8601("#{value}+0100")
      when "DTEND"
        @event.end_time = Time.parse_iso8601("#{value}+0100")
      when "LOCATION"
        @event.location = value
      when "DESCRIPTION"
        @event.description = value
      when "RRULE"
        rec = parse_recurrency(value)
        @event.recurrency = parse_recurrency(value)
      end
    end

    def matcher
      %r{(?<op>[A-Z]+);?(TZID=(?<tzid>GMT Standard Time))?:(?<value>.+)}
    end

    #"FREQ=WEEKLY;UNTIL=20410924T093000Z;INTERVAL=1;BYDAY=FR;WKST=SU"
    def parse_recurrency(value)
      value.try &.split(";").map { |i| i.split("=") }.to_h
    end
  end
end
