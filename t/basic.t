use strict;
use Test2::V0;
use Async::Rand::Server;

my $server = Async::Rand::Server->new;

isa_ok $server, 'Async::Rand::Server';
can_ok $server, qw( loop start stop protocol port address logger );

for my $msg ( "GET\n", "NON-VALID\n", "QUIT" ) { 
    $server->loop->client(
        { address => $server->address, port => $server->port },
        sub {
            my ( $loop, $err, $stream ) = @_;

            if ($err) {
                die "Shamefull error ocurred $err";
            }

            $stream->on(
                read => sub {
                    my ( $stream, $bytes ) = @_;

                    ok length($bytes), "Non empty"; # always answer
                    ok $bytes < 1, "Can't exceed one" if $msg =~ /get/i; # get number
                    ok $bytes =~ /error/i if $msg =~ /non-valid/i; # bad command
                    if ($msg =~ /quit/i ) {
                        is $bytes, "Bye bye\n", 'Bye bye response during quit';
                        $loop->stop; # stop client also
                    }
                    note "$bytes";
                }
            );
            $stream->write($msg);
        }
    );
}

$server->start;

done_testing;
