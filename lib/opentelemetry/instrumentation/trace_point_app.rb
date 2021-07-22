# frozen_string_literal: true

require 'opentelemetry'
require 'opentelemetry-instrumentation-base'

module OpenTelemetry
  module Instrumentation
    # Contains the OpenTelemetry instrumentation for the TracePointApp gem
    module TracePointApp
    end
  end
end

require_relative './trace_point_app/instrumentation'
require_relative './trace_point_app/version'
