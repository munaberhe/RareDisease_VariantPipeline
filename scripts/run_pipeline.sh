#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------
# 1️ INPUT AND OUTPUT SETUP
# --------------------------------------------
INPUT_VCF="data/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
OUTPUT_DIR="results"
mkdir -p "${OUTPUT_DIR}"

# --------------------------------------------
# 2️ FILTER for PASS variants on chr22
# --------------------------------------------
echo "Filtering for PASS variants..."
bcftools view -f PASS "${INPUT_VCF}" -Ov -o "${OUTPUT_DIR}/chr22_filtered.vcf"

# --------------------------------------------
# 3️ Compress and index properly
# --------------------------------------------
echo "Compressing and indexing..."
bgzip -f "${OUTPUT_DIR}/chr22_filtered.vcf"
bcftools index -f "${OUTPUT_DIR}/chr22_filtered.vcf.gz"

# --------------------------------------------
# 4️ FILTER for rare variants (AF < 0.01)
# --------------------------------------------
echo "Filtering for rare variants (AF < 0.01)..."
bcftools view -i 'INFO/AF<0.01' "${OUTPUT_DIR}/chr22_filtered.vcf.gz" -Oz -o "${OUTPUT_DIR}/chr22_rare.vcf.gz"

# --------------------------------------------
# 5️⃣Index rare variants
# --------------------------------------------
bcftools index -f "${OUTPUT_DIR}/chr22_rare.vcf.gz"

echo " Pipeline complete!"

