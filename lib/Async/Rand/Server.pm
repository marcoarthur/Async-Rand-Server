package Async::Rand::Server;

use Moose;
use 5.014;
use experimental qw(signatures);
use autodie qw(:all);
use Async::Rand::Library -all;
use Async::Rand::Protocol;
with qw( Async::Role::Loopable Async::Role::Logging );

our $VERSION = '0.01';
use constant {
    DEFAULT_PORT    => 3500,
    LOG_LEVEL       => 'DEBUG',
    DEFAULT_ADDRESS => '127.0.0.1',
};

has port => (
    is       => 'ro',
    isa      => Port,
    required => 1,
    default  => DEFAULT_PORT,
);

has address => (
    is       => 'ro',
    isa      => IP,
    required => 1,
    default  => DEFAULT_ADDRESS,
);

has protocol => (
    is       => 'ro',
    isa      => 'Async::Rand::Protocol',
    required => 1,
    default  => sub { Async::Rand::Protocol->new },
);

# create the server
sub BUILD {
    my $self = shift;
    $self->logger->level(LOG_LEVEL);

    $self->info("Creating a server, pid: $$");

    $self->loop->server(
        {
            port    => $self->port,
            address => $self->address,
        } => sub {
            my ( $loop, $stream, $id ) = @_;

            $stream->on( read   => $self->make_handler('_reader') );
            $stream->on( finish => $self->make_handler('_finisher') );
        }
    );

    $self->info( "Listening on port " . $self->port );
    $self->set_signals_handler();
}

sub make_handler ( $self, $handler_name ) {
    my $ref = $self->can($handler_name);

    $self->fatal("Can't find a handler for $handler_name") unless $ref;

    return sub {
        my ( $stream, $byte ) = @_;
        $self->$ref( $stream, $byte );
    };
}

sub _reader ( $self, $stream, $bytes ) {
    $self->info("Client send cmd $bytes");
    $self->protocol->stream($stream);
    $self->protocol->parse($bytes);
}

sub _finisher ( $self, $stream, $bytes ) {
    $self->info("Server shutdown");
}

sub set_signals_handler( $self ) {
    my $stopper = sub {
        $self->info("Stopping the server");
        $self->stop;
    };

    $SIG{$_} = $stopper for qw(INT QUIT);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf-8

=head1 NAME

Async::Rand::Server - This simple get you back a random number

=head1 SYNOPSIS

  use Async::Rand::Server;

=head1 DESCRIPTION

Async::Rand::Server is just for the fun of creating a stupid non blocking server

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2019- Marco Arthur

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
