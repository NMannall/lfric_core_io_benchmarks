#!/bin/bash

POSITIONAL_ARGS=()
OUTPUT_DIR=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -o|--output-dir)
      OUTPUT_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
      echo "[Help message]"
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

$MESH_GEN_EXE $MESH_DIR/$1.nml

if [ ! -z $OUTPUT_DIR ]; then
  mv mesh_$1.nc $OUTPUT_DIR/mesh_$1.nc
fi