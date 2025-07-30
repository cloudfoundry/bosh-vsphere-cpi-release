$pipeline.pool('7.0-nsxt30') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~nsxv',
      '--tag ~host_maintenance',
    ].join(' '),
  }
end

$pipeline.pool('7.0-nsxt31') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~nsxv',
      '--tag ~host_maintenance',
    ].join(' '),
  }
end

$pipeline.pool('7.0-nsxt31-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag vsphere_networking',
    ].join(' '),
  }
end

$pipeline.pool('7.0-nsxt31-policy') do |pool|
  pool.skip_lifecycle_test
end

$pipeline.pool('8.0-nsxt40-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag ~host_maintenance',
    ].join(' '),
  }
end

$pipeline.pool('8.0-nsxt41-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag ~host_maintenance',
    ].join(' '),
  }
end

$pipeline.pool('8.pre-release-nsxt41-cvds') do |pool|
  pool.gating = false
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag ~host_maintenance',
    ].join(' '),
  }
end