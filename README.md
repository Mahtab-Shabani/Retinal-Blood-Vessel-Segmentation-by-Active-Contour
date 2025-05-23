# Retinal-Blood-Vessel-Segmentation-by-Active-Contour

Active contour is a strong method for edge extraction. However, it cannot extract thin vessels and ridges very well. We propose an enhanced active contour for retinal blood vessel extraction. This repository is an implementation of the paper below:

**"An active contour model using matched filter and Hessian matrix for retinal vessels segmentation. Shabani, etc."** 
 [LINK](https://journals.tubitak.gov.tr/elektrik/vol30/iss1/20/) <br/>
[Mahtab Shabani](https://scholar.google.com/citations?user=GkpKF88AAAAJ&hl=en) , [Hossein Pourghassem](https://scholar.google.com/citations?user=o1fC3ngAAAAJ&hl=en)


#### Citation: 
If you find our work useful, please consider citing:
```bibtex
@article{shabani2022active,
  title={An active contour model using matched filter and Hessian matrix for retinal vessels segmentation},
  author={Shabani, Mahtab and Pourghassem, Hossein},
  journal={Turkish Journal of Electrical Engineering and Computer Sciences},
  volume={30},
  number={1},
  pages={295--311},
  year={2022}
}
```


For additional information, read the master dissertation: [Preprint](https://www.researchgate.net/publication/362887703_Master_thesis_Retinal_Blood_Vessel_Extraction_Based_on_a_Combination_of_Matched_Filter_and_Level_Set_Algorithm)  



# STEPS
### 1.	Original image:
![image](https://user-images.githubusercontent.com/21992001/188754702-1d785cd7-8c92-450f-bb70-609270eea34c.png)

### 2.	Green Channel:
![image](https://user-images.githubusercontent.com/21992001/188754721-5cd31039-4be8-4fbe-913a-81b1105fcebd.png)
 
### 3.	CLAHE (Contrast-limited adaptive histogram equalization):
![image](https://user-images.githubusercontent.com/21992001/188754739-2f9365f2-b302-449b-affe-426348a2684c.png)
 
### 4.	Vessel Enhancement:
using the vessel enhancement method in [1]. The authors in [1] present an algorithm based on iterated morphology operators. By using this filter inhomogeneities illumination are reduced, and the false edge around the optic disk is destroyed.

[1]	Heneghan, C., Flynn, J., O’Keefe, M., et al., Characterization of changes in blood vessel width and tortuosity in retinopathy of prematurity using image analysis. Medical image analysis, 2002. 6(4), pp. 407-429.

![image](https://user-images.githubusercontent.com/21992001/188754764-7b0f0a96-f5a6-4736-8cd6-90fe011e28a7.png)
 
### 5.	Enhanced Active Contour:
5.1. Adding Wavelet terms to the minimization energy formula to improve the performance of the algorithm

5.2. Optimization process

![image](https://user-images.githubusercontent.com/21992001/188756055-853d0129-0c73-4001-8124-517f256b5772.png)

**The result of the active contour:**

![image](https://user-images.githubusercontent.com/21992001/188756944-fc158b81-bfec-4ebc-b99a-2fd6b8c71227.png)
 
### 6.	Vessel Tree Generation:
![image](https://user-images.githubusercontent.com/21992001/188757163-e0dd7376-8563-4c07-8ced-da9987829621.png)

### 7.	Performance evaluation
We carry out the algorithm in MATLAB version R2014a on a personal computer running Windows 10 with an Intel(R) Core i5-7200U, the processor 2.5GHz and 8 GB of memory. The proposed algorithm is experimented on five public available datasets. The values achieved are 94.3%, 73.36%, and 97.41% for accuracy, sensitivity, and specificity, respectively, on the DRIVE dataset, and the proposed algorithm is comparable to the state-of-the-art approaches.

![image](https://user-images.githubusercontent.com/21992001/188757404-4d7e2356-d4fc-4f6a-86b4-2dc5e406d3ff.png)

*The top: Randomly chosen images from the DRIVE dataset. The middle: Segmentation results. The bottom: Expert's annotation.*


**Performance metrics on the DRIVE, STARE, HRF, CHASE DB1, and ARIA databases:**
![image](https://user-images.githubusercontent.com/21992001/188757447-7e44be60-17ec-41e1-81ff-e077caa46f16.png)

### 8.	Performance in the absence of the main vessels
There are main vessel pixels extremely more than thin vessel pixels, so sensitivity is not useful to indicate performance alone, and accuracy measures typically will be high. Therefore, we remove wide vessel pixels from images, and then, to show the performance of the proposed algorithm, are calculated evaluation metrics on the images without wide vessels. For this work, we need a new benchmark of DRIVE database in the absence of wide vessels. To remove wide vessels, used Canny detector. In the figure below is illustrated a randomly chosen benchmark of DRIVE and the corresponding new benchmark image. Afterward, we calculated the measures for all 20 images of the test set of the DRIVE dataset with new benchmark.

The average TPR is achieved at 0.4544, which means our algorithm can detect 45.44 percent of the thin vessel pixels. The average accuracy, FPR, and informedness are achieved at 0.9616, 0.0164, and 0.4387, respectively. In this section, we use a new measure called J index (or informedness) that is obtained as J = sensitivity + specificity – 1. F-score only considers two positive classes (precision and sensitivity), but the J index considers information from both positive and negative classes (sensitivity and specificity). The ability of the algorithms with informedness is better than TPR alone. 

(a) ![image](https://user-images.githubusercontent.com/21992001/188757663-5f71b8d0-3ac4-4707-b3bb-8aed35b7b52b.png) (b) ![image](https://user-images.githubusercontent.com/21992001/188757682-7b01de56-2dbf-49b9-b43d-89f5d6ca81bc.png)

 *(a) Expert's annotation. (b) The corresponding new benchmark that made by us.*


Basic Usage
===========
**Now RUN Demo_ActiveContoure.m and Enjoy it!**
