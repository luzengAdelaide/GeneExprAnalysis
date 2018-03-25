#!/usr/bin /perl -w
use warnings;

my ( @gid, %hash );

while (<>) {
    chomp;
    @gid = split(" ",$_);
    $hash{$gid[0]} = $_;
    last if eof;
}

while (<>) {
    chomp;
    @gid = split(" ",$_);
    print +( join "\t", @gid, $hash{ $gid[1] } ), "\n" if exists $hash{$gid[1]};
    print +( join "\t", @gid, 0,0,0,0,0,0,0,0,0,0,0,0,0  ), "\n" unless exists $hash{$gid[1]};
}
