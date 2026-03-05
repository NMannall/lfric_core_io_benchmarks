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

## Build lfric_core

These steps should be completed without the spack environment loaded.

```bash
salloc -p debug -n 1 -N 1 -c 1 --mem=16G -A pawsey0835  # Need to run on a compute node to run the unit tests
. setonix.env
cd lfric_core/applications/io-demo
make
```
