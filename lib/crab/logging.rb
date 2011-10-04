module Crab::Logging

  def logger
    $logger ||= Logger.new(STDERR)
    $logger.formatter = Logger::Formatter.new
    $logger.progname = 'crab'
    # TODO - make this a global command-line or config option:
    $logger.level = ENV['CRAB_LOG_LEVEL'].present? ? ENV['CRAB_LOG_LEVEL'].to_i : Logger::WARN
    $logger
  end

end
