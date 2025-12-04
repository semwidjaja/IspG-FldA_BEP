#!/bin/bash

#SBATCH --job-name="analysis_sim7_v3"
#SBATCH --time=3:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=compute-p2
#SBATCH --mem-per-cpu=1GB
#SBATCH --account=Research-AS-BN
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim7/v3/postproc_sim7/Analysis_ASQ_v3.out
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim7/v3/postproc_sim7/Analysis_ASQ_v3.err
#SBATCH --mail-type=ALL

module load 2025 openmpi gromacs

#RMSD 
printf '1\n1\n' | gmx_mpi rms -f trajout_whole_nojump.xtc -s sim7_npt.tpr -n index_group.ndx -o data/RMSD_sim7_v3.xvg 

# RMSF
printf '4\n' | gmx_mpi rmsf -f trajout_whole_nojump.xtc -s sim7_npt.tpr -n index_group.ndx -res -o data/RMSF_sim7_v3.xvg 

# Gyration
printf '1\n' | gmx_mpi gyrate -f trajout_whole_nojump.xtc -s sim7_npt.tpr -n index_group.ndx -o data/gyrate_sim7_v3.xvg 

#Angle 
printf '' | gmx_mpi gangle -s sim7_npt.tpr -f trajout_whole_nojump.xtc -n index_group.ndx -g1 plane -group1 "atomnr {14315 14317 14318}" -g2 vector -group2 "com of atomnr {14315 14317 14318} plus atomnr 5801" -oav data/FMN_SF4_angle_sim7_v3.xvg

#hbond IspG and FldA
printf '24\n23\n' | gmx_mpi hbond-legacy -s sim7_npt.tpr -f trajout_whole_nojump.xtc -n index_group.ndx -num data/hb_IspG_fldA_sim7_v3.xvg 

#hbond IspG
printf '24\n24\n' | gmx_mpi hbond-legacy -s sim7_npt.tpr -f trajout_whole_nojump.xtc -n index_group.ndx -num data/hb_IspG_sim7_v3.xvg 

#hbond FldA
printf '23\n23\n' | gmx_mpi hbond-legacy -s sim7_npt.tpr -f trajout_whole_nojump.xtc -n index_group.ndx -num data/hb_fldA_sim7_v3.xvg 
