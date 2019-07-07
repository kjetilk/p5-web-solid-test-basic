#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;

my $mock_solid = sub {
    my $env = shift;
	 my $req = Plack::Request->new($env);
	 return [ 200, ['Content-type' , 'text/turtle'], [ 'body'] ];
#    return [ $status, $headers, $body ];
};

