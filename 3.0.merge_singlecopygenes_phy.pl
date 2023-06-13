#/bin/perl
use strict;
print "step 3.0: run $0\n";

my $trimal_filter = shift(@ARGV);
my $construct_tree = shift(@ARGV);
my $pep_mer = shift(@ARGV);
my @order=@ARGV;
my $outfile = "merged.aln.fasta";

unless(-e "$construct_tree/3.0.all_merge.ok"){
	opendir(PRDIR, "$construct_tree/$trimal_filter") or die "$!"; my @files = grep(/fas$/, readdir(PRDIR)); close PRDIR;
	my %hash; my $id;
	foreach my $file (sort (@files)){
		open(IN, "$construct_tree/$trimal_filter/$file") or die "$!";
		while(my $line = <IN>){
			chomp($line);
			if($line =~ m/^>(\D\D\D)_/){
				$id = $1;
			}else{
				if($line =~ m/^\s+/){print "$file\twrong\n";}
				$hash{$id} .= $line;
			}
		}
		close IN;
	}
	
	open(MER, ">$construct_tree/$pep_mer/$outfile") or die "$!";
	foreach my $sp (sort (keys %hash)){
		print "$sp\n";
		print MER ">$sp\n$hash{$sp}\n";
	}
	close MER;
	open(OUT, ">$construct_tree/3.0.all_merge.ok") or die "$!";
	close OUT;
}

my $trim_cut = "trim.$outfile";
system("trimal -in $construct_tree/$pep_mer/$outfile -out $construct_tree/$pep_mer/$trim_cut -automated1");


unless(-e "$construct_tree/3.0.pep2phy.ok"){
	my $count; 
	#my $filename = "merged.aln.fasta";
	my $filename = $trim_cut;
	open (FILE,"$construct_tree/$pep_mer/$filename") or die "$!";
	my $output = $filename; $output =~ s/fasta/phy/;
	open (PHY, ">$construct_tree/$pep_mer/$output") or die "$!";
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
        }
        else{$sequences{$species} .= $line;                      }
	}
	close FILE;
	
    my $len=length($sequences{$species});
    print PHY "$count2        $len\n";   
    foreach my $name (@order){
		my $spacen=50-length($name);                 
		print PHY $name,' 'x$spacen,$sequences{$name},"\n";                
    }
	$count++;
	print "$count files done--\n";	
	close PHY;
	
	open(OUT, ">$construct_tree/3.0.pep2phy.ok") or die "$!";
	close OUT;
}
