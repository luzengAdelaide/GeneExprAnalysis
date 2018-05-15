#!/bin/bash

arr=('ano' 'bg' 'gal' 'oana' 'hg')
arr2=('dna' 'ervltr' 'line' 'sine')
arr3=('ano' 'bg' 'gal' 'oana' 'hg' 'mdo')

for i in "${arr[@]}"
do
    for j in "${arr2[@]}"
    do
	echo ortho_bed_$i $i\_recent_$j.use
	intersectBed -a ortho_bed_$i -b $i\_recent_$j.use > overlap_recent_$i\_$j
    done
done

for i in "${arr2[@]}"
do
    # Separate opossum genome into small and large ones, as intersectBed cannot handle data with bigger than 500000000
    perl extract_large_coordinates_gene.pl ortho_bed_mdo 
    perl extract_large_coordinates_gene.pl mdo_recent_TE.use
    intersectBed -a large_ortho_bed_mdo -b large_mdo_recent_$i.use > large.overlap_recent_mdo_$i
    intersectBed -a small_ortho_bed_mdo -b small_mdo_recent_$i.use > small.overlap_recent_mdo_$i
    cat large.overlap_recent_mdo_$i small.overlap_recent_mdo_$i > overlap_recent_mdo_$i
done

for i in overlap_*
do
    awk '{if(($3-$2)>50) print}' $i > use.$i
    perl ../delete.same.coordi.pl use.$i > uniq.$i
done

for i in "${arr3[@]}"
do
    for j in "${arr2[@]}"
    do
	awk '{print $4}' uniq.overlap_recent_$i\_$j > recent_$i\_$j\_ortho
    done
done
