# Madini - Elements to Minerals Inversion

This code is a fixable modification of De Caritat et al (1994) algorithm to estimate the percentage of different minerals in a rock based on some element measurements (e.g., x-ray fluorescence measurements). 

<div align="center">
    <img width=800 src="https://github.com/MosGeo/Madini/blob/master/ReadmeFiles/Snapshot.png" alt="Snapshot" title="Snapshot of software"</img>
</div>


## How to use
The code can be ran without interface in matlab as part of your normal script (check the notebook for example). You can also ran the interface in matlab. Finally, if you do not have Matlab, you can run the excutable (note that you might have to download and install a free Matlab runtime).

## How does it work

The algorithms uses linear optimization to solve for the best mineral combination. Slack variables are used to account for unknown minerals in the rock. Note that the estimation are mass proportions (not volumetric proportions). 

## Referencing
Please reference the two referneces below:

Al Ibrahim, M. A., and Mukerji, T., 2017, Thermal maturation effects on the elastic properties of organic-rich mudrocks: Presented at the SEG International Exposition and 87th Annual Meeting, 6 p. [link](https://library.seg.org/doi/abs/10.1190/segam2017-17790635.1)

De Caritat, P., Bloch, J., and Hutcheon, I, 1994, LPNORM: A linear programming normative analysis code: Computer and Geosciences, v. 20, no. 3, p. 313-347.
