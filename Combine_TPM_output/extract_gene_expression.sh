#!/bin/bash

arr=( 'bdg' 'gal' 'hgs' 'oan' 'mdo' 'ano')

##############################
####### Ortholog data ########
##############################

# Merge all FPKM output into one file based on each species 
for i in bdg.*
do
    echo $i
    perl merge_same_bgid.pl $i ortholog_genes.unique > use.$i
    awk '{print $6 "\t" $12}' use.$i  > tmp.use.$i
    sed -i '1s/^/'bdg'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
perl merge_same_bgid.pl bdg.br.F.1 ortholog_genes.unique > use.bdg.br.F.1
awk '{print $7"\t"$10}' use.bdg.br.F.1 > length_ortho_bdg

for i in gal.*
do
    echo $i
    perl merge_same_galid.pl $i ortholog_genes.unique > use.$i 
    awk '{print $2 "\t" $12}' use.$i  > tmp.use.$i
    sed -i '1s/^/'gal'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
perl merge_same_galid.pl gal.br.F.1 ortholog_genes.unique > use.gal.br.F.1
awk '{print $7"\t"$10}' use.gal.br.F.1 > length_ortho_gal

for j in mdo.*
do
    echo $j
    perl merge_same_mdoid.pl $j ortholog_genes.unique > use.$j
    awk '{print $4 "\t" $12}' use.$j > tmp.use.$j
    sed -i '1s/^/'mdo'\t'$j'\n/' tmp.use.$j
done

# Extract effective length
perl merge_same_mdoid.pl mdo.br.F.1 ortholog_genes.unique > use.mdo.br.F.1
awk '{print $7"\t"$10}' use.mdi.br.F.1 > length_ortho_mdo

for m in oan.*
do
    echo $m
    perl merge_same_oanid.pl $m ortholog_genes.unique > use.$m
    awk '{print $5 "\t" $12}' use.$m > tmp.use.$m
    sed -i '1s/^/'oan'\t'$m'\n/' tmp.use.$m
done

# Extract effective length
perl merge_same_oanid.pl oan.br.F.1 ortholog_genes.unique > use.oan.br.F.1
awk '{print $7"\t"$10}' use.oan.br.F.1 > length_ortho_oan

for m in hgs.*
do
    echo $m
    perl merge_same_hgid.pl $m ortholog_genes.unique > use.$m
    awk '{print $1 "\t" $12}' use.$m > tmp.use.$m
    sed -i '1s/^/'hgs'\t'$m'\n/' tmp.use.$m
done

# Extract effective length
perl merge_same_hgid.pl hgs.br.F.1 ortholog_genes.unique > use.hgs.br.F.1
perl test.pl use.hgs.br.F.1 > length_ortho_hgs


for m in ano.*
do
    echo $m
    perl merge_same_anoid.pl $m ortholog_genes.unique > use.$m
    awk '{print $3 "\t" $12}' use.$m > tmp.use.$m
    sed -i '1s/^/'ano'\t'$m'\n/' tmp.use.$m
done

# Extract effective length
perl merge_same_anoid.pl ano.br.F.1 ortholog_genes.unique > use.ano.br.F.1
awk '{print $7"\t"$10}' use.ano.br.F.1 > length_ortho_ano

# Merge all species expression outputs into one file
for n in "${arr[@]}"
do
    echo $n
    ulimit -Hn 10240
    ulimit -Sn 10240 
    # Awk use to print file column with first column and even column
    # Calculate how many columns in one file: head -n 1 FILE | awk '{print NF}'
    paste tmp.use.$n.* |awk '{for(x=1;x<=NF;x++)if(x % 2 == 0 || x==1)printf "%s", $x (x == NF || x == (NF-1)?"\n":"\t")}'  > total_$n
done
paste total_* > total_ortholog_TPM

rm tmp.use.*
rm use.*

# Rearrange columns order
awk '{print $1"\t"$32"\t"$47"\t"$79"\t"$108"\t"$138"\t"$0}' total_ortholog_TPM | cut -f1-6,8-37,39-52,54-84,86-113,115-143,145- > total_ortholog_TPM_6species



##############################
####### All gene data ########
##############################
# Combine all the expression genes, not just ortholog
arr2=( 'bdg' 'gal' 'hgs' 'oan' 'mdo' 'ano' 'bdg2')

for i in bdg.*
do
    echo $i
    sed 1d $i > use.$i
    awk '{print $1 "\t" $6}' use.$i  > tmp.use.$i
    sed -i '1s/^/'bdg'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
awk '{print $1"\t"$4}'  bdg.br.F.1 > length_bdg_TPM

for i in gal.*
do
    echo $i
    sed 1d $i > use.$i
    awk '{print $1 "\t" $6}' use.$i  > tmp.use.$i
    sed -i '1s/^/'gal'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
awk '{print $1"\t"$4}'  gal.br.F.1 > length_gal_TPM

for i in mdo.*
do
    echo $i
    sed 1d $i > use.$i
    awk '{print $1 "\t" $6}' use.$i > tmp.use.$i
    sed -i '1s/^/'mdo'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
awk '{print $1"\t"$4}'  mdo.br.F.1 > length_mdo_TPM

for i in oan.*
do
    echo $i
    sed 1d $i > use.$i
    awk '{print $1 "\t" $6}' use.$i > tmp.use.$i
    sed -i '1s/^/'oan'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
awk '{print $1"\t"$4}'  oan.br.F.1 > length_oan_TPM

for i in hgs.*
do
    echo $i
    sed 1d $i > use.$i
    awk '{print $1 "\t" $6}' use.$i > tmp.use.$i
    sed -i '1s/^/'hgs'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
awk '{print $1"\t"$4}'  hgs.br.F.1 > length_hgs_TPM

for i in ano.*
do
    echo $i
    sed 1d $i > use.$i
    awk '{print $1 "\t" $6}' use.$i > tmp.use.$i
    sed -i '1s/^/'ano'\t'$i'\n/' tmp.use.$i
done

# Extract effective length
awk '{print $1"\t"$4}'  ano.br.F.1 > length_ano_TPM


for n in "${arr2[@]}"
do
    echo $n
    ulimit -Hn 10240
    ulimit -Sn 10240 
    # Awk use to print file column with first column and even column
    # Calculate how many columns in one file: head -n 1 FILE | awk '{print NF}'
    paste tmp.use.$n.* |awk '{for(x=1;x<=NF;x++)if(x % 2 == 0 || x==1)printf "%s", $x (x == NF || x == (NF-1)?"\n":"\t")}'  > total_$n\_expr
done
paste total_*_expr > total_allgenes_TPM

rm tmp.use.*
rm use.*

# Rearrange columns order
awk '{print $1"\t"$32"\t"$47"\t"$79"\t"$108"\t"$138"\t"$0}' total_allgenes_TPM | cut -f1-6,8-37,39-52,54-84,86-113,115-143,145- > total_allgenes_TPM_6species

