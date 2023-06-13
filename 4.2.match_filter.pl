#!/usr/bin/perl -w
use strict;
use warnings;  
print "step 4.2.1: run $0\n";
my $pos_selection = shift @ARGV;
my $ps_dir3 = shift @ARGV;
my $ps_dir3_1 = shift @ARGV;
my $ps_dir3_2 = shift @ARGV;
my $ps_dir3_3 = shift @ARGV;
my $spe_num= shift @ARGV;

unless(-e "$pos_selection/4.2.trimal_filter_cds_match.ok"){
	my $match_dir="$pos_selection/$ps_dir3";
	my $filter_dir="$pos_selection/$ps_dir3_1";
	unless(-e "$filter_dir"){system("mkdir -p $filter_dir");}
	opendir(FOLDER,"$match_dir"); my @array = grep(/_match_align\.fasta$/,readdir(FOLDER)); close FOLDER;
	
	open(PA_TRI, ">$pos_selection/para_trim.txt") or die $!;
	foreach my $filename ( @array ){
		open(AL, "$pos_selection/$ps_dir3/$filename") or die $!;
		my @lens = ();
		while(my $line = <AL>){
			chomp($line);
			next if $line =~ /^>/;
			my $len = length($line);
			push @lens, $len;
		}close AL;
		
		my %ha; my @uniq = grep{++$ha{$_}<2}@lens; my $len_uniq = scalar @uniq;
		if($len_uniq == 1){
			system("cp $pos_selection/$ps_dir3/$filename $pos_selection/$ps_dir3_1");
			my $trim_out = "trimal_".$filename;
			print PA_TRI "trimal -in $pos_selection/$ps_dir3_1/$filename -out $pos_selection/$ps_dir3_2/$trim_out\n";
		}
	}close PA_TRI;
	system("ParaFly -c $pos_selection/para_trim.txt -CPU 80");
	open(OUT, ">$pos_selection/4.2.trimal_filter_cds_match.ok") or die "$!"; close OUT;
}

unless(-e "$pos_selection/4.2.trimal_refilter_cds_match.ok"){
	opendir(DIR, "$pos_selection/$ps_dir3_2") or die $!; my @files = grep(/\.fasta/, readdir(DIR));
	foreach my $each (sort @files){
		open(IN, "$pos_selection/$ps_dir3_2/$each") or die $!;
		my $num = 0;
		while(my $line = <IN>){
			if($line =~ /^>/){
				$num++;
			}
		}close IN;
		
		next if $num < $spe_num;
		system("cp $pos_selection/$ps_dir3_2/$each $pos_selection/$ps_dir3_3");
	}
	open(OUT, ">$pos_selection/4.2.trimal_refilter_cds_match.ok") or die "$!"; close OUT;	
}
