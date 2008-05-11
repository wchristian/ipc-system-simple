#!/usr/bin/perl -w
use strict;
use Config;
use Test::More;

if ($^O eq "MSWin32") {
	plan skip_all => "Multi-arg pipes not supported under Win32";
} else {
	plan tests => 9;
}

# We want to invoke our sub-commands using Perl.

my $perl_path = $Config{perlpath};

if ($^O ne 'VMS') {
	$perl_path .= $Config{_exe}
		unless $perl_path =~ m/$Config{_exe}$/i;
}

use_ok("IPC::System::Simple","capture");
chdir("t");

# The tests below for $/ are left in, even though IPC::System::Simple
# never touches $/

# Scalar capture

my $output = capture($perl_path,"output.pl",0);
ok(1);

is($output,"Hello\nGoodbye\n","Scalar capture");
is($/,"\n",'$/ intact');

# List capture

my @output = capture($perl_path,"output.pl",0);
ok(1);

is_deeply(\@output,["Hello\n", "Goodbye\n"],"List capture");
is($/,"\n",'$/ intact');

# List capture with odd $/

$/ = "e";
my @odd_output = capture($perl_path,"output.pl",0);
ok(1);

is_deeply(\@odd_output,["He","llo\nGoodbye","\n"], 'Odd $/ capture');


