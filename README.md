# Packer Chaining Example

This is just an example of how one might chain together builds using Packer. The main reason you might want to do this is to have Packer builds available at various stages throughout the build process. Another reason is that you might want to break out the build and not have to completely rebuild the base image if certain provisioning scripts have potential to fail. We are using Ubuntu 18.04 as our example here, so feel free to adapt to your scenario.

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
