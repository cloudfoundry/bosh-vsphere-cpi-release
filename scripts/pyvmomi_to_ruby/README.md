[![Build Status](https://travis-ci.org/mmb/pyvmomi_to_ruby.svg?branch=master)](https://travis-ci.org/mmb/pyvmomi_to_ruby)

Convert [pyvmomi](https://github.com/vmware/pyvmomi) CoreTypes.py and
ServerObjects.py files to ruby versions usable by [ruby_vim_sdk](https://github.com/cloudfoundry/bosh/tree/master/bosh_vsphere_cpi/lib/ruby_vim_sdk).

Usage:

```
./gen_all.sh "version_tag"
```

Version used by current BOSH vSphere CPI:
```
./gen_all.sh "v5.5.0.2014.1.1"
```
