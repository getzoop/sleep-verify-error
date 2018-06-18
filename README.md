# ZoopPOS


## Build and Install

The project has a `default` directory as the build directory and a `pkg` directory where the AIP are.

### Docker

1. [Install docker](https://docs.docker.com/install/)
2. Start docker service on [Linux](https://www.youtube.com/watch?v=V9AKvZZCWLc) / [Mac](https://www.youtube.com/watch?v=lNkVxDSRo7M) / [Windows](https://www.youtube.com/watch?v=S7NVloq0EBc)
3. Using bash run:
```
  sh build.sh
```

You can found the docker comands on ./build.sh script

### Linux

On Linux a Makefile can build the project delivering the package to upload on POS terminal.

Just run:

```
  make
```

The executable can be found on `default/ZoopPOS-dev` and the package on `pkg/ZoopPOS-dev`.
At any change on project just re-run `make`.
