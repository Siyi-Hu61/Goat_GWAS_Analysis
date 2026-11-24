#!/bin/bash
#SBATCH -J test
#SBATCH -p xahcnormal

#gemma -bfile file_path/your_file -gk 2 -p file_path/phe.txt

gemma -bfile file_path/your_file -k file_path/output/result.sXX.txt -lmm 1 -p file_path/phe.txt -n 1 -c file_path/pca.txt -o phe