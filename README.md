# Madini - Elements to Minerals Inversion

This code is a fixable modification of De Caritat et al (1994) algorithm to estimate the percentage of different minerals in a rock based on some element measurements (e.g., x-ray fluorescence measurements). The algorithms uses linear optimization to solve for the best mineral combination. Slack variables are used to account for unknown minerals in the rock. Note that the estimation are mass proportions (not volumetric proportions). 

