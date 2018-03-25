# Download ortholog from ensemble

# Download 1:1 ortholog genes from ensemble (human, chicken, platypus, opossum and anolis)
sed 's/,/\t/g' five_species_ortholog.txt | awk '{if($1~/ENS/ && $2~/ENS/ && $3~/ENS/ && $4~/ENS/ && $5~ /ENS/) print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5}' > five_species_ortholog.use

# Ensmble does not contain ortholog information between pogona with other species, therefore, we build a pipeline to extract this information.
# Run alignment between pogona with chicken and platypus
# First, extract exon coordinates from gff file, and save them into format that can be feed into bedtools 
awk '{if($3 == "exon") print }' Gallus_gallus.Galgal4.74.gtf > gallus_transcript.gff
perl format_change.pl gallus_transcript.gff > gallus_transcript.gff.use
awk '{if($3 == "exon") print }' Ornithorhynchus_anatinus.OANA5.74.gtf > platypus_transcript.gff
perl format_change.pl platypus_transcript.gff > platypus_transcript.gff.use
awk '{if($3 == "exon") print }' GCF_900067755.1_pvi1.1_genomic.gff | sed 's/;/\t/g; s/:/\t/g; s/,/\t/g' > GCF_900067755.1_pvi1.1_transcript.gff
awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $12 }' GCF_900067755.1_pvi1.1_transcript.gff > test
awk '{print $1 "\t" $2 "\t" $9 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 }' test2 > GCF_900067755.1_pvi1.1_transcript.gff.use

# Then use BEDTools to extract their exon sequences and merge exons with same gid
bedtools getfasta -fi Gallus_gallus.Galgal4.dna.toplevel.fa -bed gallus_transcript.gff.use -name -fo gallus_exon.fasta
bedtools getfasta -fi Ornithorhynchus_anatinus.OANA5.dna.toplevel.fa -bed platypus_transcript.gff.use  -name -fo platypus_exon.fasta
bedtools getfasta -fi GCF_900067755.1_pvi1.1_genomic.fna -bed GCF_900067755.1_pvi1.1_transcript.gff.use -name -fo pogona_ensemble_exon.fa

perl merge_exon_fasta.pl gallus_exon.fasta > gallus_exon.fasta.use
perl merge_exon_fasta.pl platypus_exon.fasta > platypus_exon.fasta.use 
perl merge_exon_fasta.pl pogona_ensemble_exon.fa > pogona_ensemble_exon.fa.use
sed -i 's/>/&bg_/' pogona_ensemble_exon.fa.use


# Run alignment between three species
# Chicken and pogona
blastn -query gallus_exon.fasta.use -subject pogona_ensemble_exon.fa.use  -word_size 9 -outfmt 6 -out blastn_gal_bg.out
blastn -query pogona_ensemble_exon.fa.use  -subject gallus_exon.fasta.use -word_size 9 -outfmt 6 -out blastn_bg_gal.out

# Platypus and pgona
blastn -query pogona_ensemble_exon.fa.use -subject platypus_exon.fasta.use -word_size 9 -outfmt 6 -out blastn_bg_oana.out
blastn -query platypus_exon.fasta.use -subject pogona_ensemble_exon.fa.use -word_size 9 -outfmt 6 -out blastn_oana_bg.out

# Chicken and Platypus
blastn -query gallus_exon.fasta.use -subject platypus_exon.fasta.use -word_size 9 -outfmt 6 -out blastn_gal_oana.out
blastn -query platypus_exon.fasta.use -subject gallus_exon.fasta.use -word_size 9 -outfmt 6 -out blastn_oana_gal.out

# Extract the ortholog gene id from alignment outputs
go build -o ./recip recip.go
cat blastn_bg_gal.out blastn_gal_bg.out | ./recip > uniq_bg_gal
cat blastn_bg_oana.out blastn_oana_bg.out | ./recip > uniq_bg_oana
cat blastn_gal_oana.out blastn_oana_gal.out | ./recip > uniq_oana_gal

# Extract common ortholog genes between three outputs above
awk '{ if (/^ENSOANG/) {print $0} else {print $2" "$1" "$3" "$4}}' uniq_bg_oana > uniq_oana_bg.use
awk '{ if (/^ENSOANG/) {print $0} else {print $2" "$1" "$3" "$4}}' uniq_oana_gal > uniq_oana_gal.use
awk '{ if (/^ENSGALG/) {print $0} else {print $2" "$1" "$3" "$4}}'  uniq_bg_gal > uniq_bg_gal.use
awk 'NR==FNR { n[$1] = $2; next } ($1 in n) {print $1, n[$1], $2}' uniq_oana_bg.use uniq_oana_gal.use > uniq_oana_bg_gal
awk '{print $3"\t"$1"\t"$2}' uniq_oana_bg_gal > uniq_oana_bg_gal2
awk 'NR==FNR { n[$1] = $2; next } ($1 in n) {print $1, n[$1], $2}' uniq_bg_gal.use uniq_oana_bg_gal2 > uniq_oana_bg_gal.use

# Merge pogona ortholog data with ensemble data
perl merge_ortho_id.pl uniq_oana_bg_gal.use five_species_ortholog.use > ortho_6species_new
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$7}' ortho_6species_new > ortho_6species_new.use

Use R to extract unique ortholog genes, code named ExtractUniqueOrthologGenes.R, output named ortholog_genes.unique
