require 'fluent/filter'

module Fluent
  class  DeirdreTestFilter < Filter
    Fluent::Plugin.register_filter('deirdre_test_filter', self)

    def configure(conf)
      super
    end

    def start
      super
    end

#filter_stream method from fluentd writing plugins page
#     def filter_stream(tag, es)
#       new_es = MultiEventStream.new
#       es.each { |time, record|
#         begin
#          filtered_record = filter(tag, time, record)
#        new_es.add(time, filtered_record) if filtered_record
#      rescue => e
#         router.emit_error_event(tag, time, record, e)
#      end
#       }
#   new_es
# end

    def get_log_path(arr)
      arr.each do |f|
       if !f.match /.log\z/
        return f
       end
      end
    end


    def filter_stream(tag, es)
      new_es =  MultiEventStream.new
      files = Dir.entries("/var/log/containers/")
      filepath = get_log_path(files)
      log_file = Dir.entries("/var/log/containers/#{filepath}")

      es.each {|time, record|
        record['uniquestring'] = {
          'name' => 'hatch this animal',
          'files' => files,
          'path' => filepath,
          'log-file' => log_file
        }
        new_es.add(time, record)
      }

      return new_es
    end


  end
end
