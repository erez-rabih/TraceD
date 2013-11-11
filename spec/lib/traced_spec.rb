require 'spec_helper'
require 'traced'

describe TraceD do

  before :all do
    TraceD::Client.set(FakeStatsdClient.new)
  end

  module DummyMethods
    def zero
      return 0
    end

    def sum(arg1, arg2, arg3)
      return arg1 + arg2 + arg3
    end
  end

  class Dummy1
    include TraceD
    include DummyMethods
  end

  class Dummy2
    include TraceD
    include DummyMethods
  end

  class Dummy3
    include TraceD
    include DummyMethods
  end

  class Dummy4
    class << self
      include TraceD
      def zero
        return 0
      end

      def sum(arg1, arg2, arg3)
        return arg1 + arg2 + arg3
      end
      statsd_trace :zero, count: true
      statsd_trace :sum, stat_name: "class_sum"
    end
  end

  describe "before tracing" do

    describe :zero do
      it "should return zero" do
        Dummy1.new.zero.should eq 0
      end
    end

    describe :sum do
      it "should return the sum" do
        Dummy1.new.sum(1,2,3).should eq 6
      end
    end

  end

  describe "traced" do

    before :all do
      Dummy1.class_eval do
        statsd_trace :zero
        statsd_trace :sum
      end
    end

    describe :zero do
      it "should return zero" do
        Dummy1.new.zero.should eq 0
      end
    end

    describe :sum do
      it "should return the sum 1" do
        Dummy1.new.sum(1,2,3).should eq 6
      end
    end

    describe "statsd reporting" do
      context "default stats name" do
        it "should generate default name for stats" do
          TraceD::Client.should_receive(:time).with("method_tracer.Dummy1.zero").once
          TraceD::Client.should_receive(:time).with("method_tracer.Dummy1.sum").once
          Dummy1.new.zero
          Dummy1.new.sum(1,2,3)
        end
      end
    end
  end

  describe "trace with stat name" do

    before :all do
      Dummy2.class_eval do
        statsd_trace :zero, stat_name: :zero_stat
        statsd_trace :sum, stat_name: :sum_stat
      end
    end

    describe :zero do
      it "should return zero" do
        Dummy2.new.zero.should eq 0
      end
    end

    describe :sum do
      it "should return the sum 1" do
        Dummy2.new.sum(1,2,3).should eq 6
      end
    end

    describe "statsd reporting" do
      context "stats name" do
        it "should report with given stat name" do
          TraceD::Client.should_receive(:time).with(:zero_stat).once
          TraceD::Client.should_receive(:time).with(:sum_stat).once
          Dummy2.new.zero
          Dummy2.new.sum(1,2,3)
        end
      end
    end
  end

  describe "trace with count" do

    before :all do
      Dummy3.class_eval do
        statsd_trace :zero, count: true
        statsd_trace :sum
      end
    end

    describe :zero do
      it "should return zero" do
        Dummy3.new.zero.should eq 0
      end
    end

    describe :sum do
      it "should return the sum 1" do
        Dummy3.new.sum(1,2,3).should eq 6
      end
    end

    describe "statsd reporting" do
      context "stats name" do
        it "should report with given stat name" do
          TraceD::Client.should_receive(:time).with("method_tracer.Dummy3.zero").once
          TraceD::Client.should_receive(:time).with("method_tracer.Dummy3.sum").once
          Dummy3.new.zero
          Dummy3.new.sum(1,2,3)
        end
      end

      context "count" do
        it "should count traced method with count" do
          TraceD::Client.should_receive(:increment).with("method_tracer.Dummy3.zero.count").once
          Dummy3.new.zero
        end

        it "should not count traced method without count" do
          TraceD::Client.should_not_receive(:increment)
          Dummy3.new.sum(1,2,3)
        end
      end
    end
  end

  describe "tracing class methods" do

    describe :zero do
      it "should return zero" do
        Dummy4.zero.should eq 0
      end
    end

    describe :sum do
      it "should return the sum 1" do
        Dummy4.sum(1,2,3).should eq 6
      end
    end

    describe "statsd reporting" do
      context "default stats name" do

        context "zero" do
          it "should report time" do
            TraceD::Client.should_receive(:time).with("method_tracer.Dummy4.zero").once
            Dummy4.zero
          end

          it "should report count" do
            TraceD::Client.should_receive(:increment).with("method_tracer.Dummy4.zero.count").once
            Dummy4.zero
          end
        end

        context "sum" do
          it "should report time" do
            TraceD::Client.should_receive(:time).with("class_sum").once
            Dummy4.sum(1,2,3)
          end

          it "should not report count" do
            TraceD::Client.should_not_receive(:increment)
            Dummy4.sum(1,2,3)
          end
        end
      end
    end
  end
end

