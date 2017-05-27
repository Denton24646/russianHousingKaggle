# Sberbank Russian Housing Market kaggle competition

This repository holds all of the resources that were used in our participation in Kaggle's [Sberbank Russian Housing Market competition](https://www.kaggle.com/c/sberbank-russian-housing-market). Much of the code has been copied from the competition's kernels and discussion section, we claim no ownership over or credit for copied code.  
  
## Preprocessing

### training data

We take the original ```train.csv``` dataset and clean it using the copied scipt ```preprocessing/dataCleaning.ipynb``` which outputs ```cleaned_train.csv``` and ```cleaned_test.csv```. We then feed the cleaned datasets into copied script ```trainFeatureEngineering.Rmd``` which outputs ```cleanedEngineeredTrain.csv``` and ```cleanedEngineeredTest.csv```. This gives us cleaned and feature-expanded train and test data which we will then analyze before finally using it in our models.
