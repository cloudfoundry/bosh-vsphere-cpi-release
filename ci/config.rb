# TODO(nm,ck):
#  - reenable host maintenance tests

$pipeline.pool('7.0-nsxt32-nvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('7.0-nsxt32-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
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
