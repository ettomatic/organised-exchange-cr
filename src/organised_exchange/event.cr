module OrganisedExchange
  struct Event
    property start_time : Time
    setter end_time : Time

    setter title : String | Nil
    setter location : String | Nil
    setter description : String | Nil
    setter recurrency : Hash(String,String) | Nil

    def initialize(time : Time)
      @now = time
      @start_time = Time::UNIX_EPOCH
      @end_time = Time::UNIX_EPOCH
    end

    def valid?
      @title != nil && @start_time != nil
    end

    def to_org
      if valid?
        "* #{@title}\nSCHEDULED: <#{org_time(scheduled)}>\n"
      end
    end

    def scheduled?
      @start_time > Time.utc
    end

    def repeated?
      @recurrency.try &.has_key?("INTERVAL")
    end

    def scheduled
      if repeated?
        get_next_day(repeated_on)
      else
        @start_time
      end
    end

    def get_next_day(day_of_week : Time::DayOfWeek | Nil)
      return unless day_of_week

      @now + ((day_of_week.to_i - @now.day_of_week.to_i) % 7).days
    end

    def date_of_next(day)
      date  = Date.parse(day)
      delta = date > Time.utc.day_of_week.to_i ? 0 : 7
      date + delta
    end

    def past?
      @start_time < Time.utc
    end

    def repeated_until
      u = @recurrency.try &.["UNTIL"]?
      if u
        Time.parse_iso8601("#{u}+0100")
      end
    end

    def repeated_on
      byday = @recurrency.try &.["BYDAY"]?
      if byday
        map = {
          "MO" => 1, "TU" => 2, "WE" => 3,
          "TH" => 4, "FR" => 5, "SA" => 6, "SU" => 7
        }
        Time::DayOfWeek.from_value(map[byday])
      end
    end

    # for now...
    private def org_time(time)
      if time
        time.to_utc.to_s("%Y-%m-%d %a %H:%M")
      end
    end
  end
end
