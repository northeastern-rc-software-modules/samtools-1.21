#!/bin/bash
#SBATCH -p short
#SBATCH --export=ALL
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH --job-name=samtools_testcase_2
#SBATCH --output=output/samtools_testcase_2.txt

mkdir -p output src

echo "========================================================"
echo "Test Case 2: Process BAM File Using Samtools"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start Time: $(date)"
echo "========================================================"

module load samtools/1.21

# Create a synthetic SAM file with a valid header and alignment data
sample_sam="src/sample.sam"
sample_bam="src/sample.bam"
sorted_bam="output/sample_sorted.bam"

echo "Creating a synthetic SAM file..."
cat <<EOF > $sample_sam
@HD	VN:1.6	SO:unsorted
@SQ	SN:chr1	LN:1000
read1	0	chr1	1	60	50M	*	0	0	*	*
EOF

# Convert the SAM file to BAM format
echo "Converting SAM to BAM..."
samtools view -bS $sample_sam > $sample_bam
if [ $? -ne 0 ]; then
    echo "Error: Failed to convert SAM to BAM."
    echo "End Time: $(date)"
    exit 1
fi

# Sort the BAM file
echo "Sorting BAM file..."
samtools sort "$sample_bam" -o "$sorted_bam"
if [ $? -ne 0 ]; then
    echo "Error: Failed to sort BAM file."
    echo "End Time: $(date)"
    exit 1
fi

# Index the sorted BAM file
echo "Indexing sorted BAM file..."
samtools index "$sorted_bam"
if [ $? -ne 0 ]; then
    echo "Error: Failed to index sorted BAM file."
    echo "End Time: $(date)"
    exit 1
fi

# Verify index creation
if [ ! -f "${sorted_bam}.bai" ]; then
    echo "Error: Index file not created."
    echo "End Time: $(date)"
    exit 1
fi

echo "BAM file processed successfully (sorted and indexed)."
echo "End Time: $(date)"
echo "========================================================"
