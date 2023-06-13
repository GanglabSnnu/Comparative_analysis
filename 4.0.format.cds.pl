#!/bin/perl
use strict;
print "step 4.0: run $0\n";

my $dir = $ARGV[0];
my $top_out = $ARGV[1];
my $out_dir = $ARGV[2];
unless(-e "$top_out/4.0.cds_format.ok"){
	opendir(DIR, "$dir") or die "$!";
	my @files = grep(/\.cds\.fasta$/, readdir(DIR));
	close DIR;

	foreach my $file (@files){
		print "$file\n";
		open(IN, "$dir/$file") or die "$!";
		my $id;
		my %hash;
		while(my $line = <IN>){
			#chomp($line);
			$line =~ s/[\n\r]//g;
			if($line =~ m/^>(\S+)/){
				$id = $1;
				$hash{$id} = '';
			}else{
				$line =~ s/[^ATCG]/-/ig;
				$hash{$id} .= $line;
			}
		}
		close IN;
		
		my $out = $file;
		open(OUT, ">$top_out/$out_dir/$out") or die "$!";
		foreach my $each (keys %hash){
			print OUT ">$each\n$hash{$each}\n";
		}
		close OUT;
	}
	open(OUT, ">$top_out/4.0.cds_format.ok") or die "$!";
	close OUT;	
}