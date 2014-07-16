package StableHelper;

use strict;

sub add_header($$) {
	my ($file, $msg) = @_;
	open(FILE, "<", $file) || die "cannot open $file";
	my @content = <FILE>;
	close FILE;

	my $first = 1;
	open(FILE, ">", $file) || die "cannot open $file";
	foreach my $line (@content) {
		if ($first && $line eq "\n") {
			print FILE "\n$msg\n";
			$first = 0;
		} else {
			print FILE $line;
		}
	}
	close FILE;
}

1;
