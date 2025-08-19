# NSXT Certificate Authentication Tests

This document explains how to run the NSXT certificate authentication tests with different API modes.

## Overview

The NSXT certificate authentication tests support both Manager Mode APIs (older NSXT versions) and Policy Mode APIs (newer NSXT versions). The tests automatically detect which mode to use based on the RSpec tag configuration.

## Running Tests

### For Backward Compatibility (Manager Mode APIs)

To run tests using Manager Mode APIs (compatible with older NSXT versions):

```bash
rspec --tag skip_nsxt_9
```

This will:
- Run all tests including logical router tests
- Use Manager Mode APIs (`/nsxapi/api/v1/logical-routers`)
- Provide full test coverage for certificate authentication

### For Newer NSXT Versions (Policy Mode APIs)

To run tests using Policy Mode APIs (for NSXT 9+):

```bash
rspec --tag ~skip_nsxt_9
```

This will:
- Skip logical router tests (not available in Policy Mode)
- Use Policy Mode APIs where available
- Focus on certificate authentication with available APIs
- Provide appropriate test coverage for newer NSXT versions

### Default Behavior

If no tags are specified:

```bash
rspec
```

This defaults to Manager Mode APIs for backward compatibility.

## Test Structure

The tests are organized with conditional logic:

1. **Manager Mode Tests** (`skip_nsxt_9: true`):
   - Test logical router operations
   - Test x_allow_overwrite functionality
   - Full API coverage

2. **Policy Mode Tests** (`skip_nsxt_9: false`):
   - Test certificate authentication
   - Test available policy APIs
   - Skip unavailable Manager Mode APIs

3. **Conditional Logic**:
   - `use_policy_mode?` helper method
   - `create_router_api` helper method
   - Automatic test skipping based on mode

## Troubleshooting

### Manager Mode API Errors

If you see errors like:
```
The requested URI: /nsxapi/api/v1/logical-routers could not be found.
```

This indicates you're running against a newer NSXT version that doesn't support Manager Mode APIs. Use:

```bash
rspec --tag ~skip_nsxt_9
```

### Policy Mode Limitations

In Policy Mode, some tests are skipped because:
- Logical routers are not available via the same API endpoints
- Different authentication mechanisms may be required
- API structure differs significantly

## Configuration

The tests automatically detect the API mode using:

```ruby
def use_policy_mode?
  RSpec.configuration.filter_manager.exclusions[:skip_nsxt_9] == true
end
```

This means:
- `--tag skip_nsxt_9` → Manager Mode (skip_nsxt_9 is included)
- `--tag ~skip_nsxt_9` → Policy Mode (skip_nsxt_9 is excluded)
- No tags → Manager Mode (default for backward compatibility)

## Examples

### Running Specific Test Contexts

```bash
# Run only Manager Mode tests
rspec --tag skip_nsxt_9

# Run only Policy Mode tests  
rspec --tag ~skip_nsxt_9

# Run all tests (defaults to Manager Mode)
rspec
```

### Debugging

The tests include informational output to help understand which mode is active:

```
INFO: Running NSXT Certificate Authentication tests in Policy Mode (--tag ~skip_nsxt_9)
INFO: Logical router tests will be skipped as they are not available in Policy Mode
```

## Migration Notes

When migrating from Manager Mode to Policy Mode:

1. Update your test commands to use `--tag ~skip_nsxt_9`
2. Be aware that logical router tests will be skipped
3. Verify that certificate authentication still works with available APIs
4. Consider implementing equivalent functionality using Policy Mode APIs if needed
