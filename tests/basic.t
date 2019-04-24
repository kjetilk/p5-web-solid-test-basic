=pod

=encoding utf-8

=head1 PURPOSE

Testing basic functionality of a Solid server

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is Copyright (c) 2019 by Inrupt Inc.

This is free software, licensed under:

  The MIT (X11) License


=cut


use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use Test::FITesque;
use Test::FITesque::Test;

my $file = $Bin . '/data/basic.ttl';

use Test::FITesque::RDF;

my $suite = Test::FITesque::RDF->new(source => $file, base_uri => $ENV{SOLID_REMOTE_BASE})->suite;

$suite->run_tests;

done_testing;
  

