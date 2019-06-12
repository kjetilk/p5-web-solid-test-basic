package Web::Solid::Test::HTTPLists;

use 5.010001;
use strict;
use warnings;
use parent 'Test::FITesque::Fixture';
use Test::More qw(no_plan) ;
use LWP::UserAgent;
use Test::Deep;
use Test::RDF;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

sub http_req_res_list_unauthenticated : Test : Plan(1)  {
  my ($self, $args) = @_;
  my @requests = @{$args->{'http-requests'}}; # Unpack for readability
  subtest 'Request-responses' => sub {
	 plan tests => scalar @requests;
	 for (my $i=0; $i <= $#requests; $i++) {
		subtest "Request-response #" . ($i+1) => sub {
		  plan qw(no_plan);
		  my $ua = LWP::UserAgent->new;
		  my $response = $ua->request( $requests[$i] );
		  my $expected_response = ${$args->{'http-responses'}}[$i];
		  isa_ok($expected_response, 'HTTP::Response');
		  if ($expected_response->code) {
			 is($response->code, $expected_response->code, "Response code is " . $expected_response->code);
		  }
		  my @expected_header_fields = $expected_response->header_field_names;
		  if (scalar @expected_header_fields) {
			 subtest 'Testing all headers' => sub {
				plan tests => scalar @expected_header_fields;
				foreach my $expected_header_field (@expected_header_fields) { # TODO: Date-fields may fail
				  is($response->header($expected_header_field), $expected_response->header($expected_header_field), "$expected_header_field is the same for both");
				}
			 };
		  } else {
			 note "No expected headers set";
		  }
		};
	 }
  };
}


sub http_check_header_unauthenticated : Test : Plan(2) {
  my ($self, $args) = @_;
  my $ua = LWP::UserAgent->new;
  my $url = $args->{url};
  delete $args->{url};
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
  ok($resput->is_success, "Successful PUT request for $url");
  my $resget = $ua->get( $url );
  ok($resget->is_success, "Successful GET request for $url");
  my $rescontent = $resget->content;
  is_valid_rdf($rescontent, "Returned content is valid RDF");
  is_rdf($rescontent, $content, "Same content returned");
}






1;

__END__

