require 'highline/import'

module Crab
  class Login
    def initialize(global_opts, cmd_opts)
    end

    def run
      ask "Username: "
      ask "Password: "
    end
  end
end
