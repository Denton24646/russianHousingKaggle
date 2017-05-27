# Small script to merge our cleanEngineeredTrain/Test sets and the full set of macroeconomic features.

setwd("~/projects/russianHousingKaggle")
macro = read.csv("data/macro.csv", header = TRUE)
train = read.csv("data/cleanEngineeredTrain.csv")
test = read.csv("data/cleanEngineeredTest.csv")

mergedTrain = merge(macro, train, by = 'timestamp')
print(length(colnames(macro)) + length(colnames(train)) - 1 == length(mergedTrain))

mergedTest = merge(macro, test, by = 'timestamp')
print(length(colnames(macro)) + length(colnames(test)) - 1 == length(mergedTest))

write.csv(mergedTrain, file = "data/macroCleanEngineeredTrain.csv")
write.csv(mergedTest, file = "data/marcroCleanEngineeredTrest.csv")