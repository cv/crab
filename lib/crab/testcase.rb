module Crab

  class TestCase

    include Crab::Utilities

    PRIORITIES = %w{useful important critical}
    RISKS = %w{low medium high}
    METHODS = %w{automated manual}
    TYPES = %w{acceptance functional non-functional performance regression usability}

    def initialize(rally_test_case, dry_run)
      @rally_test_case = rally_test_case
      @dry_run
    end

    def formatted_id
      @rally_test_case.formatted_i_d
    end

    def name
      @rally_test_case.name
    end

    def description
      # this could use a lot of rethinking :(
      # biggest problem is that Cucumber breaks if text in description looks like something
      # it might know how to parse, but doesn't
      # our feature descriptions are quite like that, so I was being ultra-conservative
      sanitize(@rally_test_case.description || '').gsub(/  +/, "\n").gsub(/\n\n/, "\n").gsub(/\n/, "\n  ")
    end

    def tags
      [priority, risk, test_method, test_type].map(&:parameterize).reject do |tag|
        %w{important medium manual acceptance}.include? tag
      end
    end

    def revision
      rev = @rally_test_case.revision_history.revisions.first
      "#{rev.revision_number}, by #{rev.user}"
    end

    def priority
      @rally_test_case.priority
    end

    def risk
      @rally_test_case.risk
    end

    def test_method
      @rally_test_case.elements[:method]
    end

    def test_type
      @rally_test_case.elements[:type]
    end

    def story
      Crab::Story.new(@rally_test_case.work_product, @dry_run)
    end

    def delete
      if @dry_run
        puts "Would delete test case #{formatted_id}"
      else
        @rally_test_case.delete
      end
    end

    def update(options)
      if @dry_run
        puts "Would update test case #{formatted_id} with #{options.inspect}"
      else
        @rally_test_case.update options
      end
    end

    def steps
      Array(@rally_test_case.steps).map {|step| step.input }
    end

  end
end
