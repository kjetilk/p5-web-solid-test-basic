#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 1;
use Web::Solid::Test::HTTPLists;

use Attean::RDF;


is(Web::Solid::Test::HTTPLists::_create_authorization_field(literal('dAhUUt')), 'Bearer dAhUUt', 'Bearer token returned from literal');

done_testing;
