$pipeline.pool('7.0-nsxt32-nvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~nsxv',
      '--tag ~host_maintenance',
    ].join(' '),
  }
end

$pipeline.pool('7.0-nsxt32-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag vsphere_networking',
    ].join(' '),
  }
end

$pipeline.pool('7.0-nsxt32-policy') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nsxv',
      '--tag ~nvds',
      '--tag cvds',
      '--tag nsxt_all',
    ].join(' '),
  }
end

$pipeline.pool('8.0-nsxt42-policy') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nsxv',
      '--tag ~nvds',
    ].join(' '),
  }
end
