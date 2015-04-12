require "spec_helper"

module C2y
  describe Client do
    let(:client) { described_class.new }

    describe "#convert" do
      let(:cloudconfigfile) do
        CloudConfigFile.create do
          <<-EOS
etcd "node001" do
  discovery "https://discovery.etcd.io/<token>"
  addr "$public_ipv4:4001"
  peer_addr "$private_ipv4:7001"
end

update do
  group :beta
  reboot_strategy "best-effort"
end
          EOS
        end
      end

      before do
        ENV["SERVER_NAME"] = "hoge.example.com"
      end

      it "should generate yaml" do
        expect(client.convert(cloudconfigfile)).to eq <<-EOS
#cloud-config

coreos:
  etcd:
    name: node001
    discovery: https://discovery.etcd.io/<token>
    addr: "$public_ipv4:4001"
    peer-addr: "$private_ipv4:7001"
  update:
    group: beta
    reboot-strategy: best-effort
        EOS
      end
    end
  end
end
