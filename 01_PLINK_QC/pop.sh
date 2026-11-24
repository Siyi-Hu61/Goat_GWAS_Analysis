#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

plink \
  --bfile file_path/your_file \
  --keep pop.txt \
  --make-bed \
  --out your_file --chr-set 29
