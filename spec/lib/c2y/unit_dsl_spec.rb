require "spec_helper"

module C2y
  describe DSL do
    describe "unit" do
      context "with options" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
unit "docker-tcp" do
  command :start
  enable true
  content <<-CONTENT
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=2375
Service=docker.service
BindIPv6Only=both

[Install]
WantedBy=sockets.target
  CONTENT
end
          EOS
          end
        end

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.units.first
        end

        its(:name) { is_expected.to eq "docker-tcp" }
        its(:command) { is_expected.to eq :start }
        its(:enable) { is_expected.to be true }
        its(:content) { is_expected.to eq(<<-EOS) }
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=2375
Service=docker.service
BindIPv6Only=both

[Install]
WantedBy=sockets.target
        EOS
      end
    end
  end
end
