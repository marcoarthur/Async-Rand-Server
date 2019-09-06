package Async::Rand::Server;

use Moose;
use 5.014;
use experimental qw(signatures);
use autodie qw(:all);
use Async::Rand::Library -all;
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

# create the server
sub BUILD {
    my $self = shift;

    $self->info("Creating a server, pid: $$");

    $self->loop->server(
        {
            port    => $self->port,
            address => $self->address,
        } => sub {
            my ( $loop, $stream, $id ) = @_;

            $stream->on( read => \&_reader_handler );
			$stream->on( finish => \&_finish_handler );
        }
    );

	$self->info("Listening on port:" . $self->port);
}

# TODO:  protocol to talk client
sub _reader_handler {
    my ( $stream, $bytes ) = @_;
    say "I saw $bytes bytes";
    $stream->write("Hello There! I read $bytes bytes\n");
}

# TODO: protocol to finish/close client
sub _finish_handler {
	...
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
