#!/bin/bash

arr=('ano' 'bg' 'gal' 'oana' 'hg')
arr2=('dna' 'ervltr' 'line' 'sine')
arr3=('ano' 'bg' 'gal' 'oana' 'hg' 'mdo')

for i in "${arr[@]}"
do
    for j in "${arr2[@]}"
    do
	echo ortho_bed_$i bed.$j.$i
	intersectBed -a ortho_bed_$i -b bed.$j.$i > overlap_all_$i\_$j
    done
done

for i in "${arr2[@]}"
do
    # Separate opossum genome into small and large ones, as intersectBed cannot handle data with bigger than 500000000
    perl extract_large_coordinates_gene.pl ortho_bed_mdo 
    perl extract_large_coordinates_gene.pl bed.$i.mdo
    intersectBed -a large_ortho_bed_mdo -b large_bed.$i.mdo > large.overlap_all_mdo_$i
    intersectBed -a small_ortho_bed_mdo -b small_bed.$i.mdo > small.overlap_all_mdo_$i
    cat large.overlap_all_mdo_$i small.overlap_all_mdo_$i > overlap_all_mdo_$i
done

for i in overlap_all*
do
    awk '{if(($3-$2)>50) print}' $i > use.$i
    perl ../delete.same.coordi.pl use.$i > uniq.$i
done

for i in "${arr3[@]}"
do
    for j in "${arr2[@]}"
    do
	awk '{print $4}' uniq.overlap_all_$i\_$j > all_$i\_$j\_ortho
    done
done

for i in "${arr2[@]}"
do
    awk '{print $4}' uniq.overlap_all_mdo_$i > all_mdo_$i\_ortho
done

for i in "${arr3[@]}"
do
    for j in "${arr2[@]}"
    do
    perl ../../remove.same.pl recent_$i\_$j\_ortho all_$i\_$j\_ortho > noRTE_ortho_$i\_$j
    done
done
