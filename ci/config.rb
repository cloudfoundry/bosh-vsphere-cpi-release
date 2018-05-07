$pipeline.pool('5.5') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~log_creds',
      '--tag ~nsx_transformers',
      '--tag ~nsx_vsphere',
      '--tag ~replicate_stemcell_two_threads',
      '--tag ~vsan_datastore',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.0') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nsx_vsphere',
      '--tag ~nsxt_2',
      '--tag ~nsxt_21',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.0-NSXV') do |pool|
  pool.params = {
    RSPEC_FLAGS: '--tag nsx_vsphere',
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.5') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~disk_migration',
      '--tag ~nsx_vsphere',
      '--tag ~nsxt_21'
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.5-NSXV') do |pool|
  pool.params = {
    RSPEC_FLAGS: '--tag nsx_vsphere',
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.5-NSXT21') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~disk_migration',
      '--tag ~nsx_vsphere',
      '--tag ~host_maintenance',
    ].join(' '),
    NSXT_SKIP_SSL_VERIFY: "true"
  }
end

$pipeline.pool('6.7') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~disk_migration',
      '--tag ~nsx_transformers',
      '--tag ~nsx_vsphere',
    ].join(' ')
  }
end
