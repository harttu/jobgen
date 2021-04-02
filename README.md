## Jobgen - Automation pipeline for running jobs in slurm
This is a framework intended to automate the process of running grid jobs in the slurm system. 
Jobs are gathered in runs/ folder. This project is highly dependent of individual project, perhaps a more general version will be out in the future.

start.bash has self explatory comments. start_jobgen_grid.sh is a grid of grid that executes runs when there is room in the queue.

Usage:
```bash
git clone reponame
cp reponame/start.bash . # start file is in the root
cp reponame/scripts/run-JOBGEN.sh ./scripts/ # scripts-folder is the default place for scripts
mkdir runs # this is where logs are gathered
```
Edit start.bash to select data, model and tweak parameters
```bash
bash start.bash
begin NAME_OF_OUTPUTFILE
```
Examine the runs/run_name folder. The logs will be directed to this dir along with awk-utilities to make summaries.
