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

sub http_read_unauthenticated : Test : Plan(3) {
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
}
  


1;

__END__

=pod

=encoding utf-8

=head1 NAME

Web::Solid::Test::Basic - Basic Solid Tests

=head1 SYNOPSIS

=head1 DESCRIPTION

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

