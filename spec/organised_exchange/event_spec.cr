require "spec"

describe "OrganisedExchange::Event" do
  now  = Time.utc(2020, 12, 27, 10, 30, 0)
  time = Time.utc(2021, 10, 8, 9, 30, 0)
  past = Time.utc(2019, 10, 8, 9, 30, 0)

  describe "#valid?" do
    context "an event scheduled in the future" do
      it "returns true" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "an event with a title and a start time"
        ev.start_time = time

        ev.valid?.should be_true
      end
    end

    context "failure" do
      it "an event with no title" do
        ev = OrganisedExchange::Event.new(now)
        ev.start_time = time

        ev.valid?.should be_false
      end

      it "an event scheduled in the past" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "an event with a title and an expired start time"
        ev.start_time = past

        ev.valid?.should be_false
      end
    end
  end

  describe "#scheduled" do
    context "repeated occurrences" do
      it "returns the next scheduled date" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "an recurrent event started in the past"
        ev.start_time = past
        ev.recurrency = {"FREQ" => "WEEKLY", "UNTIL" => "20410924T093000Z",
                         "INTERVAL" => "1", "BYDAY" => "FR", "WKST" => "SU"}

        ev.valid?.should be_true
        ev.scheduled.should eq Time.utc(2021, 1, 1, 10, 30, 0)

      end
    end

    context "a single occurrence" do
      it "return the scheduled date" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "an event with a title and a start time"
        ev.start_time = time

        ev.valid?.should be_true
        ev.scheduled.should eq time
      end
    end

    context "an event scheduled in the past" do
      it "return the scheduled date" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "an event with a title and an expired start time"
        ev.start_time = past

        ev.valid?.should be_false
        ev.scheduled.should eq past
      end
    end
  end

  describe "#to_org" do
    context "success" do
      it "returns an org section" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "An event"
        ev.start_time = time

        ev.to_org.should eq "* An event\nSCHEDULED: <2021-10-08 Fri 09:30>\n"
      end
    end

    context "failure" do
      it "return nil" do
        ev = OrganisedExchange::Event.new(now)

        ev.to_org.should be_nil
      end
    end
  end
end
