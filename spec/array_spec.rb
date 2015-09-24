require 'spec_helper'
RSpec.describe Array do
  it "value reject" do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a

      x.report('reject') {
        ary10k.reject { |i| i <= 5000 }
      }
      x.report('reject!') {
        ary10k.reject! { |i| i <= 5000  }
      }
      x.report('delete_if') {
        ary10k.delete_if { |i| i <= 5000 }
      }
      x.compare!
    end
  end

  it "blacklist removal" do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a
      ary5k = (-5_000..5_000).to_a

      x.report('reject include') {
        ary10k.reject { |i| ary5k.include? i }
      }
      x.report('reject! include') {
        ary10k.reject! { |i| ary5k.include? i }
      }
      x.report('delete_if include') {
        ary10k.delete_if { |i| ary5k.include? i }
      }
      x.report('-=') {
        ary10k -= ary5k
      }
      x.compare!
    end
  end

  it 'flatten and unique' do
    Benchmark.ips do |x|
      ary5k1k = (1..5_000).map { |a| (1..10_000).to_a.sample(1000) }

      x.report('flatten.uniq') {
        #because we do an inline in others, have to dup first
        ary5k1k.dup.flatten.uniq
      }
      x.report('flatten!;uniq!') {
        a = ary5k1k.dup
        a.flatten!
        a.uniq!
      }
      x.report('union') {
        ary5k1k.dup.reduce(:|)
      }

      x.compare!
    end
  end

  it 'unique' do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a

      x.report('to_s.to_a') {
        ary10k.to_set.to_a
      }
      x.report('uniq') {
        ary10k.uniq
      }
      x.report('uniq!') {
        ary10k.uniq!
      }
      x.compare!
    end
  end
end
