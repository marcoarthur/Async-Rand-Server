package Async::Rand::Server;

use strict;
use 5.014;
use experimental qw(signatures);
use Moose;
use autodie qw(:all);
use Data::Dumper;
with qw( Async::Role::Loopable Async::Role::Logging );

our $VERSION = '0.01';
use constant {
    DEFAULT_PORT => 3500,
    LOG_LEVEL    => 'DEBUG'
};

has port => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
    default  => DEFAULT_PORT,
);

sub BUILD {
    my $self = shift;

    $self->info("Creating a server, pid: $$");
    my $server = {
        type => 'server',
        args => {
            {
				port => $self->port,
				address => '127.0.0.1',
			} => sub {
                my ( $loop, $stream, $id ) = @_;

				# Define a handler for the stream
                my $handler = sub {
                    my ( $stream, $bytes ) = @_;
                    say "I saw $bytes bytes";
                    $stream->write("Hello There! I read $bytes bytes\n");
                };

                $stream->on( read => $handler );
            }
        }
    };

    $self->add($server);
    $self->info( "Listing on port " . $self->port );

	my $timer = {
		type => 'recurring',
		args => {
			1 => sub {
				state $c = 0;
				$self->warn('Timer event ' . $c);
				$c++;
			}
		}
	};

	$self->info("Add a timer");
	$self->add($timer);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf-8

=head1 NAME

Async::Rand::Server - Blah blah blah

=head1 SYNOPSIS

  use Async::Rand::Server;

=head1 DESCRIPTION

Async::Rand::Server is

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2019- Marco Arthur

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
