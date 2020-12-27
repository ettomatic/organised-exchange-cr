require "spec"

describe "integration test" do
  now  = Time.utc(2020, 12, 27, 10, 30, 30)

  it "returns org formatted sections" do
    fixture = Path["spec/fixtures/calendar.ics"]
    org = OrganisedExchange::Parser.parse(OrganisedExchange::Sources::Mock.new(fixture), now)
    org.should eq  ["* Joe 1:1\nSCHEDULED: <2021-01-01 Fri 10:30>\n"]
  end
end
