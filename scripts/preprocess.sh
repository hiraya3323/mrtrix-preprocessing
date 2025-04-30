nano scripts/preprocess.sh
#!/bin/bash

# ==================================================
# MRtrix Preprocessing Script for ds001226 dataset
# Author: Royze Simon
# Date: 2025-04-25
# ==================================================

# Step 0: Define input and output paths
RAW_DATA=raw_data/dwi.mif
PREPROC_DATA=preprocessed/dwi_preprocessed.mif
DENOISED_DATA=preprocessed/dwi_denoised.mif
GIBBS_DATA=preprocessed/dwi_degibbs.mif
MASK_DATA=preprocessed/dwi_mask.mif

# Make sure output directories exist
#!/bin/bash

# Define input and output
RAW_DATA=raw_data/dwi.mif
DENOISED_DATA=preprocessed/dwi_denoised.mif
GIBBS_DATA=preprocessed/dwi_degibbs.mif
PREPROC_DATA=preprocessed/dwi_preprocessed.mif
MASK_DATA=preprocessed/dwi_mask.mif

# Create necessary folders
mkdir -p preprocessed logs

# Denoising
dwidenoise $RAW_DATA $DENOISED_DATA -noise logs/noise.mif -force

# Remove Gibbs ringing
mrdegibbs $DENOISED_DATA $GIBBS_DATA -force

# Motion and Eddy-current correction
dwifslpreproc $GIBBS_DATA $PREPROC_DATA -pe_dir AP -rpe_none -eddy_options " --slm=linear " -eddyqc_text logs/eddyqc -force

# Brain Mask generation
dwi2mask $PREPROC_DATA $MASK_DATA -force

echo "Preprocessing complete! Check the 'preprocessed/' folder."
