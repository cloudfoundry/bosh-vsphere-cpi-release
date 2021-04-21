$pipeline.pool('6.0-nsxv') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~cvds',
      '--tag ~spbm_encryption',
      '--tag ~attach_tag',
      '--tag ~host_maintenance',
      '--tag ~nsxt_all',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

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

$pipeline.pool('6.5-nsxt24') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag nvds',
      '--tag nsxt_all',
      '--tag vsphere_networking',
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

$pipeline.pool('6.7-nsxt24') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag nvds',
      '--tag nsxt_all',
      '--tag vsphere_networking',
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

$pipeline.pool('7.0-nsxt30-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag vsphere_networking',
      '--tag ~nsxt_policy',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true",
  }
end
