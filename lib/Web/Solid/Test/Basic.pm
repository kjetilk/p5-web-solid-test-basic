package Web::Solid::Test::Basic;

use 5.010001;
use strict;
use warnings;
use parent 'Test::FITesque::Fixture';
use Test::More ;
use LWP::UserAgent;
use Test::Deep;
use Test::RDF;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.010';

sub http_read_unauthenticated : Test : Plan(4) {
  my ($self, $args) = @_;
  my $ua = LWP::UserAgent->new;
  my $url = $args->{url};
  my $reshead = $ua->head( $url );
  note($args->{description});
  ok($reshead->is_success, "Successful HEAD request for $url");

  my $resget = $ua->get( $url );
  ok($resget->is_success, "Successful GET request for $url");

  my @head_headers_fields = $reshead->headers->header_field_names;
  my @get_headers_fields = $resget->headers->header_field_names;
  cmp_bag(\@head_headers_fields, \@get_headers_fields, "HEAD and GET request has the same header fields");

  @get_headers_fields = grep { !/Date/ } @get_headers_fields; # Do not test date-fields since they may change between HEAD and GET
  @get_headers_fields = grep { !/^Client/ } @get_headers_fields; # Do not test client-side added fields

  subtest 'Testing all headers' => sub {
	 plan tests => scalar @get_headers_fields;
	 foreach my $get_header_field (@get_headers_fields) {
		is($resget->header($get_header_field), $reshead->header($get_header_field), "$get_header_field is the same for both");
	 }
  };

}


sub http_check_header_unauthenticated : Test : Plan(2) {
  my ($self, $args) = @_;
  my $ua = LWP::UserAgent->new;
  my $url = $args->{url};
  note($args->{description});
  delete $args->{url};
  delete $args->{description};
  my $reshead = $ua->head( $url );
  ok($reshead->is_success, "Successful HEAD request for $url");
  subtest 'Testing HTTP header content' => sub {
	 plan tests => scalar keys(%{$args});
	 while (my ($predicate, $value) = each(%{$args})) {
		my ($key) = $predicate =~ m/\#(.*)$/; # TODO: Use URI::NamespaceMap for this
		$key =~ s/_/-/g; # Some heuristics for creating HTTP headers
		$key =~ s/\b(\w)/\u$1/g;
		is($reshead->header($key), $value, "$key has correct value");
	 }
  }
}


sub http_put_readback_unauthenticated : Test : Plan(4) {
  my ($self, $args) = @_;
  my $ua = LWP::UserAgent->new;
  my $url = $args->{url};
  my $content = '<https://example.org/foo> a <https://example.org/Dahut> .';
  my $resput = $ua->put( $url, Content => $content );
  note($args->{description});
  ok($resput->is_success, "Successful PUT request for $url");
  my $resget = $ua->get( $url );
  ok($resget->is_success, "Successful GET request for $url");
  my $rescontent = $resget->content;
  is_valid_rdf($rescontent, "Returned content is valid RDF");
  is_rdf($rescontent, $content, "Same content returned");
}


sub http_write_with_bearer : Test : Plan(1) {
  my ($self, $args) = @_;
 SKIP: {
    skip 'SOLID_BEARER_TOKEN needs to set for this test', 1 unless ($ENV{SOLID_BEARER_TOKEN});
	 my $ua = LWP::UserAgent->new;
	 $ua->default_header('Authorization' => 'Bearer ' . $ENV{SOLID_BEARER_TOKEN},
								'Content-Type' => 'text/turtle'
							  );
	 my $url = $args->{url};
	 my $res = $ua->put( $url, Content => '<https://example.org/foo> a <https://example.org/Dahut> .' );
	 ok($res->is_success, "Successful PUT request for $url");
  }
};


sub http_methods_with_bearer : Test : Plan(1) {
  my ($self, $args) = @_;
 SKIP: {
    skip 'SOLID_BEARER_TOKEN needs to set for this test', 1 unless ($ENV{SOLID_BEARER_TOKEN});
	 note($args->{description});
	 my $ua = LWP::UserAgent->new;
	 $ua->default_header('Authorization' => 'Bearer ' . $ENV{SOLID_BEARER_TOKEN},
								'Content-Type' => 'text/turtle',
								'Accept' => 'text/turtle',
							  );
	 my $url = $args->{url};
	 my $method = $args->{method};
	 my $res = $ua->request( HTTP::Request->new($method => $url), Content => $args->{body} );
	 is($res->code, $args->{code}, "Using $method for request for $url");
  }
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

See L<Web::Solid::Test> for an introduction to the idea behind these
test modules.

=head1 IMPLEMENTED TESTS

=head2 Test scripts

This package provides C<tests/basic.t> which runs tests over the
fixture table in C<tests/data/basic.ttl>. The test script requires the
environment variable C<SOLID_REMOTE_BASE> to be set to the base URL
that any relative URLs in the fixture tables will be resolved
against. Thus, the fixture tables themselves are independent of the
host that will run them.

To run the test script in the clone of this package, invoke it like this:

  SOLID_REMOTE_BASE="https://kjetiltest4.dev.inrupt.net/" prove -l tests/basic.t




=head2 C<< http_read_unauthenticated >>

Some basic tests for HTTP reads.

=head3 Parameters

=over

=item * C<url>

The URL to request.

=back

=head3 Environment

None

=head3 Implements

=over

=item 1. That an HTTP HEAD request to the given URL succeeds.

=item 2. That an HTTP GET request to the given URL succeeds.

=item 3. That the HEAD and GET requests had the same header fields.

=item 4. That the values of the header fields are the same.

=back

=head2 C<< http_put_readback_unauthenticated >>

First writes some content with a PUT request, then reads it back with a GET and checks RDF validity.

=head3 Parameters

=over

=item * C<url>

The URL to request.

=back

=head3 Environment

None

=head3 Implements

=over

=item 1. That an HTTP PUT with content request to the given URL succeeds.

=item 2. That an HTTP GET request to the given URL succeeds.

=item 3. That the content is valid RDF.

=item 4. That the triples in the written and read RDF is the same.

=back


=head2 C<< http_write_with_bearer >>

Test for successful HTTP PUT authenticated with a Bearer token

=head3 Parameters

=over

=item * C<url>

The URL to request.

=back

=head3 Environment

Set C<SOLID_BEARER_TOKEN> to the bearer token to be used in the authorization header.

=head3 Implements

=over

=item 1. That an HTTP PUT request to the given URL with a short Turtle payload succeeds.

=back


=head2 C<< http_methods_with_bearer >>

Tests for whether a certain HTTP request, authenticated with a Bearer token, returns a certain status code.

=head3 Parameters

=over

=item * C<url>

The URL to request.

=item * C<method>

The HTTP method to use in the request.

=item * C<body>

The body of the request (optional).

=item * C<code>

The expected status code to tests for.

=back

=head3 Environment

Set C<SOLID_BEARER_TOKEN> to the bearer token to be used in the authorization header.

=head3 Implements

=over

=item 1. That an HTTP request with the given method and body to the
given URL with an payload returns the given status code.

=back





=head1 NOTE

The parameters above are in the RDF formulated as actual full URIs,
but where the local part is used here and resolved by the
L<Test::FITesque::RDF> framework, see its documentation for details.

=head1 TODO

The namespaces used in the current fixture tables are examples, and
will be changed before an 1.0 release of the system.


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

