# ALS_PLRNN_classification
# code supporting the results reported in "Classification of amyotrophic lateral sclerosis by brain volume, connectivity, and network dynamics" (Human Brain Mapping, 2021)
# by Thome, Janine; Steinbach, Robert; Grosskreutz, Julian; Durstewitz, Daniel; Koppe, Georgia

If you have any questions, please contact janine.thome@zi-mannheim.de

The individual classifiers (results section 3.1-3-3) can be replicated with the following scripts: classification_1* - classification_3*.m.
The multimodal classifiers (restults section 3.4-3.6) can be replicated with the following scripts: classification_4* - classification_7*.m.

The code uses the features stored in the files stored in the folder "feature_files", respectively. The relevant filename is specified in the respective code and does not need to be adjusted. 

To replicate the classifiers, you must first save all classifiers which you can find in the folder "Classifier_Manuscript" and specify the respective path in the each classifier script (marked in the code with add*).

To reproduce the figures displayed in the manuscript, use the respective code, which is stored in the folder "code_figures".
