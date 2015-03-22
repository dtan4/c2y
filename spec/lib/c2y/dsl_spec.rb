require "spec_helper"

module C2y
  describe DSL do
    describe "update" do
      context "with no option" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
update do
end
          EOS
          end
        end

        it do
          dsl = described_class.parse(cloudconfigfile)
          update = dsl.result.update.result
          expect(update.group).to eq "alpha"
          expect(update.reboot_strategy).to eq "off"
        end
      end

      context "with options" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
update do
  group :beta
  reboot_strategy "best-effort"
end
          EOS
          end
        end

        it do
          dsl = described_class.parse(cloudconfigfile)
          update = dsl.result.update.result
          expect(update.group).to eq "beta"
          expect(update.reboot_strategy).to eq "best-effort"
        end
      end
    end

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
          unit = dsl.result.unit.result
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
