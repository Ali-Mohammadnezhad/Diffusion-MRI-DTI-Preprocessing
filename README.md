## MRI Pre-processing Pipeline for Diffusion Tensor Imaging (DTI) Analysis

This code snippet collection demonstrates a fundamental MRI pre-processing pipeline specifically tailored for DTI data analysis. The scripts leverage the FSL software library (https://www.fmrib.ox.ac.uk/fsl) to prepare your neuroimaging data for further analysis.

**Software:**

* FSL (https://www.fmrib.ox.ac.uk/fsl)

**Code Snippets**

**1. Dicom2nii Conversion (dicom2nii.sh)**

**Description:**

This script employs the `dcm2niix` tool to convert medical images stored in DICOM format (commonly used in medical imaging) to the Nifti format, which is widely utilized for neuroimaging analysis. Nifti format offers advantages in flexibility and compatibility with various neuroimaging software tools.  The flags used with `dcm2niix` are explained below:

* `-m n`: Outputs the image in Nifti format.
* `-p y`: Preserves side information associated with the original DICOM images.
* `-z y`: Decompresses the image data for storage efficiency.

**Code:**

```sh
# dicom2niix command to convert DICOM files to Nifti format
/home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/3106"

# Looping through all DICOM files in a directory for conversion
for FILE in *; do
  /home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/Unzip_files/$FILE"
done
