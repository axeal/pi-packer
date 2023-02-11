# pi-packer

Configuration to create Ubuntu 22.04 Raspberry Pi images with [cloud-init](https://cloud-init.io/) and [network-config](https://netplan.io/reference), bundles [raspberrypi_exporter](https://github.com/fahlke/raspberrypi_exporter). Built using [arm-image](https://github.com/solo-io/packer-plugin-arm-image) Packer plugin.

To build using Docker:

```
docker run --rm   --privileged   -v /dev:/dev   -v ${PWD}:/build:ro   -v ${PWD}/packer_cache:/build/packer_cache   -v ${PWD}/output-arm-image:/build/output-arm-image ghcr.io/solo-io/packer-plugin-arm-image build .
```
