if Gem.available?('rcov')
  require 'rcov'
  require 'rcov/rcovtask'

  # Rake task to run rcov against all tests defined.
  # Browsable (html) results will be written to test/coverage/.
  # NOTE: the aggregate function keeps a running total of coverage, so the last suite of 
  #       tests run will be the report to look at (in this instance, test/coverate/integration)
  namespace :test do 
    namespace :coverage do
      desc "Delete aggregate coverage data."
      task(:clean) { rm_f "coverage.data" }
    end
    desc 'Aggregate code coverage for unit, functional and integration tests'
    task :coverage => "test:coverage:clean"
    %w[unit functional integration].each do |target|
      namespace :coverage do
        Rcov::RcovTask.new(target) do |t|
          t.libs << "test"
          t.test_files = FileList["test/#{target}/**/*_test.rb"]
          t.output_dir = "test/coverage/#{target}"
          t.verbose = true
          t.rcov_opts << '--rails --aggregate coverage.data --exclude /rvm/,/gems/,/Library/,/usr/,spec,lib/tasks'
        end
      end
      task :coverage => "test:coverage:#{target}"
    end
  end
end
