desc "Lint with ERB Lint"
task :erb_lint do
  require "erb_lint/cli"
  ERBLint::CLI.new.run(["--lint-all"])
end

desc "Lint and automatically fix with ERB Lint"
task :"erb_lint:fix" do
  require "erb_lint/cli"
  ERBLint::CLI.new.run(["--lint-all", "-a"])
end
