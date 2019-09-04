#!/usr/bin/env perl 

use Async::Rand::Server;

my $server = Async::Rand::Server->new;
$server->loop->start;
