import pandas as pd
import numpy as np

print("running python transformation")
# extract processed data from https://doi.org/10.5061/dryad.4ss043q and https://github.com/ivangtorre/physical-origin-of-lw
input_path = 'TablaTranscripcion.csv'

# Cargar datos
tabla_datos = pd.read_csv(input_path, delimiter=",", skiprows=2,
                          names=['token', 'tinit', 'tend', 'duration', 'sentence', 'path', 'tipe', 'numtoken', 'numphonemes',
                                 'numletters'])
SentenceSize_numwords = []
WordsSize_numletters = []
WordsSize_numphonemes = []  # Para la definicion2
WordsSize_seconds = []  # Para la definicion3

for sentence in tabla_datos.sentence.unique():
    tablaSentence = tabla_datos[tabla_datos.sentence == sentence]
    numwords = len(tablaSentence[tablaSentence.tipe == "w"])
    SentenceSize_numwords.append(numwords)

    numletters_mean = np.mean(tablaSentence[tablaSentence.tipe == "w"].numletters)
    WordsSize_numletters.append(numletters_mean)

    # Para la definicion2
    numphonemes_mean = np.mean(tablaSentence[tablaSentence.tipe == "w"].numphonemes)
    WordsSize_numphonemes.append(numphonemes_mean)

    # Para la definicion3
    word_duration_mean = np.mean(tablaSentence[tablaSentence.tipe == "w"].duration)
    WordsSize_seconds.append(word_duration_mean)

# extract data
df1 = pd.DataFrame(list(zip(SentenceSize_numwords, WordsSize_numletters)), columns=['x', 'y'])
df2 = pd.DataFrame(list(zip(SentenceSize_numwords, WordsSize_numphonemes)), columns=['x', 'y'])
df3 = pd.DataFrame(list(zip(SentenceSize_numwords, WordsSize_seconds)), columns=['x', 'y'])

df1.to_csv("1.csv", index=False)
df2.to_csv("2.csv", index=False)
df3.to_csv("3.csv", index=False)
