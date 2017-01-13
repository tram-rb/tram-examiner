require "spec_helper"

describe Tram::Examiner do
  before do
    class Test::User
      include Tram::Examiner

      attr_reader :first_name, :second_name
      def initialize(first_name, second_name)
        @first_name  = first_name
        @second_name = second_name
      end

      examiner do
        let(:name) { [first_name, second_name].compact.join(" ") }
        validates :name, presence: true
      end
    end
  end

  it "doesn't include ActiveModel::Validations into the class" do
    expect(Test::User.new("", "")).not_to be_a ActiveModel::Validations
  end

  context "#valid?" do
    it "works" do
      expect(Test::User.new("", "")).not_to be_valid
      expect(Test::User.new("Andy", "")).to be_valid
    end
  end

  context "#errors" do
    it "works" do
      expect(Test::User.new("", "").errors).not_to be_empty
      expect(Test::User.new("Andy", "").errors).to be_empty
    end
  end

  context "#validate!" do
    it "works" do
      expect { Test::User.new("", "").validate! }
        .to raise_error ActiveModel::ValidationError

      expect { Test::User.new("Andy", "").validate! }
        .not_to raise_error
    end
  end
end
