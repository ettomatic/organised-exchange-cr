require "spec"

describe "integration test" do
  it "returns org formatted sections" do
    fixture = Path["spec/fixtures/calendar.ics"]
    OrganisedExchange::Parser.parse(OrganisedExchange::Sources::Mock.new(fixture))
  end
end
