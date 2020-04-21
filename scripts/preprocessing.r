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
#utworzenie korpusu dokumentĂłw

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

#usunięcie z tekstów podziału na akapity
pasteParagraphs <- content_transformer(function(x,char) paste(x, collapse = char))
coprus <- tm_map(corpus, pasteParagraphs, " ")

#dostÄ™pne przetwarzanie

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

#usunięcie em dash i 3/4

remove_char <- content_transformer(function(x,pattern) gsub(pattern, "", x))
corpus <- tm_map(corpus, remove_char, inToUtf8(8722))
corpus <- tm_map(corpus, remove_char, inToUtf8(190))


polish <- dictionary(lang="pl_PL")

lemmatize <- function(text) {
  
  simple_text <- str_trim(as.character(text))
  parsed_text <- strsplit(simple_text, split =" ")
  new_text_vec <- hunspell_stem(parsed_text[[1]], dict=polish)
  for ( i in 1:length(new_text_vec)) {
    
    if(length(new_text_vec[[1]]) == 0) new_text_vec[i] <- parsed_text[[1]][i]
    if(length(new_text_vec[[1]]) > 1) new_text_vec[i] <- parsed_text[[i]][1]
  }
  new_text <- paste(new_text_vec, collapse = " ")  
  return(new_text)
  
}

corpus <- tm_map(corpus, content_transformer(lemmatize))

# usunięcie rozszerzenia z nazw plików
cut_extensions <- function(document){
  
  meta(document, "id") <- gsub(pattern = "\\.txt$", replacement= "", meta(document, "id"))
  return(document)
}

corpus <- tm_map(corpus, cut_extensions)

# eksport zawartości korpusu do plików tekstowych

preprocessedDir <- paste(outputDir, "Literatura - streszczenia - przetworzone",sep="\\")
dir.create(preprocessedDir)
writeCorpus(corpus, path = preprocessedDir)

  
writeLines(as.character(corpus[[1]]))
writeLines(corpus[[1]]$content)





