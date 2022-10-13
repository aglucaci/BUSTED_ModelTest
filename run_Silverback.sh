#!/bin/bash

set -euo pipefail

printf "Running snakemake...\n"

# Uncomment this command to create the pipeline DAG
#snakemake --forceall --dag | dot -Tpdf > BUSTED_ModelTest_dag.pdf

mkdir -p logs

snakemake \
      -s Snakefile \
      --cluster-config cluster.json \
      --cluster "qsub -V -l nodes={cluster.nodes}:ppn={cluster.ppn} -q {cluster.name} -l walltime={cluster.walltime} -e logs -o logs" \
      --jobs 20 all \
      --rerun-incomplete \
      --keep-going \
      --reason \
      --latency-wait 60 

exit 0
