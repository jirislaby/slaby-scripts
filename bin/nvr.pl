#!/usr/bin/perl -w
use strict;
use Config::IniFiles;
#use Data::Dumper;

my $cfg = Config::IniFiles->new(-file => '/etc/nvr.ini');

die 'invalid params' if scalar @ARGV != 1;

my $cam = shift;

my $dir = $cfg->val('global', 'dir') or die "no directory";
my $suffix = $cfg->val('global', 'suffix', 'mkv');
my $check_time = $cfg->val('global', 'check_time', 600);
my $time_diff = $cfg->val('global', 'time_diff', 60);
my $time_min = $cfg->val('global', 'time_min', 30);

my $source = $cfg->val("src-$cam", 'source') or die "no source";
my $cmdline = $cfg->val("src-$cam", 'cmdline', '');
my $fs = $cfg->val("src-$cam", 'fs', '3G');
my $count = $cfg->val("src-$cam", 'count', 21);

my @source = split(/\s+/, $source);
my @cmdline = qw/-c:v copy/;
push @cmdline, split(/\s+/, $cmdline);
push @cmdline, ('-fs', $fs);

my $no = $count;
my $base = $cam;
my $stamp = 0;
my $last;

foreach my $f (glob("$dir/$base*.$suffix")) {
	my $mtime = (stat($f))[9];
	if ($mtime > $stamp) {
		$last = $f;
		$stamp = $mtime;
	}
}

if (defined $last) {
	$last =~ /([0-9]*)\.$suffix$/;
	$no = $1;
}

sub run_ffmpeg($@) {
	my $file = shift;
	my $starttime = time;
	my $pid = fork();
	die "cannot fork" if (!defined $pid);

	if (!$pid) {
		close(STDIN);
		print STDERR join(' ', @_), "\n";
		exec(@_);
		die "cannot exec";
	}

	$SIG{ALRM} = sub {
		my $mtime = (stat($file))[9];
		my $time = time;
		#print STDERR "checking mtime=$mtime time=$time diff=",
		#	$time - $mtime, ")\n";
		if ($time - $mtime > $time_diff) {
			print STDERR "$cam: killing defunct PID $pid (mtime=$mtime time=$time diff=",
				$time - $mtime, ")\n";
			kill 'TERM', $pid;
			$SIG{ALRM} = sub {
				print STDERR "$cam: killing defunct PID $pid by KILL\n";
				kill 'KILL', $pid;
			};
			alarm(10);
			return;
		}
		alarm($check_time);
	};

	alarm($check_time);

	waitpid($pid, 0);

	alarm(0);

	my $lasted = time - $starttime;
	if ($lasted < $time_min) {
		return 0xffff;
	}

	return $?;
}

while (1) {
	$no++;
	$no %= $count;
	my $file = sprintf("%s/%s%.2d.%s", $dir, $base, $no, $suffix);
	my @to_run = (qw/ffmpeg -nostdin -loglevel level+8/, @source, @cmdline, '-y', $file);
	#print Dumper(\@to_run);

	my $ret = run_ffmpeg($file, @to_run);
	if ($ret & 0x7f) {
		printf STDERR "%s: ffmpeg failed with 0x%x, sleeping!\n", $cam, $ret;
		if ($ret == 0xffff) {
			$no--;
			sleep 60;
		} else {
			sleep 5;
		}
	}
}
