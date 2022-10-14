# BUSTED ModelTesting application

This repository provides an easy way to profile a dataset (multiple sequence alignment and phylogenetic tree) for evidence of episodic diversifying selection.

## Configuration

This implementation relies on Anaconda (https://anaconda.org/)

1. Clone the repository `git clone https://github.com/aglucaci/BUSTED_ModelTest`
2. Switch directories to the new folder `cd BUSTED_ModelTest`
2. Create the BUSTED ModelTest environment `conda env create -f environment.yml`
3. Activate your new environment `conda activate BUSTED_ModelTest`
4. Place your NEXUS (.nex) formatted data in the `data` folder

## Running the analysis

5. Execute the application `bash run_HPC.sh` for the server environment or `bash run_Local.sh` to run it on your laptop.

## Results

6. Results will be available in the `analysis` folder. Each JSON file will be created and a summary CSV file will be generated.
7. Results can also be reviewed by comparing BUSTED JSON files using our ObservableHQ notebook ().

## Example run

Once setup completes, we have provided a sample dataset `data/adh.nex`. To run this, the program will all ready be set up, it will look in the `data` folder for NEXUS files `.nex` and apply the model testing application to it.

To execute on your local computer type `run_Local.sh`, otherwise use `run_HPC.sh` to submit this job to your server.

This will produce the following JSON and likelihood fit (.fit) files

```
── results/
│   ├── adh.nex.BUSTEDS.json
│   ├── adh.nex.BUSTEDS.json.fit
│   ├── adh.nex.BUSTED.json
│   ├── adh.nex.BUSTED.json.fit
│   ├── adh.nex.BUSTEDS-MH.json
│   ├── adh.nex.BUSTEDS-MH.json.fit
│   ├── adh.nex.BUSTED-MH.json
│   ├── adh.nex.BUSTED-MH.json.fit
│  
── tables/ 
│   ├── adh.nex.csv
│

```

## Issues

Please post any issues related to this program to https://github.com/aglucaci/BUSTED_ModelTest/issues

## Optional

Create a tmux (https://github.com/tmux/tmux/wiki) session to manage your work `tmux new -s BUSTED_ModelTest`

