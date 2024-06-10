The contents of this directory intend to be a fully-functional "plugin"
for the BOSH vSphere CPI.

A "plugin" for the vSphere CPI is a BOSH Release that follows a few
conventions. A Release for a plugin named 'example' would have the
following properties:

* It contains an 'example' Job whose spec accepts a
`plugins.example` configuration key. (The value of that key is
totally up to the plugin code, it is not verified by either the
Director or the CPI.)

* It contains a file named `src/example/lib/example.rb` thta
defines a class in the `VSphereCloud::CpiPlugin` module, is named
`Example`, and derives from `VSphereCloud::CpiPlugin::PluginBase`.
This `Example` class overrides the relevant pre- or post- hook
methods defined in `PluginBase` (for example: `create_vm_post` or
`has_vm_pre`) required to get the desired functionality.

These pre- or post- hook methods receive a
`VSphereCloud::CpiPlugin::PluginCallContext` instance that contains the
`self` of the CPI that is calling the hook method, a mechanism to
determine if the plugin being called is actually active, and -depending
on the hook function called- access to a few helper methods that let you
pull items out of the call-specific Hash structure passed in.

NOTE: Only the 'create_vm_post' and 'delete_vm_post' hook sites pass any
      particularly useful information through to the plugin. We're very
      open to enhancements or changes to the data passed in to hook sites,
      or the hook sites themselves,  so if you don't get what you need
      passed through a hook site, or want to change the location of or
      add another hook site, please submit a PR and/or start a discussion.

Required Director manifest changes to support Plugin deployment and
configuration are as follows:

Fundamental plugin configuration properties (like hostname and
credentials for contacting a configuration appliance) are specified in
a `plugins.$PLUGIN_NAME` key in three or four places:

1) Under the `properties` key of the plugin Job added to the Director's
Instance Group
2) Under the `properties` key of the Director's Instance Group
3) Under the top-level `cloud_provider` key
4) Under the `properties` key for the CPI Config, if you have one.

Per-Instance plugin configuration is specified in a
`plugins.$PLUGIN_NAME` key in the `cloud_properties` for that instance.
For the Director, this might be in the `resource_pool` for the Director.
For Director-deployed VMs, this might be delivered via a VM Extension
applied to the relevant Instances.

The Release containing the plugin is added to a list containing the CPI
Release and any other plugins under the `cloud_provider.templates` key.
This key is new and replaces the `cloud_provider.template` key. If both
are present, the contents of the `template` key will be ignored.

For the this 'example' plugin, these changes would look
something like this:
```
resource_pools:
- name: director_resource_pool
  cloud_properites:
    plugins:
      example:
        turbo_mode: enabled
instance_groups:
- name: bosh
  jobs:
  - name: example
    release: example
    properties:
      plugins:
        example:
          host: appliance-host.example.com
          username: username
          password: password
  properties:
    plugins:
      example:
        host: appliance-host.example.com
        username: username
        password: password
cloud_provider:
  properties:
    plugins:
      example:
        host: appliance-host.example.com
        username: username
        password: password
  templates:
  - name: vsphere_cpi
    release: bosh-vsphere-cpi
  - name: example
    release: example
```

Note `templates` key support will require a version of the BOSH CLI that
has the change in <https://github.com/cloudfoundry/bosh-cli/pull/662>
included in it. At the time of this writing, there has not yet been a
BOSH CLI released with this change.