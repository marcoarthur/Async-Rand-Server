package Async::Rand::Protocol;

use Moose;
use 5.014;
use experimental qw(signatures switch);
use Mojo::IOLoop::Stream;
our $VERSION = '0.01';
our @CMDS    = qw( QUIT GET );

has stream => (
    is  => 'rw',
    isa => 'Mojo::IOLoop::Stream',
);

sub generate( $self ) {
    $self->stream->write( rand . "\n" );
    $self->stream->close_gracefully;
}

sub quit ( $self ) {
    $self->stream->write("Bye bye\n");
    $self->stream->close_gracefully();
}

sub error ( $self, $cmd ) {
    $self->stream->write("Error don't know this cmd $cmd\n");
    $self->stream->write( "Commands: " . join( " ", @CMDS ) . "\n" );
}

sub parse ( $self, $cmd ) {
    chomp($cmd);

    given ($cmd) {
        when (/QUIT/i) { $self->quit() }
        when (/GET/i)  { $self->generate() }
        default        { $self->error($cmd) }
    }
}

1;

__END__

=encoding utf-8

=head1 NAME

Async::Rand::Protocol - Blah blah blah

=head1 SYNOPSIS

  use Async::Rand::Protocol;

=head1 DESCRIPTION

Async::Rand::Protocol is

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2019- Marco Arthur

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
