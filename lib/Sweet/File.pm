package Sweet::File;
$Sweet::File::VERSION = '20140218';
use Moose;
use MooseX::StrictConstructor;

use Try::Tiny;

use File::Copy;
use File::Spec;
use File::Touch;
use File::Remove 'remove';
use MooseX::Types::Path::Class;

has dir => (
    builder   => '_build_dir',
    is        => 'rw',
    isa       => 'Sweet::Dir',
    lazy      => 1,
    predicate => 'has_dir',
);

has name => (
    builder   => '_build_name',
    is        => 'rw',
    isa       => 'Str',
    lazy      => 1,
    predicate => 'has_name',
);

has path => (
    builder => '_build_path',
    coerce  => 1,
    is      => 'rw',
    isa     => 'Path::Class::File',
    lazy    => 1,
);

sub _build_path {
    my $self = shift;

    my $name = $self->name;
    my $dir  = $self->dir;

    my $dir_path = $dir->path;

    my $path = File::Spec->catfile( $dir_path, $name );

    return $path;
}

#TODO create
#sub create {
#    my $self = shift;
#
#    my $path = $self->path;
#
#    print $path, "\n";
#
#    try {
#        touch($path);
#    }
#    catch {
#        warn $_;
#    };
#}

sub copy_to_dir {
    my $self = shift;

    my $dir = shift;

    my $name = $self->name;

    my $file_copied = try {
        Sweet::File->new( dir => $dir, name => $name );
    }
    catch {
        #TODO fai il throw
        warn $_;
    };

    my $source_path = $self->path;
    my $target_path = $file_copied->path;

    try {
        #TODO questo dovrebbe farlo il create
        $dir->is_a_directory or $dir->create;
    }
    catch {
        #TODO fai il throw
        warn $_;
    };

    try {
        copy( $source_path, $target_path );
    }
    catch {
        #TODO fai il throw
        warn $_;
    };

    return $file_copied;
}

# TODO sub move_to_dir {
#
#    #TODO usa move di File::Copy
#}

#TODO
#sub copy_to_file {
#    my $self = shift;
#
#    my $target_file = shift;
#
#}

sub does_not_exists {
    return !-e shift->path;
}

sub erase {
    remove( shift->path );
}

sub has_zero_size {
    return -z shift->path;
}

sub is_a_plain_file {
    return -f shift->path;
}

sub is_executable {
    return -x shift->path;
}

sub is_writable {
    return -w shift->path;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Sweet::File

=head1 VERSION

version 20140218

=head1 AUTHOR

G. Casati <fibo@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by G. Casati.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
