#wlaczenie biblioteki
library (tm)
library (stringr)

#zmiana katologu roboczego
workDir <- "D:\\Adam_nowy\\TextMining\\TextMining"
setwd(workDir)

#definicja katalogu projektu
inputDir <- ".\\data"
outputDir <-".\\result"
workspaceDir <-".\\workspaces"
dir.create(outputDir, showWarnings = TRUE)
dir.create(workspaceDir, showWarnings = TRUE)
#utworzenie korpusu dokumentÄ‚Ĺ‚w

corpusDir <-  paste(inputDir,"\\","Literatura - streszczenia - przetworzone",sep="")
corpus <- VCorpus(
  DirSource(corpusDir,
            pattern="*.txt",
            encoding="UTF-8"
  ),
  
  readerControl = list(
    language = "pl_PL"
  )
  
)


# usuniÄ™cie rozszerzenia z nazw plikĂłw
cut_extensions <- function(document){
  
  meta(document, "id") <- gsub(pattern = "\\.txt$", replacement= "", meta(document, "id"))
  return(document)
}

corpus <- tm_map(corpus, cut_extensions)

#utworzenie macierzy gÄ™stoĹ›ci
tdmTfall <- TermDocumentMatrix(corpus)
dtmTfall <- DocumentTermMatrix(corpus)
tdmBinAll <- TermDocumentMatrix(
  corpus,
  control = list(
    weighing = weightBin
  )
)

tdmTfidfAll <- TermDocumentMatrix(
  corpus,
  control = list(
    weighing = weightTfIdf
  )
)

tdmTfBounds <- TermDocumentMatrix(
  corpus,
  control = list(
    bounds = list(
      global = c(2,16)
    )
  )
)

tdmTfidfBounds <- TermDocumentMatrix(
  corpus,
  control = list(
    weighing = weightTfIdf,
    bounds = list(
      global = c(2,16)
    )
  )
)
  
  dtmTfidfBounds <- TermDocumentMatrix(
    corpus,
    control = list(
      weighing = weightTfIdf,
      bounds = list(
        global = c(2,16)
      )
    )  
  
)
  
  #konwersja macierzy rzadkich do macierzy klasycznych

  tdmTfallMatrix <- as.matrix(tdmTfall)
  dtmTfallMatrix <- as.matrix(dtmTfall)
  tdmBinAllMatrix <- as.matrix( tdmBinAll)
  tdmTfidfAllMatrix <- as.matrix(tdmTfidfAll)
  tdmTfBoundsMatrix <- as.matrix(tdmTfBounds)
  tdmTfidfBoundsMatrix  <- as.matrix(tdmTfidfBounds)
  dtmTfidfBoundsMatrix <- as.matrix(dtmTfidfBounds)
  
  #eskport macierzy gÄ™stoĹ›ci do pliku .csv
  matrixFile <- paste(outputDir,
                    "tdmTfBounds.csv",
                     sep="\\")
  
#  write.table(
#   tdmTfidfBoundsMatrix,
#    file = matrixFile,
#    sep = ";",
#    dec = ",",
#    col.names = NA
#  )





