class Crab::Commands::Version
  class << self
    def run(args=ARGV)
      puts "crab version #{Crab::VERSION}"
    end
  end
end
