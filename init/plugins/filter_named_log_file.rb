require 'fluent/filter'

module Fluent
  class  NamedLogFileFilter < Filter
    Fluent::Plugin.register_filter('named_log_file_filter', self)

    def configure(conf)
      super
    end

    def start
      super
    end

    def filter_stream(tag, es)
      new_es =  MultiEventStream.new

      tag_path = tag.gsub /[^\.]+.var.log.containers./, ''
      /(?<folder>[^_]+_[^_]+_\d+\.\d+\.\d+\.\d+_unknown_unknown)\.(?<filename>.+)/ =~ tag_path
      filepath = "/#{folder}/#{filename}"

      es.each {|time, record|
        record['named_logfile'] = {
          'filepath' => filepath,
          'filename' => filename
        }
        new_es.add(time, record)
      }

      return new_es
    end


  end
end