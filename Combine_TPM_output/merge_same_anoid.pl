#!/usr/bin /perl -w
use warnings;

my ( @gid, %hash );

while (<>) {
    chomp;
    $hash{ $gid[0] } = $_ if @gid = split;
    last if eof;
}

while (<>) {
    print +( join "\t", @gid, $hash{ $gid[2] } ), "\n"
	if @gid = split and exists $hash{ $gid[2] };
}
