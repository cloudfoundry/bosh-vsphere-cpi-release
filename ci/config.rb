$pipeline.pool('7.0-nsxt32-nvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~nsxt_pure_policy',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('7.0-nsxt32-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~nsxt_pure_policy',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('7.0-nsxt32-policy') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('8.0-nsxt42-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~nsxt_pure_policy',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('8.0-nsxt42-policy') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('9.0-nsxt90-policy') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~host_maintenance',
      '--tag ~nsxt_management',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag nsxt_pure_policy',
    ].join(' '),
  }
end

$pipeline.pool('7.0-nsxt32-nvds-maintenance') do |pool|
  pool.shepherd_pool = '7.0-nsxt32-nvds'
  pool.params = {
    RSPEC_FLAGS: [
      '--tag host_maintenance',
    ].join(' '),
  }
end
