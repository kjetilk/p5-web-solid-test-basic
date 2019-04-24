=pod

=encoding utf-8

=head1 PURPOSE

Test that Web::Solid::Test::Basic compiles.

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

use_ok('Web::Solid::Test::Basic');

diag( "Testing Web::Solid::Test::Basic $Web::Solid::Test::Basic::VERSION, Perl $], $^X" );

done_testing;

