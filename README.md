# lfric_core_io_benchmarks

## Install dependencies with spack

```bash
module load spack
spack env activate .
spack install
```

## Build XIOS

These steps should be completed without the spack environment loaded.

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
. xios2.env
./scripts/build_io_demo.sh

. xios3.env
./scripts/build_io_demo.sh
```

### mesh_generator

```bash
./scripts/build_mesh_tools.sh
```

## Run a job

```bash
. setonix.env
. xios2.env  # Or: . xios3.env

./scripts/create_stage_dir.sh job_name mesh_size  # e.g. C224_XIOS2 C224
./scripts/submit_job.sh job_name
```
