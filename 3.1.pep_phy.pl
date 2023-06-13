#!/usr/bin/perl -w
use strict; 
print "step 3.1: run $0\n";

my $construct_tree = shift @ARGV;
my $trimal_filter = shift @ARGV;
my $pep_phy = shift @ARGV;
my $foldername="$construct_tree/$trimal_filter";##aligned_cds_prank || pure_singcopy_prank
my $out_folder="$construct_tree/$pep_phy"; unless(-e "$out_folder"){system("mkdir -p $out_folder");}

unless(-e "$construct_tree/3.1.pep2phy.ok"){
	opendir(FOLDER,"$foldername") or die "$!"; my @array = grep(/fas$/,readdir(FOLDER)) or die "$!"; close FOLDER;
	my $count;
	foreach my $filename ( @array ){
		my $output=$filename; $output=~s/\.fasta\.best\.fas$/\.phy/;
		open (FILE,"$foldername/$filename") or die "$!";
		open (OUTP, ">$out_folder/$output") or die "$!";
		my $species;
		my %sequences;
		my $count2=0;
		while(my $line = <FILE> ){
			$line =~ s/[\n|\r]//;
			if($line =~ /^>(\D\D\D)_/ ){
				$species = $1;
				$sequences{$species} = '';
				$count2++;
			}else{
				$sequences{$species} .= $line;
			}
		}
		close FILE;
		my $len=length($sequences{$species});
		print OUTP "$count2        $len\n";   
		foreach my $name (sort keys(%sequences)){
			my $spacen=50-length($name);
			print OUTP $name,' 'x$spacen,$sequences{$name},"\n";                
		}
		$count++;
		#print "$count files done--\n";	
		close OUTP;
	}
	open(OUT, ">$construct_tree/3.1.pep2phy.ok") or die "$!";
	close OUT;
}