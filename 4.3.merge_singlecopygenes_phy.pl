#/bin/perl
use strict;
print "step 4.3: run $0\n";
my $dir = shift(@ARGV); $dir = "$dir/4.2_trimal_refilter_cds_match";
my $out_dir = shift(@ARGV);
my $outfile = "merged.aln.fasta";

unless(-e "$dir/../$out_dir/4.3.cds.merge.ok"){
	opendir(PRDIR, $dir) or die "$!"; my @files = grep(/fasta/, readdir(PRDIR)); close PRDIR;
	my %hash; my $id;
	foreach my $file (sort (@files)){
		open(IN, "$dir/$file") or die "$!";
		while(my $line = <IN>){
			chomp($line);
			if($line =~ m/^>(\D\D\D)/){
				$id = $1;
			}else{
				if($line =~ m/^\s+/){print "$file\twrong\n";}
				$hash{$id} .= $line;
			}
		}
		close IN;
	}
	
	open(MER, ">$dir/../$out_dir/$outfile") or die "$!";
	foreach my $sp (sort (keys %hash)){
		print "$sp\n";
		print MER ">$sp\n$hash{$sp}\n";
	}
	close MER;
	open(OUT, ">$dir/../$out_dir/4.3.cds.merge.ok") or die "$!";
	close OUT;
}


#my @order=("Fec","Puc","Nen","Pat","Pao","Pal","Pap");
#my @order=@ARGV; ## this name you'd better match to the seq id!!!!
unless(-e "$dir/../$out_dir/4.3.cds2phy.ok"){
	my $count; my $filename = "merged.aln.fasta";
	open (FILE,"$dir/../$out_dir/$filename") or die "$!";
	my $output = $filename; $output =~ s/fasta/phy/;
	open (PHY, ">$dir/../$out_dir/$output") or die "$!";
	my $species; my %sequences; my $count2=0;
	while(my $line = <FILE> ){
		chomp $line;     
        if($line =~ /^>(.+)/){
			$species = $1;
=pod			
			if($line =~ m/^>Cat/){$species = "Fc";}
			if($line =~ m/^>Puma/){$species = "Pc";}
			if($line =~ m/^>CloudedLeopard/){$species = "Nn";}
			if($line =~ m/^>Tiger/){$species = "Pt";}
			if($line =~ m/^>SnowLeopard/){$species = "Po";}
			if($line =~ m/^>Lion/){$species = "Pl";}
			if($line =~ m/^>Leopard/){$species = "Pp";}
			$sequences{$species} = '';
=cut
			$count2++;
        }else{
			$sequences{$species} .= $line;                     
		}
	}
	close FILE;
	
    my $len=length($sequences{$species});
    print PHY "$count2        $len\n";   
    foreach my $name (sort keys(%sequences)){
		my $spacen=50-length($name);                 
		print PHY $name,' 'x$spacen,$sequences{$name},"\n";                
    }
	$count++;
	print "$count files done--\n";	
	close PHY;
	
	open(OUT, ">$dir/../$out_dir/4.3.cds2phy.ok") or die "$!";
	close OUT;
}
