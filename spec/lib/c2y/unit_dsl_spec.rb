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

        it do
          dsl = described_class.parse(cloudconfigfile)
          expect(dsl.units.length).to eq 1
          unit = dsl.units.first
          expect(unit.name).to eq "docker-tcp"
          expect(unit.command).to eq "start"
          expect(unit.enable).to be true
          expect(unit.content).to eq(<<-EOS)
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
end
