# Sberbank Russian Housing Market kaggle competition

This repository holds all of the resources that were used in our participation in Kaggle's [Sberbank Russian Housing Market competition](https://www.kaggle.com/c/sberbank-russian-housing-market). Much of the code has been copied from the competition's kernels and discussion section, we claim no ownership over or credit for copied code.  
  
## Preprocessing

We take the original ```train.csv``` dataset and clean it using the copied scipt ```preprocessing/dataCleaning.ipynb``` which outputs ```cleaned_train.csv``` and ```cleaned_test.csv```. We then feed the cleaned datasets into the script ```trainFeatureEngineering.Rmd``` which outputs ```cleanedEngineeredTrain.csv``` and ```cleanedEngineeredTest.csv```. The ```macro_cleanup.R``` script takes in the ```macro.csv``` data, cleans it and outputs ```complete_macro_data.csv```. Finally, to create our fully cleaned and expanded train and test set the script ```mergeMacroAndCleanEngineeredTrainTest.R``` merges ```complete_macro_data.csv``` with ```cleanEngineeredTrain.csv``` and ```cleanEngineeredTest.csv``` to produce ```macroCleanEngineeredTrain.csv``` and ```macroCleanEngineeredTest.csv```.

We wrote ```forestFeatureImportance.ipynb``` to calculate the importance of features in our ```macroCleanEngineeredTrain.csv``` data set using a random forest model. We created the text file ```rfFeatureImportance.txt``` with the ranked list of feature importances.

## Model Selection

Several Models were used in our final submission including xgboost, linear regression, and a random forest. All models involved feature enginering and tuning hyperparameters to produce the best possible outcomes on an individual level. For example, the random forest was trained on an engineered test set with the numtrees and mtry settings adjusted depending the RMSLE result. For the linear regression the parameters were found by predicting on log(price_doc) to reduce variability. Both train and macro data sets were used to generate predictions from each model. 

On an individual level the models performed reasonably well, with xgboost and RF performing roughly in-line at about .325. The linear regression performed worse at about .37. Based on these results an ensemble approach was formed to get the most accurate results.

## Ensemble 

The first ensemble method was simply an intuitive average of the model outputs based on how well they performed. We were pleasantly surpised to see a big jump in performance to .321, enough to put us roughly in the top 50%. After that we performed an weighted average ensemble based on the RMSLE but this result proved worse than the intuitive averaging tried initially. More weighted averaging produced our final submission of .319 which placed us in the top 47%. 
