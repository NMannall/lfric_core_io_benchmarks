# lfric_core_io_benchmarks

## Install dependencies with spack

```bash
module load spack
spack env activate .
spack install
```

## Build XIOS

```bash
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel
cd xios
./make_xios --arch_path ../xios-arch --arch cray --job 8 [--prod/dev/debug] [--full] [--build_suffixed]
```

## Build lfric_core applications/tools

These steps should be completed without the spack environment loaded.

```bash
git apply patch_lfric_core.diff
. setonix.env
```

### io_demo

```bash
cd lfric_core/applications/io-demo
make
cd -
```

### mesh_generator

```bash
cd lfric_core/mesh_tools
make
cd -
```
