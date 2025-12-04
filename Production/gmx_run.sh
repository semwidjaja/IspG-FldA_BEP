#!/bin/bash

#SBATCH --job-name="IspG_ligand_RED_v1"
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --gpus-per-task=1
#SBATCH --partition=gpu-a100
#SBATCH --mem-per-cpu=1GB
#SBATCH --account=Research-AS-BN
#SBATCH --output=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim5/v1/IspG_ligand_RED_v1.out
#SBATCH --error=/scratch/sqwidjaja/IspG_MD_Project/05_jobs/simulations/sim5/v1/IspG_ligand_RED_v1.err
#SBATCH --mail-type=ALL

module load 2025 openmpi gromacs

# energy minimization
gmx_mpi  grompp -f minim.mdp -c substrate_RED.gro -p substrate_RED_gro.top -o sim5_em.tpr -maxwarn 1
gmx_mpi  mdrun -v -deffnm sim5_em

# equilibration nvt
gmx_mpi  grompp -f nvt.mdp -c sim5_em.gro -r sim5_em.gro -p substrate_RED_gro.top -o sim5_nvt.tpr -maxwarn 1
gmx_mpi  mdrun -deffnm sim5_nvt

# equilibration npt
gmx_mpi  grompp -f npt.mdp -c sim5_nvt.gro -r sim5_nvt.gro -t sim5_nvt.cpt -p substrate_RED_gro.top -o sim5_npt.tpr -maxwarn 1
gmx_mpi  mdrun -deffnm sim5_npt

# production phase
gmx_mpi  grompp -f md.mdp -c sim5_npt.tpr -t sim5_npt.cpt -p substrate_RED_gro.top -o sim5_md.tpr -maxwarn 1
gmx_mpi  mdrun -deffnm sim5_md


