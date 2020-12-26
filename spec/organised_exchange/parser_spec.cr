require "spec"

describe "integration test" do
  it "returns org formatted sections" do
    fixture = Path["spec/fixtures/calendar.ics"]
    org = OrganisedExchange::Parser.parse(OrganisedExchange::Sources::Mock.new(fixture))
    org.should eq  ["* Joe 1:1\nSCHEDULED: <2039-09-27 Fri 09:30>\n"]
  end
end
