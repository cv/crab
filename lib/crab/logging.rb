module Crab::Logging

  def logger
    $logger ||= Logger.new(STDERR)
    $logger.formatter = Logger::Formatter.new
    $logger.progname = 'crab'
    # TODO - make this a global command-line or config option: $logger.level = Logger::WARN
    $logger
  end

end
