package Web::Solid::Test::Basic;

use 5.010001;
use strict;
use warnings;
use parent 'Test::FITesque::Fixture';
use Test::More ;
use LWP::UserAgent;
use Test::Deep;


our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

sub http_read_unauthenticated : Test : Plan(4) {
  my ($self, $args) = @_;
  my $ua = LWP::UserAgent->new;
  my $url = $args->{url};
  my $reshead = $ua->head( $url );
  ok($reshead->is_success, "Successful HEAD request for $url");

  my $resget = $ua->get( $url );
  ok($resget->is_success, "Successful GET request for $url");

  my @head_headers_fields = $reshead->headers->header_field_names;
  my @get_headers_fields = $resget->headers->header_field_names;
  cmp_bag(\@head_headers_fields, \@get_headers_fields, "HEAD and GET request has the same header fields");

  subtest 'Testing all headers' => sub {
	 plan tests => scalar @get_headers_fields;
	 foreach my $get_header_field (@get_headers_fields) { # TODO: Date-fields may fail
		is($resget->header($get_header_field), $reshead->header($get_header_field), "$get_header_field is the same for both");
	 }
  };

}


sub http_write_with_bearer : Test : Plan(1) {
  my ($self, $args) = @_;
  my $ua = LWP::UserAgent->new;
  $ua->default_header('Authorization' => 'Bearer ' . $ENV{SOLID_BEARER_TOKEN},
							 'Content-Type' => 'text/turtle'
							);
  my $url = $args->{url};
  my $res = $ua->put( $url, Content => '<https://example.org/foo> a <https://example.org/Dahut> .' );
  ok($res->is_success, "Successful PUT request for $url");
};


1;

__END__

=pod

=encoding utf-8

=head1 NAME

Web::Solid::Test::Basic - Basic Solid Tests

=head1 SYNOPSIS

  use Test::FITesque::RDF;
  my $suite = Test::FITesque::RDF->new(source => $file, base_uri => $ENV{SOLID_REMOTE_BASE})->suite;
  $suite->run_tests;
  done_testing;

See C<tests/basic.t> for a full example.

=head1 DESCRIPTION

=head2 Introduction

The basic idea with these tests is to simplify reuse and formulation
of fixture tables using the Resource Description Framework (RDF). It
is in a very early stage, but there are running tests in this module.

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

Each module like this one will need to document the tests it
implements, consider the below an example of how this should be done.



=head1 IMPLEMENTED TESTS

=head2 C<< http_read_unauthenticated >>

Some basic tests for HTTP reads.

=head3 Parameters

=over

=item * C<url>

The URL to request.

=back


=head3 Implements

=over

=item 1. That an HTTP HEAD request to the given URL succeeds.

=item 2. That an HTTP GET request to the given URL succeeds.

=item 3. That the HEAD and GET requests had the same header fields.

=item 4. That the values of the header fields are the same.

=back


=head1 NOTE

The parameters above are in the RDF formulated as actual full URIs,
but where the local part is used here and resolved by the
L<Test::FITesque::RDF> framework, see its documentation for details.


=head1 BUGS

Please report any bugs to
L<https://github.com/kjetilk/p5-web-solid-test-basic/issues>.

=head1 SEE ALSO

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

