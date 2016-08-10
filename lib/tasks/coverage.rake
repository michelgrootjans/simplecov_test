
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
            files.delete_if{|file_path, line_hits| line_hits.all?{|l| l == 0}}
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
      command_name 'merged'
      load_profile 'rails'
      track_files '{app,lib,vendor}/**/*.rb'
    end

    merged_result = SimpleCov.result
    merged_result = SimpleCov.add_not_loaded_files(merged_result.original_result)
    SimpleCov::Result.new(merged_result).format!

    covered_percent = SimpleCov.result.covered_percent.round(2)
    SimpleCov::LastRun.write(:result => {:covered_percent => covered_percent})
  end
end
