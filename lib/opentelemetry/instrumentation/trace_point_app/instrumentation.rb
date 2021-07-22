# frozen_string_literal: true

module OpenTelemetry
  module Instrumentation
    module TracePointApp
      # The Instrumentation class contains logic to detect and install the TracePointApp instrumentation
      # https://ruby-doc.org/core-2.7.0/TracePoint.html
      class Instrumentation < OpenTelemetry::Instrumentation::Base
        KEEP_GEMS = Bundler.load.require(:default) \
                            .reject { |dep| (dep.groups & %i[test development]).any? } \
                            .map(&:name) \
                            .join('|')
        CALLER_APP_REGEX = /(.+\/app.+):in/

        install do |_config|
          require_dependencies
          trace_point.enable
        end

        present do
          defined?(::TracePoint)
        end

        private

        def trace_point
          TracePoint.new(:call, :return, :raise) do |tp|
            case tp.path
            when /.+(\/app.+)/
              type, service, version = :method, 'app', '1a42d39'
            when /\/gems\/(#{KEEP_GEMS})-([0-9.]+)\//
              next unless caller[1][CALLER_APP_REGEX, 1]

              type, service, version = :import, $1, $2
            else
              next
            end

            name = "#{tp.self.is_a?(Module) ? "#{tp.self}." : "#{tp.defined_class}#"}#{tp.method_id}"

            case tp.event
            when :call
              span = tracer.start_span(name, with_parent: OpenTelemetry::Trace.context_with_span(OpenTelemetry::Trace.current_span))
              span.add_attributes(
                'type' => type.to_s,
                'service' => service.to_s,
                'version' => version.to_s,
                'location' => "#{tp.path}:#{tp.lineno}"
              )
            when :return
              OpenTelemetry::Trace.current_span&.finish
            when :raise
              span = OpenTelemetry::Trace.current_span
              span&.record_exception(tp.raised_exception)
              span&.status = OpenTelemetry::Trace::Status.error(tp.raised_exception.class)
              tp.self.method(tp.method_id).parameters.map(&:last).map do |n|
                v = tp.binding.eval(n.to_s) || 'nil'
                span&.set_attribute("arguments.#{n}", v)
              rescue StandardError
                span&.set_attribute("arguments.#{n}", 'error')
              end
            end
          end
        end

        def require_dependencies
          require 'securerandom'
        end
      end
    end
  end
end
