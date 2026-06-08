# Each pool declares:
#   testbed_group  — the serial group shared with other pools on the same vCenter.
#                    At most one job per testbed_group runs at a time, capping
#                    the total number of simultaneous Shepherd allocations per
#                    vCenter generation.  Set to the appropriate testbed-slot-vcX
#                    value below.

# ── vSphere 7.0 ──────────────────────────────────────────────────────────────

$pipeline.pool('7.0-nsxt32-nvds') do |pool|
  pool.testbed_group = 'testbed-slot-vc7'
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~cvds',
      '--tag ~nsxt_pure_policy',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('7.0-nsxt32-cvds') do |pool|
  pool.testbed_group = 'testbed-slot-vc7'
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~nsxt_pure_policy',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('7.0-nsxt32-policy') do |pool|
  pool.testbed_group = 'testbed-slot-vc7'
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

# ── vSphere 8.0 ──────────────────────────────────────────────────────────────

$pipeline.pool('8.0-nsxt42-cvds') do |pool|
  pool.testbed_group = 'testbed-slot-vc8'
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~nsxt_pure_policy',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

$pipeline.pool('8.0-nsxt42-policy') do |pool|
  pool.testbed_group = 'testbed-slot-vc8'
  pool.params = {
    RSPEC_FLAGS: [
      '--tag ~nvds',
      '--tag ~host_maintenance',
    ].join(' ')
  }
end

# ── vSphere 9.0 ──────────────────────────────────────────────────────────────

$pipeline.pool('9.0-nsxt90-policy') do |pool|
  pool.testbed_group = 'testbed-slot-vc9'
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

$pipeline.pool('9.0-nsxt90-policy-maintenance') do |pool|
  pool.shepherd_pool = '9.0-nsxt90-policy'
  pool.testbed_group = 'testbed-slot-vc9'
  pool.params = {
    RSPEC_FLAGS: [
      '--tag host_maintenance',
    ].join(' '),
  }
end
