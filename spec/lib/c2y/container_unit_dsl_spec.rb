require "spec_helper"

module C2y
  describe DSL do
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
  end
end
