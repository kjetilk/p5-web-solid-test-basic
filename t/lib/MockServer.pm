use strict;
use warnings;
use Plack::Request;

package MockServer;
use Test::HTTP::Server::Simple;
use HTTP::Server::Simple::PSGI;
use base qw/Test::HTTP::Server::Simple HTTP::Server::Simple::PSGI/;

1;
