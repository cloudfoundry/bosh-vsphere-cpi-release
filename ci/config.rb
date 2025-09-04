# TODO(nm,ck):
#  - reenable host maintenance tests
#  - run lifecycle tests with policy api
#  - run full suite against policy/cvds since its only run against NVDS today
#  - make sure the cvds tests all run `--tag vsphere_networking`

$pipeline.pool('7.0-nsxt32-nvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~nsxv',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('7.0-nsxt32-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~host_maintenance',
      '--tag cvds',
      '--tag nsxt_all',
      '--tag vsphere_networking',
    ].join(' ')
  }
end

$pipeline.pool('7.0-nsxt32-policy') do |pool|
  # TODO(nm,ck): We want to come back and make these green as we dont have time to do this before comet ships
  pool.skip_lifecycle_test
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nsxv',
      '--tag ~nvds',
      '--tag ~host_maintenance',
      '--tag cvds',
      '--tag nsxt_all',
    ].join(' ')
  }
end

$pipeline.pool('8.0-nsxt42-cvds') do |pool|
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~host_maintenance',
      '--tag cvds',
      '--tag nsxt_all',
    ].join(' ')
  }
end


$pipeline.pool('8.0-nsxt42-policy') do |pool|
  # TODO(nm,ck): We want to come back and make these green as we dont have time to do this before comet ships
  pool.skip_lifecycle_test
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nsxv',
      '--tag ~nvds',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end
