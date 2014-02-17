require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
  end
  c.path = "/sbin:/user/sbin"
end

describe command("wp --info --allow-root") do
  it { should return_exit_status 0 }
end

describe command("wget -q http://localhost/ -O - | head -100 | grep generator") do
    it { should return_stdout /wordpress/i }
end

