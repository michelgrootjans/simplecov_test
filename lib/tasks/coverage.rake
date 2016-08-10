
namespace :coverage do
  task :merge => :environment do

    require 'simplecov'

    puts ' ** Multiple SimpleCov coverage merge running'

    module SimpleCov
      class << self
        def add_not_loaded_files(result)
          if track_files
            result = result.dup
            Dir[track_files].each do |file|
              absolute = File.expand_path(file)

              result[absolute] ||= [0] * File.foreach(absolute).count
            end
          end

          result
        end

      end
    end


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
            resultset_hashes.reduce({}, :merge)
          end
        end
      end
    end

    SimpleCov.coverage_dir 'coverage/merge'
    SimpleCov.track_files "{app,lib}/**/*.rb"
    merged_result = SimpleCov.result
    merged_result = SimpleCov.add_not_loaded_files(merged_result.original_result)
    # binding.pry
    SimpleCov::Result.new(merged_result).format!

  end
end
