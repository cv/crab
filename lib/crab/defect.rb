class Crab::Defect

  def initialize(rally_defect)
    @rally_defect = rally_defect
  end

  def formatted_id
    @rally_defect.formatted_i_d
  end

  def name
    @rally_defect.name
  end

  def description
    @rally_defect.description
  end

  def environment
    @rally_defect.environment
  end

  def browser
    @rally_defect.navegador
  end

  def statte
    @rally_defect.schedule_state
  end

  def severity
    @rally_defect.severity
  end

  def target_date
    @rally_defect.target_date
  end

  def task_status
    @rally_defect.task_status
  end

  def test_case_status
    @rally_defect.test_case_status
  end

  def delete
    @rally_defect.delete
  end

end
