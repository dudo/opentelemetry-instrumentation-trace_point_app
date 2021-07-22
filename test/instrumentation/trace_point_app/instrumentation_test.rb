# frozen_string_literal: true

require 'test_helper'

describe OpenTelemetry::Instrumentation::TracePointApp do
  let(:instrumentation) { OpenTelemetry::Instrumentation::TracePointApp::Instrumentation.instance }

  it 'has #name' do
    _(instrumentation.name).must_equal 'OpenTelemetry::Instrumentation::TracePointApp'
  end

  it 'has #version' do
    _(instrumentation.version).wont_be_nil
    _(instrumentation.version).wont_be_empty
  end

  describe '#install' do
    it 'accepts argument' do
      _(instrumentation.install({})).must_equal(true)
      instrumentation.instance_variable_set(:@installed, false)
    end
  end
end
