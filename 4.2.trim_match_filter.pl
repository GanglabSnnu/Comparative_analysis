#!/usr/bin/perl -w
use strict;
use warnings;  
print "step 4.2.1: run $0\n";
my $pos_selection = shift @ARGV;
my $ps_dir3 = shift @ARGV;
my $ps_dir3_1 = shift @ARGV;

unless(-e "$pos_selection/4.2.filter_cds_match.ok"){
	my $match_dir="$pos_selection/$ps_dir3";
	my $filter_dir="$pos_selection/$ps_dir3_1";
	unless(-e "$filter_dir"){system("mkdir -p $filter_dir");}
	opendir(FOLDER,"$match_dir"); my @array = grep(/_match_align\.fasta$/,readdir(FOLDER)); close FOLDER;

	foreach my $filename ( @array ){
		open(AL, "$pos_selection/$ps_dir3/$filename") or die $!;
		my @lens = ();
		while(my $line = <AL>){
			chomp($line);
			next if $line =~ /^>/;
			$len = length($line);
			push @len, $len;
		}close AL;
		
		my %ha; my @uniq = grep{++$ha{$_}<2}@lens; my $len_uniq = scalar @uniq;
		if($len_uniq = 1){
			system("cp $pos_selection/$ps_dir3/$filename $pos_selection/$ps_dir3_1");
		}
	}
	open(OUT, ">$pos_selection/4.2.filter_cds_match.ok") or die "$!";
	close OUT;
}
	     
