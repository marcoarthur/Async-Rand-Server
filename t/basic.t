use strict;
use Test2::V0;
use Async::Rand::Server;

my $server = Async::Rand::Server->new;

isa_ok $server, 'Async::Rand::Server';
can_ok $server, qw( loop start stop protocol port address logger );

done_testing;
