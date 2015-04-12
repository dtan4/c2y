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

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.update
        end

        its(:group) { is_expected.to eq "alpha" }
        its(:reboot_strategy) { is_expected.to eq "off" }
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

        subject do
          dsl = described_class.parse(cloudconfigfile)
          dsl.update
        end

        its(:group) { is_expected.to eq :beta }
        its(:reboot_strategy) { is_expected.to eq "best-effort" }
      end
    end
  end
end
