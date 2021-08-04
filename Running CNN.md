# Running CNN.ipynb
## Generate CNN-dataset.pkl
* If the directory `otherLargeFiles` doesn't exist, create it now
* In `CNN-dataset-generator.ipynb`, in cell [2], set nDrives to the number of drives you want included in the dataset (this will act as an upper limit because some drives will be throw away due to their short length)
* Run all but the last two cells in `CNN-dataset-generator.ipynb`
## Run Neural Net
* In `CNN.ipynb`, run the first two cells, letting the the second cell error because of the missing .pkl file.
* Then, run the last two cells of `CNN-dataset-generator.ipynb`
* Run other cells in `CNN.ipynb`