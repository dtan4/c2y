require "spec_helper"

module C2y
  describe DSL do
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

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.users.first
        end

        its(:name) { is_expected.to eq "dtan4" }
        its(:github) { is_expected.to eq "dtan4" }
        its(:groups) { is_expected.to eql(%w(sudo docker)) }
      end
    end
  end
end
