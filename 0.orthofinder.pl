#!/usr/bin/perl
use strict;
## conda activate comp_ana


my $main = `pwd`; chomp $main;

# step 1.0: run orthofinder
print "step 1.0: run orthofinder\n";
my $pep_dir = "./0.genomic_data/pep"; #change this part with your own pep directory!
my $cds_dir = "./0.genomic_data/cds"; #change this part with your own cds directory!
my $orth_work = "./1.orthologs"; # add this variable, the orthofinder will auto produced!
unless(-e "$orth_work/0.orthofinder.ok"){
	system("orthofinder -f $pep_dir -M msa -a 80 -o ./$orth_work") == 0 or die $!;
	open(OUT, ">$orth_work/0.orthofinder.ok") or die "$!";
	close OUT;
}
