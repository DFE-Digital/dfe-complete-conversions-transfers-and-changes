desc "Lint with ERB Lint"
task :erblint do
  require "erb_lint/cli"
  ERBLint::CLI.new.run(["--lint-all"])
end

desc "Lint and automatically fix with ERB Lint"
task :"erblint:fix" do
  require "erb_lint/cli"
  ERBLint::CLI.new.run(["--lint-all", "-a"])
end
