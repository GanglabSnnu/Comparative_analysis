#!/usr/bin/perl -w
use strict;
use warnings;  
print "step 3.0.0: run $0\n";
my $construct_tree = shift @ARGV;
my $align_dir= shift @ARGV;
my $trimal_dir = shift @ARGV;
my $trimal_filter = shift @ARGV;
my $spe_num= shift @ARGV;

unless(-e "$construct_tree/3.0.0.trimal_filter_pep.ok"){
	my $filter_dir = "$align_dir/filter_aligned_AA_prank";
	opendir(FOLDER,"$filter_dir"); my @array = grep(/_Prank_aligned\.fasta\.best\.fas$/,readdir(FOLDER)); close FOLDER;
	open(PA_TRI, ">$construct_tree/para_trim.txt") or die $!;
	foreach my $filename ( @array ){
		my $trim_out = "trimal_".$filename;
		print PA_TRI "trimal -in $filter_dir/$filename -out $construct_tree/$trimal_dir/$trim_out\n";
	}close PA_TRI;
	system("ParaFly -c $construct_tree/para_trim.txt -CPU 80");
	open(OUT, ">$construct_tree/3.0.0.trimal_filter_pep.ok") or die "$!"; close OUT;
}

unless(-e "$construct_tree/3.0.1.trimal_refilter_pep.ok"){
	opendir(DIR, "$construct_tree/$trimal_dir") or die $!; my @files = grep(/\.fas$/, readdir(DIR));
	foreach my $each (sort @files){
		open(IN, "$construct_tree/$trimal_dir/$each") or die $!;
		my $num = 0;
		while(my $line = <IN>){
			if($line =~ /^>/){
				$num++;
			}
		}close IN;
		
		next if $num != $spe_num;
		system("cp $construct_tree/$trimal_dir/$each $construct_tree/$trimal_filter");
	}
	open(OUT, ">$construct_tree/3.0.1.trimal_refilter_pep.ok") or die "$!"; close OUT;	
}
