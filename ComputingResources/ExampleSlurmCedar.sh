#!/bin/bash
#SBATCH --account=def-zhouzhou 
#SBATCH --time=00:15:00
#SBATCH --job-name="example_presentation"
#SBATCH --array=1-1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=2G
#SBATCH --mail-user=david.veitch@mail.utoronto.ca
#SBATCH --mail-type=END
#SBATCH --output=%x.%a.out

# Some points on the above
# job-name   : this just specifies what job is called, here I have set it so the name of the job is the function being run
#              in the actual script
# array      : currently set 1-1, but can set as x-y (x,y integers x<y), this then runs the same job a number of times with indexes
#              x,x+1,x+2,...,y and the index takes on the value $SLURM_ARRAY_TASK_ID
# mail-user  : this option sends an email to the address written once job is done

# Load required modules and set directory
module load StdEnv gcc/9.3.0 r/4.1.0
cd /scratch/dveitch/Example
export R_LIBS=~/local/R_libs/

# This runs the script; here instead of manually entering the 5 arguments, the first 4 are based on what we already defined in the sbatch
# commands above here
# $SLURM_JOB_NAME         = function being run in Rscript
# $SLURM_ARRAY_TASK_ID    = job number
# $SLURM_CPUS_PER_TASK    = number of cores to use
# $SLURM_TASK_COUNT       = 1 as only running one task
# CEDARSCRATCH            = name of the compute server
srun Rscript ExampleScript.R $SLURM_JOB_NAME $SLURM_ARRAY_TASK_ID $SLURM_CPUS_PER_TASK $SLURM_ARRAY_TASK_COUNT CEDARSCRATCH