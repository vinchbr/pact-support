require 'pact/consumer_contract/merge_matching_rules_with_example'

module Pact

  describe MergeMatchingRulesWithExample do

    subject { MergeMatchingRulesWithExample.call expected_body, "$body", matching_rules }

    describe "no recognised rules" do
      let(:expected_body) do
        {
          "_links" => {
            "self" => {
              "href" => "http://localhost:1234/thing"
            }
          }
        }
      end

      let(:matching_rules) do
        {
          "$body._links.self.href" => { }
        }
      end

      it "returns the object at that path unaltered" do
        expect(subject["_links"]["self"]["href"]).to eq "http://localhost:1234/thing"
      end

      it "it logs the rules it has ignored"

    end


    describe "regular expressions" do

      describe "in a hash" do
        let(:expected_body) do
          {
            "_links" => {
              "self" => {
                "href" => "http://localhost:1234/thing"
              }
            }
          }
        end

        let(:matching_rules) do
          {
            "$body._links.self.href" => { "regex" => "http:\\/\\/.*\\/thing" }
          }
        end
        it "creates a Pact::Term at the appropriate path" do
          expect(subject["_links"]["self"]["href"]).to be_instance_of(Pact::Term)
          expect(subject["_links"]["self"]["href"].generate).to eq "http://localhost:1234/thing"
          expect(subject["_links"]["self"]["href"].matcher.inspect).to eq "/http:\\/\\/.*\\/thing/"
        end
      end

      describe "with an array" do

        let(:expected_body) do
          {
            "_links" => {
              "self" => [{
                  "href" => "http://localhost:1234/thing"
              }]
            }
          }
        end

        let(:matching_rules) do
          {
            "$body._links.self[0].href" => { "regex" => "http:\\/\\/.*\\/thing" }
          }
        end
        it "creates a Pact::Term at the appropriate path" do
          expect(subject["_links"]["self"][0]["href"]).to be_instance_of(Pact::Term)
          expect(subject["_links"]["self"][0]["href"].generate).to eq "http://localhost:1234/thing"
          expect(subject["_links"]["self"][0]["href"].matcher.inspect).to eq "/http:\\/\\/.*\\/thing/"
        end
      end
    end


  end

end
