"""
Snakefile for BUSTED ModelTest

@Author: Alexander G Lucaci
"""

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
with open("cluster.json", "r") as in_sc:
  cluster = json.load(in_sc)
#end with

#configfile: "config.yml"

# Set output directory
BASEDIR = os.getcwd()

#LABEL = config["DataDirectory"]

#DATA_DIR = os.path.join(BASEDIR, "data", LABEL)
DATA_DIR = os.path.join(BASEDIR, "data")

NEXUS = [os.path.basename(x) for x in glob.glob(DATA_DIR + '/*.nex')]

print("# Processing:", len(NEXUS), "files")

#OUTDIR = os.path.join(BASEDIR, "results", LABEL)
OUTDIR = os.path.join(BASEDIR, "results")

# Report to user
print("# Files will be saved in:", OUTDIR)

# Create output dir.
Path(os.path.join(BASEDIR, "results")).mkdir(parents=True, exist_ok=True)
#Path(OUTDIR).mkdir(parents=True, exist_ok=True)

# Settings, these can be passed in or set in a config.json type file
PPN = cluster["__default__"]["ppn"] 

hyphy = "HYPHYMPI"

# ==============================================================================
# Helper functions
# ==============================================================================

def assign_code(wildcards):
    if wildcards.sample == "COXI.nex":
        return "Vertebrate-mtDNA"
    return "Universal"
#end method

# ==============================================================================
# Rule all
# ==============================================================================

rule all:
    input:
        expand(os.path.join(OUTDIR, "{sample}.BUSTED.json"), sample=NEXUS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTED.json.fit"), sample=NEXUS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTEDS.json"), sample=NEXUS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTEDS.json.fit"), sample=NEXUS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTEDS-MH.json"), sample=NEXUS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTEDS-MH.json.fit"), sample=NEXUS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTED-MH.json"), sample=NEXUS),
        expand(os.path.join(OUTDIR, "{sample}.BUSTED-MH.json.fit"), sample=NEXUS)
#end rule

# ==============================================================================
# Individual rules
# ==============================================================================

rule BUSTED:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR, "{sample}.BUSTED.json"),
        fit    = os.path.join(OUTDIR, "{sample}.BUSTED.json.fit")
    conda: 'environment.yml'
    params:
        code=assign_code
    shell:
        "mpirun -np {PPN} {hyphy} BUSTED --alignment {input.input} --output {output.output} --starting-points 10 --srv No --code {params.code} --save-fit {output.fit}"
    #end shell
#end rule

rule BUSTEDS:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR, "{sample}.BUSTEDS.json"),
        fit    = os.path.join(OUTDIR, "{sample}.BUSTEDS.json.fit")
    conda: 'environment.yml'
    params:
        code=assign_code
    shell:
        "mpirun -np {PPN} {hyphy} BUSTED --alignment {input.input} --output {output.output} --starting-points 10 --srv Yes --code {params.code} --save-fit {output.fit}"
    #end shell
#end rule

rule BUSTEDMH:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR, "{sample}.BUSTED-MH.json"),
        fit    = os.path.join(OUTDIR, "{sample}.BUSTED-MH.json.fit")
    conda: 'environment.yml'        
    params:
        code=assign_code    
    shell:
        "mpirun -np {PPN} {hyphy} BUSTED --alignment {input.input} --output {output.output} --starting-points 10 --srv No --code {params.code} --multiple-hits Double+Triple --save-fit {output.fit}"
    #end shell
#end rule 

rule BUSTEDSMH:
    input:
        input = os.path.join(DATA_DIR, "{sample}")
    output:
        output = os.path.join(OUTDIR, "{sample}.BUSTEDS-MH.json"),
        fit    = os.path.join(OUTDIR, "{sample}.BUSTEDS-MH.json.fit")
    conda: 'environment.yml'        
    params:
        code=assign_code
    shell:
        "mpirun -np {PPN} {hyphy} BUSTED --alignment {input.input} --output {output.output} --starting-points 10 --srv Yes --code {params.code} --multiple-hits Double+Triple --save-fit {output.fit}"
    #end shell
#end rule 



# End of file
