# zaĹ‚adowanie bibliotek
library(lsa)
#zmiana katologu roboczego
workDir <- "D:\\Adam_nowy\\TextMining\\TextMining"
setwd(workDir)

#definicja katalogu ze skryptami
scriptDir <- ".\\scripts"

#zaĹ‚adowanie skryptu
sourceFile <-  paste(scriptDir,
                     "frequency_matrix.R",
                     sep="\\"
)

source(sourceFile)

#analiza ukrytych wymiarów semantycznych (dekompozycja wg. wartości osobliwych)
lsa <- lsa(tdmTfidfBoundsMatrix)
lsa$tk #odpowiednik macierzy U, współrzędne wyrazów
lsa$dk #odpowiednik macierzy V, współrzędne dokumentu 
lsa$sk #odpowiednik macierzy T, znaczenie składowych

#przygotowanie danych do wykresu
coordTerms <- lsa$tk%*%diag(lsa$sk)
coordDocs <- lsa$dk%*%diag(lsa$sk)
terms <- c("harry", "czarodziej", "dumbledore", "hermiona", "ron", "komnata", "powiedzieć", "chcieć", "dowiadywać", "albus", "syriusz", "lupin", "umbridge", "edmund", "kaspian", "łucja", "czarownica", "piotr", "zuzanna", "aslana", "narnii", "baron", "dziecko", "wyspa", "bell", "edward", "wampir", "jacob")
coordTerms <- coordTerms[terms,]

#wykres dokuemntów i wyrbanych słóW w przestrzeni 
options(scipen = 5)
plot(
  coordDocs[,1],
  coordDocs[,2],
  # xlim = c(,),
  # ylim = c(,),
  pch = 1,
  col = "orange" 
)

points(
  coordTerms[,1],
  coordTerms[,2],
  col = "orange", 
  pos = 4
)

text(
  coordDocs[,1],
  coordDocs[,2],
  rownames(coordTerms),
  col = "orange", 
  pos = 4
)

text(
  coordTerms[,1],
  coordTerms[,2],
  paste("d", 1:19, sep = ""),
  col = "brown", 
  pos = 4
)











