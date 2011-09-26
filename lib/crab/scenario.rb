module Crab

  class Scenario

    def initialize(rally_test_case)
      @rally_test_case = rally_test_case
    end

    def formatted_id
      @rally_test_case.formatted_i_d
    end

    def name
      @rally_test_case.name
    end

    def steps
      Array(@rally_test_case.steps).map {|step| step.input }
    end

  end

end
