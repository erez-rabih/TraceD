require "traced/version"
require 'traced/client'

module TraceD

  def self.included clazz
    clazz.extend ClassMethods
  end

  module InstanceMethods

    def traced_method_name(method)
      "_statsd_traced_#{method}"
    end

    def default_time_stat_name(method)
      my_name = self.class.name == "Class" ? self.name : self.class.name
      "method_tracer.#{my_name}.#{method}"
    end

    def default_count_stat_name(stat_name)
      "#{stat_name}.count"
    end
  end

  module ClassMethods
    def statsd_trace(method, opts = {})

      old_method_name = traced_method_name(method)
      alias_method old_method_name, method

      define_method method do |*args|

        opts[:stat_name] ||= default_time_stat_name(method)
        opts[:count_stat_name] = default_count_stat_name(opts[:stat_name])

        ::TraceD::Client.increment(opts[:count_stat_name]) if opts[:count]
        ::TraceD::Client.time(opts[:stat_name]) do
          self.send(old_method_name, *args)
        end
      end

    end

    include ::TraceD::InstanceMethods
  end

  include InstanceMethods

end
