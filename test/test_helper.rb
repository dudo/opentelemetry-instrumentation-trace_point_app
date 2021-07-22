# frozen_string_literal: true

require 'opentelemetry-instrumentation-trace_point_app'
require 'opentelemetry/sdk'

require 'minitest/autorun'
require 'webmock/minitest'
require 'pry'

# Global opentelemetry-sdk setup:
EXPORTER = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new
span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(EXPORTER)

OpenTelemetry::SDK.configure do |c|
  c.use 'OpenTelemetry::Instrumentation::TracePointApp'
  c.add_span_processor span_processor
end
