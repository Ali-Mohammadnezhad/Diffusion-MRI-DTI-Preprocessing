# MRI Pre-processing Pipeline for Diffusion Tensor Imaging (DTI) Analysis

This section outlines a recommended workflow for pre-processing Diffusion Tensor Imaging (DTI) data, primarily designed for Linux systems. This pipeline utilizes a series of tools to prepare your DTI data for further analysis and extract meaningful information about the brain's white matter structure.

* ## DICOM to Nifti Conversion (dcm2nii):<br>
We begin by converting your raw DTI data from **DICOM** format, commonly used in medical imaging, to the **Nifti** format. This conversion is typically accomplished using the dcm2nii tool. Nifti offers advantages in terms of flexibility and compatibility with various neuroimaging analysis software compared to DICOM.

* ## Brain Extraction (BET):<br>
After conversion, the BET (Brain Extraction Tool) software takes center stage. Its role is to isolate the brain tissue by meticulously removing the skull and other non-brain elements from the image data. This creates a brain mask, ensuring subsequent analyses focus on the brain region of interest.

* ## Eddy Current Correction (eddy_correct):<br>
DTI data can be susceptible to distortions arising from eddy currents within the MRI scanner. The **eddy_correct** command tackles this issue by correcting for these distortions, leading to a more accurate representation of the underlying diffusion properties within the brain.

* ## B-vector Adjustment:<br>
DTI analysis heavily relies on information encoded in "b-vectors." These vectors describe the diffusion gradients applied during the DTI acquisition process. This step ensures proper alignment and interpretation of the b-vector data, which is crucial for accurate analysis.

* ## DTI Parameter Estimation (dtifit):<br>
Finally, we leverage the dtifit tool. This powerful tool utilizes the pre-processed data to estimate various diffusion parameters relevant to white matter analysis. These parameters include Fractional Anisotropy **(FA)** and Mean Diffusivity **(MD)**, which provide valuable insights into the microstructure and organization of white matter tracts within the brain.
By following these recommended steps and employing the mentioned tools, you can effectively pre-process your DTI data, setting the stage for robust and informative analysis of the brain's white matter structure.











This code snippet collection demonstrates a fundamental MRI pre-processing pipeline specifically tailored for DTI data analysis. The scripts leverage the FSL software library (https://www.fmrib.ox.ac.uk/fsl) to prepare neuroimaging data for further analysis.

## Software:

* FSL (https://www.fmrib.ox.ac.uk/fsl).<br>

* MRIcroGL (https://github.com/rordenlab/MRIcroGL) 

## Code Snippets:

## 1. Dicom2nii Conversion (dicom2nii.sh)

**Description:**

This script employs the `dcm2niix` tool from MRIcroGL  to convert medical images stored in DICOM format (commonly used in medical imaging) to the Nifti format, which is widely utilized for neuroimaging analysis. Nifti format offers advantages in flexibility and compatibility with various neuroimaging software tools.  The flags used with `dcm2niix` are explained below:

* `-m n`: Outputs the image in Nifti format.
* `-p y`: Preserves side information associated with the original DICOM images.
* `-z y`: Decompresses the image data for storage efficiency.

**Code:**

```
* dicom2niix command to convert DICOM files to Nifti format
/home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/3106"
```
**Or this process can be done with MRIcroGL GUI:<be>**

![MRIcroGL](https://github.com/Ali-Mohammadnezhad/Diffusion-MRI-DTI-Preprocessing/assets/110347490/b0cca031-fed4-4d23-a32a-44a23c93f91f)



**Looping through all DICOM files in a directory for conversion**
```
for FILE in *; do
  /home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/Unzip_files/$FILE"
done
```
