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
