#!/bin/bash

mkdir -p output src

sbatch samtools_testcase_1.sh
sbatch samtools_testcase_2.sh

echo "All test cases have been submitted. Monitor their progress using squeue."
