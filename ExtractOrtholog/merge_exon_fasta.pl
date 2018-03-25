#! /usr/bin/perl                                                                                                             
## merge exons from same gene name
                                              
open(IN,$ARGV[0]);

$/=">";
while(<IN>){
    chomp;
    $_=~s/>//;
    next if ($_ eq "");
    $tmp=$_;
    @single=split("\n",$tmp,2);
    $single[0]=~/^(\w+)/;
    $id=$1;
    $seq=$single[1];
    $seq=~s/\n//g;
    $hash_gene{$id}=$hash_gene{$id}.$seq;
}

foreach $gene (keys %hash_gene){
    print ">".$gene."\n".$hash_gene{$gene}."\n";
}

close IN;
close OUT;
