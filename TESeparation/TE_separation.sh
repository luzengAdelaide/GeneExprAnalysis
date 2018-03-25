#!/bin/bash

# Separate CENSOR output into specific TE types

arr=('ano' 'hg' 'oana' 'mdo' 'bg' 'gal')

for i in "${arr[@]}"
do
    echo $i
    perl map_to_bed.pl $i\_censor_new.map > bed_$i.map
    sed 's/\*/\t/g' bed_$i.map > bed_$i.map.tmp
    awk '{if($5=="CR1" || $5=="L2" || $5=="L1" || $5=="RTE" || $5=="Penelope" || $5=="RTEX" || $5=="Tx1" || $5=="R4" || $5=="Vingi" || $5=="Rex1" || $5=="Daphne") print $1"\t"$2"\t"$3"\t"$4}' bed_$i.map.tmp> bed.line.$i
    awk '{if($5=="SINE" || $5=="SINE2/tRNA" || $5=="SINE1/7SL" || $5=="SINE3/5S"|| $5=="SINE4" || $5=="SINEU/snRNA") print $1"\t"$2"\t"$3"\t"$4}' bed_$i.map.tmp > bed.sine.$i
    awk '{if($5=="hAT" || $5=="DNA" || $5=="Mariner/Tc1" || $5=="MuDR" || $5=="EnSpm/CACTA" || $5=="piggyBac" || $5=="P" || $5=="Merlin" || $5=="Harbinger" || $5=="Transib"|| $5=="Novosib"|| $5=="Helintron"|| $5=="Polinton"|| $5=="Kolobok" || $5=="ISL2EU" || $5=="Crypton" ||$5=="Sola" || $5=="Zator" || $5=="Ginger1" || $5=="Ginger2/TDD" || $5=="Academ" || $5=="Zisupton" || $5=="IS3EU" || $5=="Dada" || $5=="Chapaev") print $1"\t"$2"\t"$3"\t"$4}' bed_$i.map.tmp > bed.dna.$i
    awk '{if($5=="ERV1" || $5=="ERV2" || $5=="ERV3" || $5=="ERV4" || $5=="Endogenous" || $5=="Lentivirus" || $5=="LTR" || $5=="Gypsy" || $5=="Copia" || $5=="DIRS" || $5=="BEL") print $1"\t"$2"\t"$3"\t"$4}' bed_$i.map.tmp > bed.ervltr.$i
done
