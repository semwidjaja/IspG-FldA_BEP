#!/bin/bash

#SBATCH --job-name="analysis_sim8_ensemble_v1"
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=compute-p2
#SBATCH --mem-per-cpu=1GB
#SBATCH --account=Research-AS-BN
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v1/postproc_sim8/Analysis_ensemble_v1.out
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim8/v1/postproc_sim8/Analysis_ensemble_v1.err
#SBATCH --mail-type=ALL

set -euo pipefail
module load 2025 openmpi gromacs

SELECT="com of group 14 plus com of group 21"

#convert .tpr to xtc
printf '0\n' | gmx_mpi trjconv -s sim5_nvt.tpr -f sim5_nvt.trr -o sim5_nvt.xtc -pbc nojump -n index_group.ndx
printf '0\n' | gmx_mpi trjconv -s sim5_npt.tpr -f sim5_npt.trr -o sim5_npt.xtc -pbc nojump -n index_group.ndx 

#postproces nvt and npt 
printf '0\n' | gmx_mpi trjconv -s sim8_nvt.tpr -f sim8_nvt.xtc -o sim8_nvt_proc.xtc -pbc nojump -n index_group.ndx 
printf '0\n' | gmx_mpi trjconv -s sim8_npt.tpr -f sim8_npt.xtc -o sim8_npt_proc.xtc -pbc nojump -n index_group.ndx
printf '0\n' | gmx_mpi trjconv -s sim8_md.tpr -f trajout_whole_nojump.xtc -o sim8_md_proc.xtc -pbc nojump -n index_group.ndx

#shift times
printf '0\n' | gmx_mpi trjconv -s sim8_nvt.tpr -f sim8_nvt_proc.xtc -o sim8_nvt_shift.xtc -t0 0 -n index_group.ndx
printf '0\n' | gmx_mpi trjconv -s sim8_npt.tpr -f sim8_npt_proc.xtc -o sim8_npt_shift.xtc -t0 100 -n index_group.ndx
printf '0\n' | gmx_mpi trjconv -s sim8_md.tpr -f sim8_md_proc.xtc -o sim8_md_shift.xtc -t0 200 -n index_group.ndx

#concatenate:
printf '0\n' | gmx_mpi trjcat -f sim8_nvt_shift.xtc sim8_npt_shift.xtc sim8_md_shift.xtc -n index_group.ndx -o full_path_sim8.xtc -sort

#compute distance
gmx_mpi distance -s sim8_md.tpr -f full_path_sim8.xtc -n index_group.ndx -select "${SELECT}" -oall distance_full_sim8.xvg -tu ns



