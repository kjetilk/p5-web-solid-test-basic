package Web::Solid::Test;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.021';

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Web::Solid::Test - Solid Test Scripts


=head1 VERSION

Version 0.021


=head1 SYNOPSIS

  use Test::FITesque::RDF;
  my $suite = Test::FITesque::RDF->new(source => $file, base_uri => $ENV{SOLID_REMOTE_BASE})->suite;
  $suite->run_tests;
  done_testing;

See C<tests/basic.t> for a full example.

=head1 DESCRIPTION

The basic idea with these tests is to simplify reuse and formulation
of fixture tables using the Resource Description Framework (RDF). It
is in an early stage, but there are running tests in this module.

This system is built on L<Test::FITesque::RDF>, which adds RDF fixture
tables to L<Test::FITesque>.

Then, the idea is that modules such as this will provide a reusable
implementation of certain tests, and that they can be adapted to
concrete test scenarios by either passing parameters from the RDF
tables (for both input variables and expected outcomes), or using
environment variables.

To run the actual tests, test scripts will be made, but they should be
terse as their only mission is to initialize the test framework, see
the synopsis for an example of such a script. The script can then be
invoked by e.g. CI systems or used in development.

The RDF fixture tables and the small wrapper scripts can exist
independently of the module, and modules can be installed easily so
that they can be reused. Nevertheless, it is also natural to package
these together, like it has been done in this package.

=head1 TEST MODULES

The tests will live in test modules, currently, this distribution contains

=over

=item * L<Web::Solid::Test::Basic>

=item * L<Web::Solid::Test::HTTPLists>

=back

Within these, there are test scripts in the form of subroutines
containing subtests. These are then referenced from the fixture tables. 






=head1 BUGS

Please report any bugs to
L<https://github.com/kjetilk/p5-web-solid-test-basic/issues>.

=head1 SEE ALSO

This was primarily developed for the L<Solid Test Suite|https://github.com/solid/test-suite>.

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is Copyright (c) 2019 by Inrupt Inc.

This is free software, licensed under:

  The MIT (X11) License


=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

