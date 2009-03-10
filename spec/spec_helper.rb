$: << File.dirname(__FILE__) + "/../lib"

require "dm-core"
DataMapper.setup(:default, "sqlite3::memory")

Spec::Runner.configure do |config|
  config.before(:each) do
    DataMapper.auto_migrate!
  end
end
