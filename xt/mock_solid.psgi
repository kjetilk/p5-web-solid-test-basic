#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;

package MockSolid;
use Web::Simple;

sub dispatch_request {
  GET => sub {
    [ 200, [ 'Content-type', 'text/turtle' ], [ 'Hello world!' ] ]
  },
  '' => sub {
    [ 405, [ 'Content-type', 'text/plain' ], [ 'Method not allowed' ] ]
  }
}

MockSolid->run_if_script;
