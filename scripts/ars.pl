#!/usr/bin/env perl 

use strict;
use warnings;
use Async::Rand::Server;

my $server = Async::Rand::Server->new;
$server->loop->start;
