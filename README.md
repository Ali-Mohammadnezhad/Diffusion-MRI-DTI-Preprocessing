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
By following these recommended steps and employing the mentioned tools, you can effectively pre-process your DTI data, setting the stage for robust and informative analysis of the brain's white matter structure.<br>

This code snippet collection demonstrates a fundamental MRI pre-processing pipeline specifically tailored for DTI data analysis. The scripts leverage the FSL software library (https://www.fmrib.ox.ac.uk/fsl) to prepare neuroimaging data for further analysis.

## Software and Commands:

* FSL (https://www.fmrib.ox.ac.uk/fsl).<br>

* MRIcroGL (https://github.com/rordenlab/MRIcroGL)
  
* Bvecs rotation ([fdt_rotate_bvecs.sh](https://github.com/QTIM-Lab/qtim_tools/blob/master/qtim_tools/external/fdt_rotate_bvecs.sh))

## Code Snippets:

## 1. Dicom2nii Conversion (dicom2nii)

**Description:**

This script employs the `dcm2niix` tool from MRIcroGL  to convert medical images stored in DICOM format (commonly used in medical imaging) to the Nifti format, which is widely utilized for neuroimaging analysis. Nifti format offers advantages in flexibility and compatibility with various neuroimaging software tools.  The flags used with `dcm2niix` are explained below:

**Code:**
```
* dicom2niix command to convert DICOM files to Nifti format
/home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/3106"
```
* `-m n`: Outputs the image in Nifti format.
* `-p y`: Preserves side information associated with the original DICOM images.
* `-z y`: Decompresses the image data for storage efficiency.
  
**Or this process can be done with MRIcroGL GUI:<be>**

![MRIcroGL](https://github.com/Ali-Mohammadnezhad/Diffusion-MRI-DTI-Preprocessing/assets/110347490/b0cca031-fed4-4d23-a32a-44a23c93f91f)

Extracting Skull and Brain Mask (bet.sh)

**Looping through all DICOM files in a directory for conversion**
```
for FILE in *; do
  /home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/Unzip_files/$FILE"
done
```
## 2. Extracting Skull and Brain Mask 

  ![Shot 2024-03-13 11;20;08](https://github.com/Ali-Mohammadnezhad/Diffusion-MRI-DTI-Preprocessing/assets/110347490/0dd36876-3875-49ed-b001-1711466fd344)

**Description:**
This code snippet collection (assuming it's part of a larger script named bet.sh) performs skull extraction and brain mask generation on your DTI data.

**Code:**

```
bet image betted_image -f 0.3 -m
```
* `image`: This is  the name of your DTI image.
* `betted_image`: This is the name of the output file .
* `-f 0.3`: This sets the fractional intensity threshold for brain tissue segmentation.
* `-m`: This flag instructs Bet to create a brain mask.
  
**Looping through all files in a directory for applying Bet**
 ```
for File in *; do bet  $File $File -m; done
 ```
## 3. Eddy Current correction (eddy_correct)

**Description:**
The **eddy_correct** command in FSL offers various options to control the eddy current correction process.

**Code:**
```
eddy_correct data data_corrected def
```
* `data`:This specifies the input diffusion-weighted imaging (DWI) data file. This is typically a 4D NIfTI image containing multiple diffusion directions.
* `data_corrected`:This specifies the corrected output diffusion-weighted imaging (DWI) data file
* `def`:This option allows you to specify a reference volume within the DWI data for image registration during correction. By default (0), the first volume is used.

## 4. bvecs adjustment (fdt_rotate_bvecs.sh)

**Description:**
 For rotating b-vectors (directions of diffusion in diffusion MRI) after eddy current correction.

 **Code:**
```
bash fdt_rotate_bvecs.sh bvecs bvecs_rotated data_corrected.ecclog
```
* `bvecs `: the original b-vector file.
* `bvecs_rotated `:the rotated b-vector file
* `data_corrected.ecclog `: the file that is created after eddy current correction

## 5. Tensor Calculation (DTIFit)

**Description:**
**DTIFit** analyzes diffusion MRI data voxel by voxel, creating a model that describes how water molecules move within the brain tissue. This analysis usually requires the data to be cleaned up beforehand (pre-processed) and corrected for distortions (eddy current correction).

 **Code:**
 ```
dtifit -k data -o output -m mask -r bvecs -b bvals
```
* `-k data`: This option specifies the input diffusion-weighted imaging (DWI) data file.
* `-o output`: This option specifies the output filename where the DTI results will be stored.
* `-m mask`: This option defines a mask file. This mask is a binary image that restricts the DTI analysis to specific regions of interest (ROIs) within the brain.
* `-r bvecs`: This option specifies the b-vector file. B-vectors encode the diffusion directions within the DWI data and are crucial for DTI calculations.
* `-b bvals`: This option specifies the b-value file. B-values represent the diffusion weighting applied during DWI acquisition and are used in DTI calculations.<be>

** Outputs of DTIFit:<br>
* `basename_V1` - 1st eigenvector
* `basename_V2` - 2nd eigenvector
* `basename_V3` - 3rd eigenvector
* `basename_L1` - 1st eigenvalue
* `basename_L2` - 2nd eigenvalue
* `basename_L3` - 3rd eigenvalue
* `basename_MD` - Mean Diffusivity
* `basename_FA` - Fractional anisotropy
* `basename_S0` - raw T2 signal with no diffusion weighting
  
![image](https://github.com/Ali-Mohammadnezhad/Diffusion-MRI-DTI-Preprocessing/assets/110347490/b58b9c5e-2869-45da-bdef-c5b4483f3def)


$\Large\text{FA} = \frac{\sqrt{\frac{1}{2}[(\lambda_1 - \text{MD})^2 + (\lambda_2 - \text{MD})^2 + (\lambda_3 - \text{MD})^2]}}{\sqrt{\lambda_1^2 + \lambda_2^2 + \lambda_3^2}}$

$\Large\text{MD} = \frac{\lambda_1 + \lambda_2 + \lambda_3}{3}$

$\Large\text{RD} = \frac{\lambda_2 + \lambda_3}{2}$

$\Large\text{AD} = \lambda_1$

| FA | MD | RD | AD |
|----|----|----|----|
| $\Large\text{FA} = \frac{\sqrt{\frac{1}{2}[(\lambda_1 - \text{MD})^2 + (\lambda_2 - \text{MD})^2 + (\lambda_3 - \text{MD})^2]}}{\sqrt{\lambda_1^2 + \lambda_2^2 + \lambda_3^2}}$ | $\Large\text{MD} = \frac{\lambda_1 + \lambda_2 + \lambda_3}{3}$ | $\Large\text{RD} = \frac{\lambda_2 + \lambda_3}{2}$ | $\Large\text{AD} = \lambda_1$ |
