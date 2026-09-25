SRB_District_COVID_ED_Analysis

COVID-19, Excess Mortality, and District-Level Characteristics in Serbia

This repository contains the datasets, data-transformation scripts, correlation analyses, and regression models used to investigate the associations between COVID-19 mortality, excess mortality, and demographic, socioeconomic, health, and environmental characteristics across districts of Serbia.

Repository Contents

1. `SRB_District_COVID.mat`

Original, non-transformed dataset containing district-level variables for Serbia.

This dataset represents the initial analytical database before statistical transformations and outlier handling.


2. `SRB_District_COVID_ED_Transformed.mat`

Transformed dataset used for the statistical analyses of COVID-19 mortality and excess mortality.

Variables were transformed where appropriate to improve distributional properties and satisfy assumptions of subsequent statistical analyses.

3. `SRB_District_COVID_EDandCOVID_Transformation`

MATLAB transformation scripts used for preprocessing the excess-mortality variables.

The scripts include:

* transformation of skewed variables;
* identification and handling of outliers;
* generation of the final transformed variables in new .mat file used in the analyses.

4. `Districts_initial_Spearman_correlation`

Initial Spearman rank-correlation analyses between district-level excess-mortality candidate explanatory variables.

The analyses include:
* Spearman correlation coefficients;
* corresponding p-values;
* correlation matrices;
* district ranking for gathered predictors

  
5. `Districts_SRB_Initial_Models`

Initial regression analyses performed at the district level.
1. Univariable models
2. Age-adjusted models
3. Multivariable domain-specific models

