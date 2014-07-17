package StableHelper;

use strict;

sub get_upstream_commits(@) {
	my @res = ();
	my $cont = 0;

	foreach $_ (@_) {
		if ($cont) {
			if (/^\s+([0-9a-f]{40})\s*[\])]$/) {
				push @res, $1;
				$cont = 0;
				next;
			}
		}
		if (/^commit ([0-9a-f]{40}) upstream\.?$/ ||
			/^[\[(]\s*[Uu]pstream commit ([0-9a-f]{40})\s*[\])]$/ ||
			/^[uU]pstream commit ([0-9a-f]{40})\.$/ ||
			/^This is a backport of ([0-9a-f]{40})$/ ||
			/^\(cherry picked from commit ([0-9a-f]{40})\)$/) {
			push @res, $1;
		} elsif (/^[\[(]\s*[Uu]pstream commits ([0-9a-f]{40})\s+and\s*$/) {
			push @res, $1;
			$cont = 1;
		} elsif (/\b[0-9a-f]{40}\b/) {
#			print "\tUnmatched SHA: $_";
		}
	}
	return @res;
}

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
