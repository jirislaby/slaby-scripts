#!/usr/bin/perl -w
use strict;
#use Data::Dumper;

my $dir = '/mnt/2G/nvr';
my @cmdline = qw/-c:v copy/;
my $fs = '3G';
my $suffix = 'mkv';
my $count = 21;
my $no = $count;
my $cam = shift;
my @source;
my $check_time = 600;
my $time_diff = 60;
my $time_min = 30;

if ($cam eq 'jih') {
	@source = qw@-rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://kameraj/stream1@;
	push @cmdline, '-an';
} elsif ($cam eq 'chodba') {
	@source = qw@-rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://kamerach/stream1@;
	push @cmdline, '-an';
	$count = 15;
} elsif ($cam eq 'garaz') {
	@source = qw@-rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://kamerag/stream1@;
	push @cmdline, '-an';
	$count = 15;
} elsif ($cam eq 'out') {
	@source = qw@-rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://kamerao/stream1@;
	push @cmdline, qw/-c:a copy/;
} elsif ($cam eq 'zapad') {
	@source = qw@-rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://kameraz/user=admin&password=&channel=0&stream=0.sdp@;
	push @cmdline, qw/-c:a copy/;
	$fs = '1G';
	$count = 25;
} elsif ($cam eq 'zvuk') {
	no warnings 'qw';
	@source = qw@-f alsa -i hw:0,0@;
	@cmdline = qw/-c:a mp3 -compression_level 9/;
	$fs = '1G';
	$suffix = 'mp3';
	$count = 8;
} else {
	exit 1;
}

push @cmdline, ('-fs', $fs);

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
