#wlaczenie biblioteki
library (tm)
library (hunspell)
library (stringr)

#zmiana katologu roboczego
workDir <- "D:\\Adam_nowy\\TextMining\\TextMining"
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

#usuni�cie em dash i 3/4

remove_char <- content_transformer(function(x,pattern) gsub(pattern, "", x))
corpus <- tm_map(corpus, remove_char, inToUtf8(8722))
corpus <- tm_map(corpus, remove_char, inToUtf8(190))


polish <- dictionary(lang="pl_PL")

lemmatize <- function(text) {
  
  simple_text <- str_trim(as.character(text))
  parsed_text <- strsplit(simple_text, split =" ")
  new_text_vec <- hunspell_stem(parsed_text[[1]], dict=polish)
  for ( i in 1:length(new_text_vec)) {
    
    if(lenght(new_text_vec[[1]]) == 0) new_text_vec[i] <- parsed_text[[1]][i]
    if(lenght(new_text_vec[[1]]) > 1) new_text_vec[i] <- parsed_text[[i]][1]
  }
  new_text <- paste(new_text_vec, collapse = " ")  
  return(new_text)
  
}

corpus <- tm_map(corpus, content_transformer(lemmatize))

# usuni�cie rozszerzenia z nazw plik�w
cut_extensions <- function(document){
  
  meta(document, "id") <- gsub(pattern = "\\.txt$", replacement= "", meta(document, "id"))
  return(document)
}

corpus <- tm_map(corpus, cut_extensions)

# eksport zawarto�ci korpusu do plik�w tekstowych

preprocessedDir <- paste(outputDir, "Literatura - streszczenia - oryginał",sep="\\")
dir.create(preprocessedDir)
writeCorpus(corpus, path = preprocessedDir)

  
writeLines(as.character(corpus[[1]]))
writeLines(corpus[[1]]$content)





