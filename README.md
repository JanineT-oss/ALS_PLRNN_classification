# ALS_PLRNN_classification
# code supporting the results reported in "Classification of amyotrophic lateral sclerosis by brain volume, connectivity, and network dynamics" (Human Brain Mapping, 2021)
# by Thome, J.; Steinbach, R.; Grosskreutz, J.; Durstewitz, D.; Koppe, G.

If you have any questions, please contact georgia.koppe@zi-mannheim.de or janine.thome@zi-mannheim.de

The individual classifiers (results section 3.1-3-3) can be replicated with the following scripts: classification_1* - classification_3*.m.
The multimodal classifiers (restults section 3.4-3.6) can be replicated with the following scripts: classification_4* - classification_7*.m.

The code uses the features stored in the files stored in the folder "feature_files", respectively. The relevant filename is specified in the respective code and does not need to be adjusted. 

To replicate the classifiers, please contact me so that I can send the classifiers presented in the paper (due to the size of the files, they could not be uploaded).

To reproduce the figures displayed in the manuscript, use the respective code, which is stored in the folder "code_figures".

To obtain an in-depth view on the extraction of the dynamics features please have a look at the script HBM_ALS_get_features_rsDyn.m
