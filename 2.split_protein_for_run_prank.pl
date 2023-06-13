#!/usr/bin/perl -w
use strict;
use warnings;

my $protein_files = "$ARGV[0]";
opendir(PRO_DIR, $protein_files) or die "$!";
my @sp_files = grep(/fasta/, readdir(PRO_DIR));
close PRO_DIR;

my %hash;
foreach my $sp_file (@sp_files){
	open(PRO, "$ARGV[0]/$sp_file") or die "$!";
	my $id;
	while(my $line = <PRO>){
		#chomp($sp_file);
		my @arr = split(/\s+/, $line);
		if($line =~ m/^>/){
			$id = $arr[0];
			$id =~ s/^>//;
			$hash{$id} .= $arr[0]."\n";
		}
		else{
			$hash{$id} .= $line;
		}
	}
	close PRO;
}

#open(ORTHO, "./one.matched.orthologous.genes.txt") or die "$!";
open(ORTHO, "$ARGV[1]/single.copy.genes.txt") or die "$!";
my $out_dir = "split_protein";
unless(-e "$ARGV[2]/$out_dir"){system("mkdir -p $ARGV[2]/$out_dir");}
unless(-e "$ARGV[2]/split_pep.ok"){
	while(<ORTHO>){
		chomp;
		my @arr = split(/\s+/, $_);
		my $ortho_id = shift(@arr);
		my $new_line = join "\t", @arr;
		my @a = split(/\s+/, $new_line);
		if($_ =~ m/^OG/){
			open(SPLIT_PRO, ">$ARGV[2]/$out_dir/$ortho_id".".fasta") or die "$!";
			foreach my $each (@a){
				if(exists $hash{$each}){
					print SPLIT_PRO "$hash{$each}";
				}
			}
			close SPLIT_PRO;
		}
	}
	close ORTHO;
	open(OUT, ">$ARGV[2]/split_pep.ok") or die "$!";
	close OUT;
}
#opendir(SPLIT_DIR, $out_dir) or die "$!";
#my $alignpath="";    # change the path
#opendir(FOLDER,"$alignpath");
#my @array = grep(/fas/,readdir(FOLDER));
#close FOLDER;


#=pod
unless(-e "$ARGV[2]/multi_run.prank.ok"){
	my $outfilefoder='aligned_AA_prank';       # output files path
	unless(-e "$ARGV[2]/$outfilefoder"){system("mkdir -p $ARGV[2]/$outfilefoder");}
	opendir(SPEP, "$ARGV[2]/$out_dir") or die "$!";
	my @array = grep(/fasta/, readdir(SPEP));
	close SPEP;
	open(PA_PRA, ">$ARGV[2]/ParaFly.run.prank.command.list.txt") or die "$!";
	foreach my $filename ( @array ){
		my $output=$filename;
		$output=~s/\.fasta$/_Prank_aligned\.fasta/;
		#system ("prank -protein -d=\"$ARGV[2]/$out_dir/$filename\"  -o=\"$ARGV[2]/$outfilefoder/$output\" ");
		print PA_PRA "prank -protein -d=\"$ARGV[2]/$out_dir/$filename\"  -o=\"$ARGV[2]/$outfilefoder/$output\"\n";
	}
	system("ParaFly -c $ARGV[2]/ParaFly.run.prank.command.list.txt -CPU 100");
	open(OUT, ">$ARGV[2]/multi_run.prank.ok") or die "$!";
	close OUT;
}
#=cut

# filter the prank files without enough algined or some sequnces missed
unless(-e "$ARGV[2]/filter.no_aligned.ok"){
	my $out_filter = "filter_aligned_AA_prank";
	unless(-e "$ARGV[2]/$out_filter"){system("mkdir -p $ARGV[2]/$out_filter")}
	opendir(PRAD, "$ARGV[2]/aligned_AA_prank") or die "$!"; my @pranks = grep(/fasta/, readdir(PRAD)); close PRAD;
	my $seq_num = 0;
	foreach my $each (@pranks){
		open(IN, "$ARGV[2]/aligned_AA_prank/$each") or die "$!";
		open(OUTF, ">$ARGV[2]/$out_filter/$each") or die "$!";
		my $id; my %hash;
		while(my $line = <IN>){
			chomp($line);
			if($line =~ m/^>(\S+)/){
				$seq_num++; $id = $1;
			}else{
				$hash{$id} .= $line;
			}
		}
		close IN;
		#if($seq_num >= $ARGV[3]){system("cp $ARGV[2]/aligned_AA_prank/$each $ARGV[2]/$out_filter");}
		my @ordered_keys = keys(%hash);
		my $out_file = $each;
		my $flag = 0;
		foreach my $seq (@ordered_keys){
			if($hash{$seq} =~ m/^\s+/){
				$flag = 1;
				next;
			}
		}
		if($flag == 1){
			next;
		}else{
			#system("cp $ARGV[2]/aligned_AA_prank/$each $ARGV[2]/$out_filter");
			foreach my $each (@ordered_keys){
				print OUTF ">$each\n$hash{$each}\n";
			}
		}
	}
	open(OUT, ">$ARGV[2]/filter.prank.ok") or die "$!";
	close OUT;
}








