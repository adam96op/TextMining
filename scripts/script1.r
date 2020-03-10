#wlaczenie biblioteki
library (tm)

#zmiana katologu roboczego
workDir <- "D:\\AP\\TextMining"
setwd(workDir)

#definicja katalogu projektu
inputDir <- ".\\data"
outputDir <-".\\result"
scriptDir <- ".\\scripts"
workspaceDir <-".\\workspaces"
dir.create(outputDir, showWarnings = TRUE)
dir.create(workspaceDir, showWarnings = TRUE)
#utworzenie korpusu dokumentów

corpusDir <-  paste(inputDir,"\\","Literatura - streszczenia - oryginał",sep="")
corpus <- VCorpus(
  DirSource(corpusDir,
      pattern="*.txt",
      encoding="UTF-8"
  ),
 
  readerControl = list(
    language = "pl_PL"
  )
  
)

#dostępne przetwarzanie

corpus <-tm_map(corpus, removeNumbers)
corpus <-tm_map(corpus, removePunctuation)
corpus <-tm_map(corpus, content_transformer(tolower))
stoplistFile <- corpusDir <-paste(inputDir,"\\","stopwords_pl.txt",sep="")
stoplist <-readLines(
  stoplistFile,
  encoding="UTF-8"
)

corpus <-tm_map(corpus, removeWords, stoplist)
corpus <-tm_map(corpus, stripWhitespace)

writeLines(as.character(corpus[[1]]))
writeLines(corpus[[1]]$content)





