# Snakefile for BUSTED ModelTest
# @Author: Alexander G Lucaci

# ==============================================================================
# Imports
# ==============================================================================
import os
import sys
import json
import csv
from pathlib import Path
import glob

# ==============================================================================
# Declares
# ==============================================================================

DATA_DIR = "/home/aglucaci/BUSTED_ModelTest/data/14_datasets"

NEWICKS = [os.path.basename(x) for x in glob.glob(DATA_DIR + '/*.nwk')]
#NEWICKS = glob.glob(DATA_DIR + '/*.nwk')

OUTDIR = "/home/aglucaci/BUSTED_ModelTest/analysis"

# Report to user
print("# Files will be saved in:", OUTDIR)

# Create output dir.
Path(OUTDIR).mkdir(parents=True, exist_ok=True)

# Settings, these can be passed in or set in a config.json type file
#PPN = cluster["__default__"]["ppn"] 
PPN = 8

BUSTEDSMH_BF = "/home/aglucaci/hyphy-analyses/BUSTED-MH/BUSTED-MH.bf"

hyphy = "HYPHYMPI"

# ==============================================================================
# Rule all
# ==============================================================================

rule all:
    input:
        expand(os.path.join(OUTDIR, "{sample}.BUSTED.json"), sample=NEWICKS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTEDS.json"), sample=NEWICKS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTEDS-MH.json"), sample=NEWICKS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTED-MH.json"), sample=NEWICKS)
#end rule

# ==============================================================================
# Individual rules
# ==============================================================================

rule BUSTED:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR, "{sample}.BUSTED.json")
    conda: 'environment.yml'
    shell:
        "mpirun --use-hwthread-cpus -np {PPN} {hyphy} BUSTED --alignment {input.input}  --output {output.output} --starting-points 10 --srv No"
    #end shell
#end rule

rule BUSTEDS:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR_BUSTEDS, "{sample}.BUSTEDS.json")
    conda: 'environment.yml'
    shell:
        "mpirun --use-hwthread-cpus -np {PPN} {hyphy} BUSTED --alignment {input.fasta} --output {output.output} --starting-points 10 --srv Yes"
    #end shell
#end rule

rule BUSTEDMH:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR, "{sample}.BUSTEDS-MH.json")
    conda: 'environment.yml'        
    shell:
        "mpirun --use-hwthread-cpus -np {PPN} {hyphy} {BUSTEDSMH_BF} --alignment {input.fasta} --output {output.output} --starting-points 10 --srv No"
    #end shell
#end fule 

rule BUSTEDSMH:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR_BUSTEDSMH, "{sample}.BUSTEDS-MH.json")
    conda: 'environment.yml'        
    shell:
        "mpirun --use-hwthread-cpus -np {PPN} {hyphy} {BUSTEDSMH_BF} --alignment {input.fasta} --output {output.output} --starting-points 10"
    #end shell
#end fule 



# End of file
