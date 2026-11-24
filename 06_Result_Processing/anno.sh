#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

perl file_path/annotate_variation.pl --outfile gwas --buildver Capra_hircus.ARS1.113 file_path/gwas.bed file_path/goatdb

#awk 'NR > 1 {print $1 "\t" $2 "\t" $3 "\t0\t0"}' gwas.txt > gwas.bed