require "spec_helper"

module C2y
  describe DSL do
    describe "etcd" do
      context "with options" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
etcd "node001" do
  discovery "https://discovery.etcd.io/<token>"
  addr "$public_ipv4:4001"
  peer_addr "$private_ipv4:7001"
end
          EOS
          end
        end

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.etcd
        end

        its(:name) { is_expected.to eq "node001" }
        its(:discovery) { is_expected.to eq "https://discovery.etcd.io/<token>" }
        its(:addr) { is_expected.to eq "$public_ipv4:4001" }
        its(:peer_addr) { is_expected.to eq "$private_ipv4:7001" }
      end
    end
  end
end
