package Async::Rand::Library;

use 5.014;
use Type::Library
  -base,
  -declare => qw( IP Port );
use Type::Utils -all;
use Types::TypeTiny -all;
use Regexp::Common qw(net);
use Types::Standard -all;

declare "IP", as Str,
  where { m/$RE{net}{IPv4}/ },
  message => {"$_ is not a valid ipv4 address"};

declare "Port", as Int,
  where { $_ > 0 && $_ < 65535 }
  message => { "$_ out of range" };

1;

__END__

=encoding utf-8

=head1 NAME

Async::Rand::Library - simple types definition

=head1 SYNOPSIS

  use Async::Rand::Library qw(IP Port);

=head1 DESCRIPTION

Async::Rand::Library is a collection of types such as IP address, Port numbers,
etc...

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2019- Marco Arthur

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
