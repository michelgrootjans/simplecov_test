namespace :coverage do
  task :merge => :environment do

    require 'simplecov'

    puts ' ** Multiple SimpleCov coverage merge running'

    module SimpleCov
      module ResultMerger
        class << self
          def resultset_files
            Dir.glob(File.join('coverage', '*', '.resultset.json'))
          end

          def resultset_hashes
            resultset_files.map do |path|
              begin
                puts " ** -> Parsing: #{path}"
                json = JSON.parse(File.read(path))
                remove_empty_files(json)
              rescue
                puts " ** -> Failed to parse #{path}"
                {}
              end
            end
          end

          def remove_empty_files(json)
            files = json.values.first.values.first
            files.delete_if{|_, line_hits| line_hits.all?{|l| l == 0}}
            json
          end

          def resultset
            @resultset ||= resultset_hashes.reduce({}, :merge)
          end
        end
      end
    end

    SimpleCov.configure do
      merge_timeout 7200
      coverage_dir ENV['COVERAGE_DIR'] || 'coverage/merge'
      load_profile 'rails'
      track_files '{app,lib,vendor}/**/*.rb'
    end

    original_result = SimpleCov.result.original_result
    result_with_untouched_files = SimpleCov.add_not_loaded_files(original_result)
    end_result = SimpleCov::Result.new(result_with_untouched_files)
    end_result.command_name = SimpleCov.result.command_name
    end_result.format!

    covered_percent = end_result.covered_percent.round(2)
    SimpleCov::LastRun.write(:result => {:covered_percent => covered_percent})

    File.open(File.join(SimpleCov.coverage_path, ".resultset.json"), "w+") do |f_|
      f_.puts JSON.pretty_generate(end_result.to_hash)
    end
  end
end
