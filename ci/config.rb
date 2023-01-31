$pipeline.pool('6.5-nsxt25') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~disk_migration',
      '--tag ~nsxv',
      '--tag ~host_maintenance',
      '--tag ~nsxt_policy',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.7-nsxt25') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~nsxv',
      '--tag ~host_maintenance',
      '--tag ~nsxt_policy',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

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
    NSXT_SKIP_SSL_VERIFY: "true",
  }
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