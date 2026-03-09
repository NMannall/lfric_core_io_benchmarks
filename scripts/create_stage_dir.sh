#!/bin/bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo -e "Usage:\n    $0 stage_directory_name mesh_size"
      exit 1
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

# Create stage directory path
RUN_DIR=$STAGE_DIR/$1
mkdir -p $RUN_DIR
rm $RUN_DIR/*

# Generate mesh
$SCRIPTS_DIR/generate_mesh.sh $2 -o $RUN_DIR

# Copy configuration files
cp $CONFIGS_DIR/iodef.xml $RUN_DIR
cp $CONFIGS_DIR/configuration.nml $RUN_DIR
cp -r $CONFIGS_DIR/metadata $RUN_DIR

# Edit configuration.nml with correct mesh size
sed -i "s/C24/$2/g" $RUN_DIR/configuration.nml

# Create symbolic link to the io-demo and xios_server executables
ln -s $IO_DEMO_EXE $RUN_DIR/io_demo
ln -s $XIOS_EXE $RUN_DIR/xios_server.exe

# Create job script
source $CONFIGS_DIR/$2.param

NODES=$((IO_DEMO_NODES+XIOS_NODES))
TASKS=$((IO_DEMO_TASKS+(XIOS_TASKS*XIOS_NODES)))
SHARED_ARGS="--distribution=block:block --hint=nomultithread"

cat > $RUN_DIR/job.slurm << EOL
#!/bin/bash

#SBATCH --job-name=$1
#SBATCH --account=$PAWSEY_PROJECT
#SBATCH --nodes=$NODES
#SBATCH --time=00:20:00
#SBATCH --partition=work
#SBATCH --exclusive

. $BASE_DIR/setonix.env

export OMP_NUM_THREADS=1
export OMP_PROC_BIND=spread

srun \\
  --het-group=0 --nodes=$IO_DEMO_NODES --ntasks=$IO_DEMO_TASKS $SHARED_ARGS ./io_demo configuration.nml : \\
  --het-group=1 --nodes=$XIOS_NODES --ntasks-per-node=$XIOS_TASKS $SHARED_ARGS ./xios_server.exe
EOL
