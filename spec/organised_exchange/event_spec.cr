require "spec"

describe "OrganisedExchange::Event" do
  now  = Time.utc(2020, 12, 27, 10, 30, 30)
  time = Time.utc(2020, 10, 9, 9, 30, 0)

  describe "#valid?" do
    context "success" do
      it "returns true" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "an event with a title and a start time"
        ev.start_time = time

        ev.valid?.should be_true
      end
    end

    context "failure" do
      it "returns false" do
        ev = OrganisedExchange::Event.new(now)
        ev.start_time = time

        ev.valid?.should be_false
      end
    end
  end

  describe "#to_org" do
    context "success" do
      it "returns an org section" do
        ev = OrganisedExchange::Event.new(now)
        ev.title = "An event"
        ev.start_time = time

        ev.to_org.should eq "* An event\nSCHEDULED: <2020-10-09 Fri 09:30>\n"
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
