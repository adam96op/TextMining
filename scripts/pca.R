# zaĹ‚adowanie bibliotek

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

#analiza głównych składowych
pca <- prcomp(dtmTfidfBounds)

#eksport wykresu do pliku .png
plotFile <-  paste(outputDir,
                     "pca.png",
                     sep="\\"
)
png(file=plotFile)
options(scipen = 5)
plot(
  pca$x[,1],
  pca$x[,2],
 # xlim = c(,),
 # ylim = c(,),
  pch = 1,
  col = "orange" 
  )

text(
  pca$x[,1],
  pca$x[,2],
  paste("d", 1:19, sep = ""),
  col = "orange", 
  pos = 4
)
legend(0.01, 0.05, legend, text.font = 3, cex = 0.5, text.col = "orange")
dev.off()







