#!/usr/bin/perl -w
use strict;

# intersectbed (BEDTools) cannot handle coordinates that are larger than one billion, this code is used to minimise the size of coordinates that are larger than 500M.
my ($filename) = @ARGV;
open(IN,"$filename");
my $out1 = "small_".$filename;
my $out2 = "large_".$filename;
open(OUTA,">$out1");
open(OUTB,">$out2");
my($start, $end);

while(<IN>){
    chomp;
    my @data = split("\t",$_);
    if($data[2] > 500000000 && $data[1] > 500000000 ){
	$start = $data[1] - 500000000;
	$end = $data[2] - 500000000;
	print OUTB "$data[0]\t$start\t$end\t$data[3]\n";
    }
    else {
	print OUTA $_,"\n";
    }
}
