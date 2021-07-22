# frozen_string_literal: true

# OpenTelemetry is an open source observability framework, providing a
# general-purpose API, SDK, and related tools required for the instrumentation
# of cloud-native software, frameworks, and libraries.
#
# The OpenTelemetry module provides global accessors for telemetry objects.
# See the documentation for the `opentelemetry-api` gem for details.
module OpenTelemetry
  # Instrumentation should be able to handle the case when the library is not installed on a user's system.
  module Instrumentation
  end
end

require_relative './instrumentation/trace_point_app'
