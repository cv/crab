require 'aruba'
require 'aruba/cucumber'

Before '@quick' do
  @aruba_io_wait_seconds = 1
end

Before '~@quick' do
  @aruba_io_wait_seconds = 5
end
