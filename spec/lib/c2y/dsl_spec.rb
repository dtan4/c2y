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
          update = dsl.update
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
          update = dsl.update
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

    describe "container_unit" do
      context "with options" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
container_unit "nginx" do
  command :start
  enable true
  image "nginx"
  ports %w(80:80)
  environments({
    "SERVER_NAME" => ENV["SERVER_NAME"],
  })
  volumes %w(/home/core/html:/var/www/html)
end
          EOS
          end
        end

        let(:server_name) { "example.com" }

        around do |example|
          env_server_name = ENV["SERVER_NAME"]
          ENV["SERVER_NAME"] = server_name
          example.run
          ENV["SERVER_NAME"] = env_server_name
        end

        it do
          dsl = described_class.parse(cloudconfigfile)
          expect(dsl.container_units.length).to eq 1
          container_unit = dsl.container_units.first
          expect(container_unit.name).to eq "nginx"
          expect(container_unit.enable).to be true
          expect(container_unit.environments).to eql({
            "SERVER_NAME" => server_name
          })
          expect(container_unit.image).to eq "nginx"
          expect(container_unit.ports).to eql([
            "80:80"
          ])
          expect(container_unit.volumes).to eql([
            "/home/core/html:/var/www/html"
          ])
#           expect(container_unit.content).to eq(<<-EOS)
# [Unit]
# Description=Docker Socket for the API

# [Socket]
# ListenStream=2375
# Service=docker.service
# BindIPv6Only=both

# [Install]
# WantedBy=sockets.target
#           EOS
        end
      end
    end

    describe "user" do
      context "with options" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
user "dtan4" do
  github "dtan4"
  groups %w(sudo docker)
end
          EOS
          end
        end

        it do
          dsl = described_class.parse(cloudconfigfile)
          expect(dsl.users.length).to eq 1
          user = dsl.users.first
          expect(user.name).to eq "dtan4"
          expect(user.github).to eq "dtan4"
          expect(user.groups).to eql(%w(sudo docker))
        end
      end
    end
  end
end
