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
