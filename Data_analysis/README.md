#### Processing and statistical analyses of aerobic step data

#### 1. Introductory information
Aerobic step data processing: Data_IER_processed.m

This MATLAB file processed the original dataset (Data_IER.csv, retrieved from BrightSpace) and contains statistical analyses. 

For questions about the data processing and analyses, contact s.h.a.mohammad@student.tudelft.nl

#### 2. Methodological information
The file Data_IER_proc.m has been created on MATLAB version R2020b and requires the Statistics and Machine Learning Toolbox.
The data set processed with the following steps:

0) Load Data_IER.csv, file is retrieved from BrightSpace in 'Topic Specific Content'.
1) Filter columns to keep demographics,aerobic step data and whether the pedometer was worn for longer than 10 hours.
2) Filter rows to keep 2020 data only.
3) Replace all 'Yes' by the value '1' in the wear columns. Anything that is not 'Yes' becomes 'NaN' in the wear columns.
4) Replace 'NaN' by the value '0'.
5) Count for each participant how many 'Yes' is present (by summing 1's).
6) Only participants with 4 or more will advance in the selection.
7) Remove any aerobic step activity for each specific day a participant stated that the pedometer was worn less than 10 hours.
8) Average the total aerobic steps by how many days a participant has worn the pedometer for more than 10 hours.
9) Divide the selection by two samples: 'Moved out' group (MO) and 'Living with parents' group (LP).

The statistical analyses is as follow:

1) For aerobic steps check for each sample group the data distribution by means of histograms (Figure 1).
2) For non-parametric distributions a Mann-Whitney U test (Wilcocon rank sum test) was used to compare the medians of both sample groups.
3) The variables h and p contain the results of the statistical test.
4) Fit the Body Mass Index (BMI) of each sample group as normally distributed.
5) Retrieve means and confidence intervals of BMI distributions of each sample group.

The tables are constructed as follow:

T_1 contains the demographics(gender). The percentage of males, females and undefined gender have been manually calculated from variables 'moved_out' and 'living_at_parents' respectively.
T_2 contains the BMI and included a t-test to retrief the p value to compare both sample groups.
T_3 contains the aerobic step data (median), the previously mentioned Mann-Whitney U test and its p value. 

#### 3. Data specific information

Abbreviations:

aer: aerobic steps
avg: average
BMI: Body Mass Index (kg*m^-2)
dem: demographics
LP: living with parents
MO: moved out
SD: standard deviation
wear: pedometer worn more than at least 10 hours


#### 4. Sharing and Access information
The participants have given consent for the re-use of the data (Data_IER.csv) for educational purposes. Therefore the data can be used for only this purpose. Do not share the data with others.

#### 5. Authors
S. H. A. Mohammad, “Processing and statistical analyses of aerobic step data,” https://github.com/shamohammad/IER_2022.git, 2022.