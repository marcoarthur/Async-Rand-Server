requires 'Log::Log4perl';
requires 'Mojo::IOLoop';
requires 'Moose';
requires 'Moose::Role';
requires 'Regexp::Common';
requires 'Type::Library';
requires 'Type::Utils';
requires 'Types::Standard';
requires 'Types::TypeTiny';
requires 'autodie';
requires 'experimental';
requires 'perl', '5.014';

on configure => sub {
    requires 'Module::Build::Tiny', '0.034';
};

on test => sub {
    requires 'Test::More';
};
