package Async::Role::Loopable;

use strict;
use 5.014;
our $VERSION = '0.01';

use Moose::Role;
use Mojo::IOLoop;
use experimental qw(signatures);
use Carp;

has loop => (
    is      => 'ro',
    isa     => 'Mojo::IOLoop',
    lazy    => 1,
    default => sub { Mojo::IOLoop->new }
);

sub start( $self ) {
    $self->loop->start unless $self->loop->is_running;
}

sub add ( $self, $subscriber ) {
    my ( $type, $args ) = @$subscriber{qw( type args )};

    croak "Need type and arguments" unless $type && $args;

    $self->loop->$type( %{$args} );
}

1;
__END__

=encoding utf-8

=head1 NAME

Async::Role::Loopable - Blah blah blah

=head1 SYNOPSIS

  use Async::Role::Loopable;

=head1 DESCRIPTION

Async::Role::Loopable is

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2019- Marco Arthur

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
