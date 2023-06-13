#!/usr/bin/perl -w
use strict;
use warnings;
print "step 4.1: run $0\n";
unless(-e "$ARGV[2]/4.1.split_cds.ok"){
	my $cds_files = "$ARGV[0]";
	opendir(CDS_DIR, $cds_files) or die "$!";
	my @sp_files = grep(/fasta/, readdir(CDS_DIR));
	close CDS_DIR;

	my %hash;
	foreach my $sp_file (@sp_files){
		open(CDS, "$ARGV[0]/$sp_file") or die "$!";
		my $id;
		while(my $line = <CDS>){
			$line =~ s/[\n|\r]//;
			my @arr = split(/\s+/, $line);
			if($line =~ m/^>/){
				$id = $arr[0];
				$id =~ s/^>//;
				#$hash{$id} .= $arr[0]."\n";
			}
			else{
				$hash{$id} .= $line;
			}
		}
		close CDS;
	}

	#open(ORTHO, "./one.matched.orthologous.genes.txt") or die "$!";
	open(ORTHO, "$ARGV[1]/single.copy.genes.txt") or die "$!";
	my $out_dir = "4.1_CDS_unalgin";
	unless(-e "$ARGV[2]/$out_dir"){system("mkdir -p $ARGV[2]/$out_dir");}

	while(<ORTHO>){
		chomp;
		my @arr = split(/\s+/, $_);
		my $ortho_id = shift(@arr);
		my $new_line = join "\t", @arr;
		my @a = split(/\s+/, $new_line);
		if($_ =~ m/^OG/){
	#		opendir(SPLIT_PRO, "$out_dir") or die "$!";
	#		my @ortho_proteins = grep(/fasta/, readdir(SPLIT_PRO));
			open(SPLIT_PRO, ">$ARGV[2]/$out_dir/$ortho_id".".fasta") or die "$!";
			foreach my $each (@a){
				if(exists $hash{$each}){
					my $sp_abbr = $each; $sp_abbr =~ m/^(\D\D\D)_/; $sp_abbr = $1;
					print SPLIT_PRO ">$sp_abbr\n$hash{$each}\n";
				}
			}
			close SPLIT_PRO;
		}
	}
	close ORTHO;
	open(OUT, ">$ARGV[2]/4.1.split_cds.ok") or die "$!";
	close OUT;
}