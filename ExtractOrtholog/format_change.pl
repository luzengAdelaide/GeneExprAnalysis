#!/bin/perl -w
use strict;

my ($file)=@ARGV;
open(IN,"$file");

while(<IN>){
    chomp;
    my @data = split("\t",$_);
    if ($data[8] =~ /gene_id \"([\w]+)/){
#	print $1;
	print "$data[0]\t$data[3]\t$data[4]\t$1\t\.\t$data[6]\n";
#	print "$data[0]\t$data[1]\t$1\t$data[3]\t$data[4]\t$data[5]\t$data[6]\t$data[7]\t$data[8]\n"; 
   }
}
