use strict;
use warnings;
use Plack::Request;

package MockServer;
use Moo;
use HTTP::Server::Simple::PSGI;
use Net::EmptyPort qw(empty_port);
use Types::Standard qw(Int);

has pid => ( is => 'rw',
				 isa => Int
			  );

sub base_uri {
  my $self = shift;
  my $port=empty_port();
  my $host='localhost';

  my $server = HTTP::Server::Simple::PSGI->new($port);
  $server->host($host);

  my $app = MockSolid->to_psgi_app(@_) ;
  $server->app($app);
  $self->pid($server->background);
  return "http://$host:$port/";
}

sub kill {
  my $self = shift;
  kill 9, $self->pid;
}



1;
