#!/bin/bash
#SBATCH -p short
#SBATCH --export=ALL
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH --job-name=samtools_testcase_1
#SBATCH --output=output/samtools_testcase_1.txt

mkdir -p output src

echo "========================================================"
echo "Test Case 1: Load Samtools Module and Verify Version"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start Time: $(date)"
echo "========================================================"

module_name="samtools/1.21"

# Load the samtools module
echo "Loading module: $module_name"
module load $module_name
if [ $? -ne 0 ]; then
    echo "Error: Failed to load module $module_name"
    echo "End Time: $(date)"
    exit 1
fi

# Verify samtools version
samtools_version=$(samtools --version | head -n 1 | awk '{print $2}')
if [[ "$samtools_version" != "1.21" ]]; then
    echo "Error: Incorrect samtools version. Expected 1.21, got $samtools_version"
    echo "End Time: $(date)"
    exit 1
fi

echo "Samtools version: $samtools_version"
echo "Module loaded successfully."

echo "End Time: $(date)"
echo "========================================================"
