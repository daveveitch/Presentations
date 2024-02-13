#!/bin/bash
#SBATCH --account=rrg-junpark 
#SBATCH --time=00:15:00
#SBATCH --job-name="ex_simulation"
#SBATCH --array=1-1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mail-user=david.veitch@mail.utoronto.ca
#SBATCH --mail-type=END
#SBATCH --output=%x.%a.out

# This is useful if you ever need to have a job number greater than 1000, since Niagara does not allow
# having an array with max value over 1000
THISJOBVALUE=$(( 0 + $SLURM_ARRAY_TASK_ID ))

module load CCEnv StdEnv gcc/9.3.0 r/4.1.0
cd /gpfs/fs0/scratch/j/junpark/dveitch/Example

export R_LIBS=~/local/R_libs/

srun Rscript ExampleScript.R $SLURM_JOB_NAME $THISJOBVALUE 80 $SLURM_ARRAY_TASK_COUNT NIAGARA