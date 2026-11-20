#!/usr/bin/env bash
set -euo pipefail

BCF_FILE="$1"
BED_FILE="$2"
COV_FILE="$3"
GRM_FILE="$4"
OUT_PREFIX="$5"
THREADS="${6:-16}"
FPR="${7:-1e-5}"
WINDOW="${8:-1000000}"

# 1. Re-compress BED with bgzip and create .tbi index
LOCAL_BED="indexed_phenotypes.bed.gz"
zcat "${BED_FILE}" | bgzip -c > "${LOCAL_BED}"
tabix -f -p bed "${LOCAL_BED}"

# 2. Estimate and store LMM null model parameters (.theta.gz)
apex lmm \
  --bcf "${BCF_FILE}" \
  --bed "${LOCAL_BED}" \
  --cov "${COV_FILE}" \
  --grm "${GRM_FILE}" \
  --get-theta \
  --threads "${THREADS}" \
  --prefix "${OUT_PREFIX}_null"

# 3. Run trans-xQTL analysis using stored null model parameters
apex trans \
  --bcf "${BCF_FILE}" \
  --bed "${LOCAL_BED}" \
  --cov "${COV_FILE}" \
  --grm "${GRM_FILE}" \
  --theta "${OUT_PREFIX}_null.theta.gz" \
  --fpr "${FPR}" \
  --window "${WINDOW}" \
  --threads "${THREADS}" \
  --prefix "${OUT_PREFIX}_trans"
