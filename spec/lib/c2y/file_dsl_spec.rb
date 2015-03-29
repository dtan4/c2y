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

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.files.first
        end

        its(:path) { is_expected.to eq "/etc/ssh/sshd_config" }
        its(:permissions){ is_expected.to eq "0600" }
        its(:owner){ is_expected.to eq "root:root" }
        its(:content) { is_expected.to eq(<<-EOS) }
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
