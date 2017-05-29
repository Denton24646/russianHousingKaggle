# Sberbank Russian Housing Market kaggle competition

This repository holds all of the resources that were used in our participation in Kaggle's [Sberbank Russian Housing Market competition](https://www.kaggle.com/c/sberbank-russian-housing-market). Much of the code has been copied from the competition's kernels and discussion section, we claim no ownership over or credit for copied code.  
  
## Preprocessing

We take the original ```train.csv``` dataset and clean it using the copied scipt ```preprocessing/dataCleaning.ipynb``` which outputs ```cleaned_train.csv``` and ```cleaned_test.csv```. We then feed the cleaned datasets into the script ```trainFeatureEngineering.Rmd``` which outputs ```cleanedEngineeredTrain.csv``` and ```cleanedEngineeredTest.csv```. The ```macro_cleanup.R``` script takes in the ```macro.csv``` data, cleans it and outputs ```complete_macro_data.csv```. Finally, to create our fully cleaned and expanded train and test set the script ```mergeMacroAndCleanEngineeredTrainTest.R``` merges ```complete_macro_data.csv``` with ```cleanEngineeredTrain.csv``` and ```cleanEngineeredTest.csv``` to produce ```macroCleanEngineeredTrain.csv``` and ```macroCleanEngineeredTest.csv```.


