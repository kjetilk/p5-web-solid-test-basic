=pod

=encoding utf-8

=head1 PURPOSE

Mock a HTTP interface to test the tests

=head1 ENVIRONMENT

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is Copyright (c) 2019 by Inrupt Inc.

This is free software, licensed under:

  The MIT (X11) License


=cut


use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::FITesque;
use Test::FITesque::Test;
use Test::FITesque::RDF;
use FindBin qw($Bin);
use MockSolid;



my $port=8881;
my $host='localhost';

my $server = MockSolid->new();
$server->host($host);
my $app = sub { MockSolid->run_psgi(@_) };
$server->app($app);

my $url_root = $server->started_ok("start up my web server");
die $url_root;


my $file = $Bin . '/data/http-basic.ttl';


my $suite = Test::FITesque::RDF->new(source => $file, base_uri => $ENV{SOLID_REMOTE_BASE})->suite;

$suite->run_tests;

done_testing;
  

