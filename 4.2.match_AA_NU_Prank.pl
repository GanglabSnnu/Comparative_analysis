#!/usr/bin/perl -w
use strict;
use warnings;  
print "step 4.2: run $0\n";
my $pos_selection = shift @ARGV;
my $ps_dir2 = shift @ARGV;
my $algin_dir = shift @ARGV;
my $ps_dir3 = shift @ARGV;

unless(-e "$pos_selection/4.2.cds_match.ok"){
	my $Nufolder="$pos_selection/$ps_dir2";
	my $AAfoldername="$algin_dir/filter_aligned_AA_prank";
	my $matchfolder="$pos_selection/$ps_dir3";
	unless(-e "$matchfolder"){system("mkdir -p $matchfolder");}
	opendir(FOLDER,"$Nufolder");
	my @array = grep(/fasta/,readdir(FOLDER));
	close FOLDER;

	foreach my $filename ( @array ){
		my $nu_sequences=$filename;
		my $aa_align_file=$filename;
		$aa_align_file=~s/\.fasta/_Prank_aligned.fasta.best.fas/;
		my $nu_align=$filename;
		$nu_align=~s/\.fasta/_match_align.fasta/;
		
		open (AA, "$AAfoldername/$aa_align_file");
		my $species;
		my %AA_align;
		my @array;
		while(my $line = <AA> ){
			chomp $line;  
			if( $line =~ /^(>\D\D\D)_/ ){
				$species = $1;
				$AA_align{$species} = ''; push (@array, $species);   
			}
			else{
				$AA_align{$species} .= $line;                      
			}
		}
		close AA;

		open (NU, "$Nufolder/$nu_sequences");
		my $spe;
		my %NU_seq;
		while(my $line = <NU> ){
			chomp $line;
			if( $line =~ /^(>\S+)/ ){
				$spe = $1;
				$NU_seq{$spe} = '';    
			}
			else{
				$NU_seq{$spe} .= $line;                      
			}
		}
		close NU;
		
		open (OM, ">>$matchfolder/$nu_align");	
		foreach my $name (sort @array){   
			my $len_aa=length($AA_align{$name});
			my $len_nu=length($NU_seq{$name});
			my @codon; 
			for (my $j=0; $j<=$len_nu; $j=$j+3){
				my $site=substr($NU_seq{$name}, $j, 3);
				push (@codon, $site);
			}		   	   
			my $NU_tran_align = '';
			my $count=0;
			for (my $i=0; $i<=$len_aa; $i++){
				my $site=substr($AA_align{$name}, $i, 1);
				if ($site eq '-') { $NU_tran_align.='---';}
				else {
					$NU_tran_align.=$codon[$count];
					$count++;
				}
			}	
			$NU_tran_align =~ s/(TAA|TGA|TAG)$//ig; ## delete terminal codon
			print OM "$name\n$NU_tran_align\n";
		}	
		close OM;		
	}
	open(OUT, ">$pos_selection/4.2.cds_match.ok") or die "$!";
	close OUT;
}
	     
