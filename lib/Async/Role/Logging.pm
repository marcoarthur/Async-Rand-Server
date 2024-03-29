package Async::Role::Logging;

use 5.014;
use Moose::Role;
use experimental qw(signatures);
use Log::Log4perl qw(:easy);
use Data::Dumper;
our $VERSION = '0.02';

has logger => (
    is      => 'ro',
    isa     => 'Log::Log4perl::Logger',
    default => sub {
        Log::Log4perl->easy_init(
            {
                level  => $DEBUG,
                layout => '%d %-5p %m%n',
            }
        );
        Log::Log4perl->get_logger();
    },
    handles => {
        debug => 'debug',
        warn  => 'warn',
        error => 'error',
        info  => 'info',
        fatal => 'fatal',
    }
);

sub dump ( $self, @args ) {

    foreach my $arg (@args) {
        $self->debug( sprintf "%s", Dumper($arg) );
    }
}

1;

__END__

=encoding utf-8

=head1 NAME

Async::Role::Logging - Blah blah blah

=head1 SYNOPSIS

  use Async::Role::Logging;

=head1 DESCRIPTION

Async::Role::Logging is

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2019- Marco Arthur

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
