require "spec_helper"

module C2y
  describe DSL do
    describe "fleet" do
      context "with options" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
fleet do
  public_ip "$public_ipv4"
  metadata({
    region: "us-east"
  })
end
          EOS
          end
        end

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.fleet
        end

        its(:public_ip) { is_expected.to eq "$public_ipv4" }
        its(:metadata) { is_expected.to eql({ region: "us-east" }) }
      end
    end
  end
end
