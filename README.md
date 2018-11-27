# Management-and-Post-Processing-of-Prostate-MRI
Adenocarcinoma of the prostate generally appears in older men. About 85% of cases are diagnosed in men over 60 years. Prostate cancer is a common cancer, the incidence and mortality are now steadily increasing (85,000 new cases per year in Europe). It is the second most common cancer after lung cancer and the third leading cause of cancer death in men (9% of all cancer deaths in men in Europe).

Currently, there are four anatomically glandular areas within the prostate: 
- Peripheral zone (ZP) 
- Central zone (ZC) 
- Transition zone (ZT) 
- Anterior Fibromuscular Tissue (AFT)

# Diagnostic: 

The Magnetic Resonance Imaging (MRI) provides high-resolution images in all planes of space, allowing precise anatomical visualization of the prostate. MRI of prostate cancer benefits from technological advances that expand more indications. MRI is a valuable tool to guide therapeutic management of prostate cancer through acquisition sequences as follows: 

• Anatomical imaging– 3D - T2 weighted imaging 
• Diffusion imaging – ADC (Apparent Diffusion Coefficient) 
• Perfusion imaging –DCE (Dynamic Contrast Enhancement) (Observation from signal-intensity time curve) 
• Spectroscopy


To run the GUI

1. make your current working directory of MATLAB as this project folder
2. Open segmentation.m file in MATLAB
3. run the script and GUI will be displyed 


Files:

segmentation.m - main gui file
calculateArea.m - function to calculate area
calculateVolume.m - function to calculate volume
dir2.m - to get files from directory including hidden ',' and ',,' files
draw3D.m - to draw 3D reconstruction using approach 1
drawSurface.m - to draw 3D reconstruction using approach 2
natsort.m and natsortfiles.m - used to sort files (from Mathworks Central)

