# Packer Chaining Example

This is just an example of how one might chain together builds using Packer. The main reason you might want to do this is to have Packer builds available at various stages throughout the build process. Another reason is that you might want to break out the build and not have to completely rebuild the base image if certain provisioning scripts have potential to fail. We are using Ubuntu 18.04 as our example here, so feel free to adapt to your scenario.

## Customizing Build Script

Feel free to adapt the [script](packer_build.sh) to your scenario. If you already have artifacts that exist (build directories) and would like to force overwriting them, change `FORCE_OVERWRITE=false` to `FORCE_OVERWRITE=true` and when you kick off the build script, any existing artifacts will be overwritten. If you do not change `FORCE_OVERWRITE` and existing artifacts exist, the build script will just throw errors whenever an artifact is found. So, if you would like to leverage an existing base image, but not want to `FORCE_OVERWRITE`, you can delete the chained build artifacts, while keeping the base image artifact, and the chained builds will process without touching the base image.

## Execution

To use the example as is, simply execute the following:

```bash
./packer_build.sh
```

## License

MIT

## Author Information

Larry Smith Jr.

- [@mrlesmithjr](https://www.twitter.com/mrlesmithjr)
- [EverythingShouldBeVirtual](http://everythingshouldbevirtual.com)
- [mrlesmithjr@gmail.com](mailto:mrlesmithjr@gmail.com)
