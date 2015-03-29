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

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.container_units.first
        end

        its(:name) { is_expected.to eq "nginx" }
        its(:enable) { is_expected.to be true }
        its(:environments) { is_expected.to eql({
          "SERVER_NAME" => server_name
        })}
        its(:image) { is_expected.to eq "nginx" }
        its(:ports) { is_expected.to eql([
          "80:80"
        ])}
        its(:volumes) { is_expected.to eql([
          "/home/core/html:/var/www/html"
        ])}
#         its(:content) { is_expected.to eq(<<-EOS) }
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
