$pipeline.pool('6.0-NSXV') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~spbm_encryption',
      '--tag ~attach_tag',
      '--tag ~host_maintenance',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.5-NSXT25') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~disk_migration',
      '--tag ~nsxv',
      '--tag ~host_maintenance',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.5-NSXT24') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag nvds',
  ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.7-NSXT25') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nsxv',
      '--tag ~host_maintenance',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.7-NSXT24') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag nvds'
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('7.0-NSXT30') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nsxv',
      '--tag ~host_maintenance',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true",
  }
end

$pipeline.pool('7.0-NSXT30-CVDS') do |pool|
  pool.params = {
      RSPEC_FLAGS: [
        '--tag ~nvds'
      ].join(' '),
      NSXT_SKIP_SSL_VERIFY: "true",
  }
end