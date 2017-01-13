require "active_model"
require "dry-memoizer"

module Tram::Examiner
  # Container for standalone validation of PORO instance
  class Results < SimpleDelegator
    extend  Dry::Memoizer # adds `let` syntax
    include ActiveModel::Validations

    class << self
      def subject(value = nil)
        (value ? @subject = value : @subject)
      end

      def model_name
        @model_name ||= ActiveModel::Name.new(subject || Tram::Examiner)
      end

      def inspect
        "Tram::Examiner::Results[#{model_name}]"
      end
    end

    def inspect
      "#<Tram::Examiner::Results[#{model_name}] @errors=#{errors}>"
    end

    private

    def initialize(subject)
      return super if subject.is_a?(self.class.subject)
      raise "#{self.class.inspect} was designed as a standalone validator" \
            " for instances of #{self.class.subject}, not the #{subject.class}."
    end
  end
end
