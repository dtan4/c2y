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
          dsl = DSL.define(cloudconfigfile)
          update = dsl.result.update.result
          expect(update).not_to be nil
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
          dsl = DSL.define(cloudconfigfile)
          update = dsl.result.update.result
          expect(update).not_to be nil
          expect(update.group).to eq "beta"
          expect(update.reboot_strategy).to eq "best-effort"
        end
      end
    end
  end
end
