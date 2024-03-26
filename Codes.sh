#Dicom2nii
/home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/3106"
....................
 for FILE in *; do /home/alielecen/Project/MRIcroGL_linux/MRIcroGL/Resources/dcm2niix -m n -p y -z y "/media/alielecen/A65CA91C5CA8E86F/Graduate Research/steps/12)Dataset/Hc_deep/Unzip_files/$FILE"
> done
.....................
#register all images to MNI
for FILE in *; do /usr/local/fsl/bin/flirt -in /home/alielecen/Desktop/FA_HC_Standard/$FILE -ref /home/alielecen/Desktop/standard-betted_default.nii.gz -out $FILE -omat $FILE.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
........................................................................
# apply susan to all images
for File in *;
 do /usr/local/fsl/bin/susan /home/alielecen/Desktop/FA_HC_Standard/$File 0.0520517 0.0 2 1 0 /home/alielecen/Desktop/FA_HC_Standard/$File
done
.........................................................................
#Extracting skull
bet b0_image_susan nodif_brain -f 0.3 -m
for File in *; do bet  $File $File -m; done
for File in *; do bet  $File $File -m -F; done
#Extracting b0
fslroi data data_b0 0 1
# ROTATING BVECS
bash fdt_rotate_bvecs.sh bvecs bvecs_rotated data_corrected.ecclog
# EDDY_CORRECT
eddy_correct data data_corrected def
# DTIFIT
dtifit -k data -o output -m mask -r bvecs -b bvals
# smoothing with gaussian kernel
fslmaths original.nii -kernel gauss 1.8 -fmean smoothed.nii
..........................................................................
epi_reg :epi_reg can register a b0 or FA map to a T1-weighted image using boundary-based registration (BBR). This produces the diffusion to structural transform, as you want to opposite transform you will have to invert this transform using convert_xfm.
............................................................................
convertwarp and inwarp:Compute a linear transform from diffusion to structural space using epi_reg as described above. Then use FNIRT to register the structural image non-linearly to the MNI152 standard image. Finally concatenate the two transforms using convertwarp to get the diffusion to standard space transform. The opposite transform can be generated using invwarp.
..........................................................................
randomise:


..........................................................................
AutoPtx:AutoPtx v0.1.1 is a set of simple scripts and mask images to run probabilistic tractography in subject-native space using pre-defined protocols. 
.....................................................................................
find_the_biggest :Run find_the_biggest on the outputs of seeds to targets to generate a hard segmentation of the thalamus and overlay this segmentation onto the standard brain
....................................................................................
xfibres :Note that bedpostx is a wrapper script for a command-line tool called xfibres.
........................................................................................
FslSge: SGE-capable system for FSL => multi threading
........................................................................................
proj_thresh: proj_thresh is a command line utility that provides an alternative way of expressing connection probability in connectivity-based segmentation. It is run on the output of probtrackx when classification targets are used.
............................................................................................
vecreg:After running dtifit or bedpostx, it is often useful to register vector data to another space. For example, one might want to represent V1 for different subjects in standard space. vecreg is a command line tool that allows to perform such registration.
............................................................................................
qboot: qboot is a command line tool that allows estimation of diffusion ODFs and fibre orientations from them. Its output can be used as an input for probtrackX in order to perform probabilistic tractography.
...........................................................................................
qboot_parallel: Similar to bedpostX qboot can be parallelised if run on an SGE-capable system. The qboot_parallel script can be employed for this purpose.
............................................................................................
tbss (tbss_1_preproc ,tbss_2_reg ,tbss_3_postreg ,tbss_4_prestats: Tract-Based Spatial Statistics
...........................................................................................
slicesdir : script runs slicesdir, which creates an overview webpage containing a static view of each of the input images, so that you can then quickly view each of them for obvious problems.
...........................................................................................
xtract_stats: A common usage of the XTRACT output is to summarise tracts in terms of simple summary statistics, such as their volume and microstructural properties (e.g. mean FA). We provide XTRACT_stats to get such summary statistics in a quick and simple way.
......................................................................................................
*.nii => whole nii files in the directory
.....................................................................................................
#kasrekhedmat codes:
# Bias field correction
for File in *;
 do /usr/local/fsl/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 --nopve -B -o /home/alielecen/Desktop/MRI_BNI/$File  /home/alielecen/Desktop/MRI_BNI/$File 
done
.........................................................................................................
#Obtaining AD and RD:
fslmaths dti_L2 -add dti_L3 dti_L2+L3
fslmaths  dti_L2+L3 -div 2 dti_L2+L3DIV2 
.........................................................................................................
# making directories based on file names in currecnt directory:
for i in *; do mkdir "ali_${i}" ;done
........................................................................
Registering subjects in MNI152_2mm

for file in *;
do /usr/local/fsl/bin/flirt -in $file -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -out $file -omat $file -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear; done




