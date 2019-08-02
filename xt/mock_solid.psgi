#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;

package MockSolid;
use Web::Simple;
use Plack::Middleware::CrossOrigin;

sub dispatch_request {
  'HEAD'=> sub {
	 [ 200,
		[ 'Content-type', 'text/turtle',
		  'Link', '<.acl>; rel="acl", <.meta>; rel="describedBy", <http://www.w3.org/ns/ldp#Resource>; rel="type"'
		],
		[ '' ]
	  ]
	 },
  'GET + /**'=> sub {
	 Plack::Middleware::CrossOrigin->new(origins => 'https://app.example');
  },
	 'GET + /public/**'=> sub {
    [ 200, [ 'Content-type', 'text/turtle' ], [ '</public/verypublic/foobar.ttl#dahut> a <http://example.org/Cryptid> .' ] ]
  },
  'PUT + /public/**' => sub {
    [ 201, [ 'Content-type', 'text/turtle' ], [ '' ] ]
  },
  '' => sub {
    [ 405, [ 'Content-type', 'text/plain' ], [ 'Method not allowed' ] ]
  }
}

MockSolid->run_if_script;
