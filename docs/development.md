## Development

The release requires the Ruby gem Bundler (used by the vendoring script):

```
gem install bundler
```

With bundler installed, run the vendoring script:

```
cd src/vsphere_cpi
./vendor_gems
```

Then from the project root, create the BOSH release:

```
bosh create release --force
```

The release is now ready for use. If everything works, commit the changes including the updated gems.
