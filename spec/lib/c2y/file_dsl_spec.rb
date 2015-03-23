require "spec_helper"

module C2y
  describe DSL do
    describe "file" do
      context "with options" do
        let(:cloudconfigfile) do
          CloudConfigFile.create do
          <<-EOS
file "/etc/ssh/sshd_config" do
  permissions "0600"
  owner "root:root"
  content <<-CONTENT
# Use most defaults for sshd configuration.
UsePrivilegeSeparation sandbox
Subsystem sftp internal-sftp

PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
  CONTENT
end
          EOS
          end
        end

        it do
          dsl = described_class.parse(cloudconfigfile)
          expect(dsl.files.length).to eq 1
          file  = dsl.files.first
          expect(file.path).to eq "/etc/ssh/sshd_config"
          expect(file.permissions).to eq "0600"
          expect(file.owner).to eq "root:root"
          expect(file.content).to eq(<<-EOS)
# Use most defaults for sshd configuration.
UsePrivilegeSeparation sandbox
Subsystem sftp internal-sftp

PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
          EOS
        end
      end
    end
  end
end
