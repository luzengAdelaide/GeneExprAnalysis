# Load R packages
library("phyloseq")

#### PCA Analysis ###

# Load data
setwd("~/Desktop/gene_expression/ClusterAnalysis/")
ortholog_new <- read.delim("total_ortholog_TPM_6species", sep="\t", header=T)
ortholog_new_use <- log2(ortholog_new[,7:ncol(ortholog_new)]+1)

########  PCA 
speciesName <- substring(colnames(ortholog_new_use),1,3)
organName <- substring(colnames(ortholog_new_use),5,6)

pca_ortholog_new <- prcomp(t(ortholog_new_use), scale. = TRUE)
plot(pca_ortholog_new$x[,1:2], pch = as.numeric(as.factor(speciesName)), 
     col = as.factor(organName),
     main = "PCA Analysis",
     xlab = "PC1 (explained variance, 28.75%)",
     ylab = "PC2 (explained variance, 8.62%)") 
legend("topright", title="Organs",
       legend=c("Brain", "Heart", "Kidney", "Liver", "Ovary","Testis"),
       fill=seq_along(levels(as.factor(organName))), bty="n")
legend("bottomright", title="Species",
       legend=c( "Anolis", "Chicken", "Human", "Opossum", "Platypus"),
       pch=1:6, bty="n")

######## hClust
# Ward2 Clustering
hClust <- hclust(dist(t(scale(ortholog_new_use))), method = "ward.D2")
clus7 = cutree(hClust, 7)
mypal = c("#FF6B6B", "#4ECDC4", "#556270", "darkblue", "darkred", "pink","purple")
op = par(bg = "white")
plot(as.phylo(hClust), type = "fan", tip.color = mypal[clus7], label.offset = 0.1, col = "red")

# UPGMA Clutering
hClust <- hclust(dist(t(scale(ortholog_new_use))), method = "average")
clus7 = cutree(hClust, 5)
mypal = c("#FF6B6B", "#4ECDC4", "#556270", "darkblue", "darkred", "pink","purple")
op = par(bg = "white")
plot(as.phylo(hClust), type = "fan", tip.color = mypal[clus7], label.offset = 0.1, col = "red")
