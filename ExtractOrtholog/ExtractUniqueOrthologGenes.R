# Delete ortholog genes that have multiple matches to other species. 
# For example (we will remove ENSG00000101160, as it matches with different anolis ortholog genes):
# ENSG00000101160 ENSGALG00000007462      ENSACAG00000001153      ENSMODG00000016601      ENSOANG00000009274      110084731
# ENSG00000101160 ENSGALG00000007462      ENSACAG00000001112      ENSMODG00000016601      ENSOANG00000009274      110084731

ortholog_genes <- read.table("ortho_6species_new.use", sep="\t", header=F)
hg.id = as.character(ortholog_genes$V1)
hg.table = as.data.frame(table(hg.id))
hg.table.unique = hg.table[hg.table$Freq < 2, ]
hg.table.unique.id = as.character(hg.table.unique$hg.id)
ortholog_genes.hg = ortholog_genes[as.character(ortholog_genes$V1) %in% hg.table.unique.id, ]

gal.id = as.character(ortholog_genes.hg$V2)
gal.table = as.data.frame(table(gal.id))
gal.table.unique = gal.table[gal.table$Freq < 2, ]
gal.table.unique.id = as.character(gal.table.unique$gal.id)
ortholog_genes.gal = ortholog_genes.hg[as.character(ortholog_genes.hg$V2) %in% gal.table.unique.id, ]

ano.id = as.character(ortholog_genes.gal$V3)
ano.table = as.data.frame(table(ano.id))
ano.table.unique = ano.table[ano.table$Freq < 2, ]
ano.table.unique.id = as.character(ano.table.unique$ano.id)
ortholog_genes.ano = ortholog_genes.gal[as.character(ortholog_genes.gal$V3) %in% ano.table.unique.id, ]

oan.id = as.character(ortholog_genes.ano$V4)
oan.table = as.data.frame(table(oan.id))
oan.table.unique = oan.table[oan.table$Freq < 2, ]
oan.table.unique.id = as.character(oan.table.unique$oan.id)
ortholog_genes.oan = ortholog_genes.ano[as.character(ortholog_genes.ano$V4) %in% oan.table.unique.id, ]

mdo.id = as.character(ortholog_genes.oan$V5)
mdo.table = as.data.frame(table(mdo.id))
mdo.table.unique = mdo.table[mdo.table$Freq < 2, ]
mdo.table.unique.id = as.character(mdo.table.unique$mdo.id)
ortholog_genes.mdo = ortholog_genes.oan[as.character(ortholog_genes.oan$V5) %in% mdo.table.unique.id, ]

bdg.id = as.character(ortholog_genes.mdo$V6)
bdg.table = as.data.frame(table(bdg.id))
bdg.table.unique = bdg.table[bdg.table$Freq < 2, ]
bdg.table.unique.id = as.character(bdg.table.unique$bdg.id)
ortholog_genes.bdg = ortholog_genes.mdo[as.character(ortholog_genes.mdo$V6) %in% bdg.table.unique.id, ]

write.table(ortholog_genes.bdg, file = "ortholog_genes.unique.txt", quote = F, sep = "\t", col.names = F, row.names = F)

