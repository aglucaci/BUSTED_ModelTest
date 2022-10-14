#!/bin/bash

set -euo pipefail

printf "Running BUSTED ModelTest (Local version)...\n"

# Uncomment this command to create the pipeline DAG
#snakemake --forceall --dag | dot -Tpdf > BUSTED_ModelTest_dag.pdf

mkdir -p logs

snakemake \
      -s Snakefile \
      --cluster-config cluster.json \
      --jobs 2 all \
      --rerun-incomplete \
      --keep-going \
      --reason \
      --latency-wait 60 

exit 0
