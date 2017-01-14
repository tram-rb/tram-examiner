module Tram
  # Adds standalone validator to the instances of current class
  module Examiner
    require_relative "examiner/results"

    # Adds class method helper to define validation rules
    module DSL
      def examiner(&block)
        @examiner ||= Class.new(Results).tap { |exam| exam.subject(self) }
        @examiner.tap { |klass| klass.instance_eval(&block) if block }
      end

      def inherited(klass)
p self
p examiner
p klass
        new_examiner = Class.new(examiner).tap { |exam| exam.subject(klass) }
        klass.instance_variable_set :@examiner, new_examiner
      end
    end

    def self.included(klass)
      klass.extend DSL
    end

    def validate!
      (@__examiner__ = self.class.examiner.new(self)).validate!
    end

    def valid?
      (@__examiner__ = self.class.examiner.new(self)).valid?
    end

    def errors
      (@__examiner__ ||= self.class.examiner.new(self).tap(&:valid?)).errors
    end
  end
end
