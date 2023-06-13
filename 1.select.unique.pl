use strict;

#unless(-e "./1.orthologs/Orthogroups.txt"){system("cp ../../pep/OrthoFinder/Results*/Orthogroups/* ../");}

open(COUNT, $ARGV[0]) or die "$!"; #Orthogroups_SingleCopyOrthologues.txt
my %hash;
#open(OUT, ">ortho.unique.txt") or die "$!";
open(OUT, ">$ARGV[1]") or die "$!";
while(<COUNT>){ #file: Orthogroups.GeneCount.tsv
	chomp;
	my @arr = split(/\s+/, $_);
	if($arr[0] =~ m/^OG/){$hash{$arr[0]} = 1;}
}
close COUNT;

open(ORTHO_G, $ARGV[2]) or die "$!";#Orthogroups.tsv
while(<ORTHO_G>){
	chomp;
	my @arr = split(/\s+/, $_);
	if($arr[0] =~ m/^Orthogroups/){print OUT "$_\n"};
	if(exists $hash{$arr[0]}){
#		print "$arr[0]\n";
		print OUT "$_\n";
	}
}
close ORTHO_G;
close OUT;
