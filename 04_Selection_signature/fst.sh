#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

vcftools --gzvcf file_path/your_file.vcf.gz --weir-fst-pop file_path/your_file.txt --weir-fst-pop file_path/your_file.txt --out file_path/yes_no.snp_Fst --fst-window-size 50000 --fst-window-step 20000
