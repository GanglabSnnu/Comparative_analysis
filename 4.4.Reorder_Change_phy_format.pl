#!/usr/bin/perl -w
use strict;
use warnings;    
print "step 4.4: run $0\n";
my $pos_selection = shift @ARGV;
my $ps_dir3 = shift @ARGV;
my $ps_dir4 = shift @ARGV;
my $foldername="$pos_selection/$ps_dir3";##aligned_cds_prank || pure_singcopy_prank
my $out_folder="$pos_selection/$ps_dir4";##aligned_cds_phy || pure_singcopy_phy
unless(-e "$out_folder"){system("mkdir -p $out_folder");}

unless(-e "$pos_selection/4.4.cds2phy.ok"){
	#my @order=("Cat","Puma","CloudedLeopard","Tiger","SnowLeopard","Leopard","Lion");
	my @order=sort @ARGV;
	opendir(FOLDER,"$foldername") or die "$!"; my @array = grep(/fasta/,readdir(FOLDER)) or die "$!"; close FOLDER;
	my $count;
	foreach my $filename ( @array ){
		my $input=$filename;
		my $output=$filename;    # output file name
		$output=~s/\.fasta/\.phy/;

		open (FILE,"$foldername/$filename") or die "$!";
		open (OUTP, ">$out_folder/$output") or die "$!";
		my $species;
		my %sequences;
		my $count2=0;
		while(my $line = <FILE> ){
			chomp $line;     
			if( $line =~ /^>(.+)/ ){
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
		
		foreach my $name (@order){
			my $spacen=50-length($name);                 
			print OUTP $name,' 'x$spacen,$sequences{$name},"\n";                
		}
		$count++;
		#print "$count files done--\n";	
		close OUTP;
	}
	open(OUT, ">$pos_selection/4.4.cds2phy.ok") or die "$!";
	close OUT;
}