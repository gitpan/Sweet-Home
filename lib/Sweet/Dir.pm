package Sweet::Dir;
{
  $Sweet::Dir::VERSION = '20131029';
}
use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;

use Try::Tiny;

use MooseX::Types::Path::Class;
use File::Path qw(make_path remove_tree);

use Sweet::File;

=head1 SYNOPSIS

    my $dir = Sweet::Dir->new(path => '/path/to/dir');
    $dir->create;

=cut

has 'path' => (
    builder  => '_build_path',
    coerce   => 1,
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    required => 1,
);

sub create {
    my $self = shift;
    my $path = $self->path;
    my $make_path_error;

    return $self if $self->is_a_directory;

    make_path( $path, { error => \$make_path_error } );

    #TODO lancia eccezione, scrivi classe eccezioni, test e aggiorna synopsis
}

sub does_not_exists {
    return !-d shift->path;
}

sub erase {
    my $self = shift;
    my $path = $self->path;
    my $remove_path_error;

    remove_path( $path, { error => \$remove_path_error } );

    #TODO lancia eccezione, scrivi classe eccezioni, test e aggiorna synopsis
}

sub file {
    my $self = shift;

    my $name = shift;

    #TODO try file
    my $file = Sweet::File->new( dir => $self, name => $name );

    return $file;
}

sub is_a_directory {
    return -d shift->path;
}

#TODO sub file_list
#

sub sub_dir {
    my $self = shift;

    my @path = @_;

    # TODO try

    my $sub_dir_path = File::Spec->catfile( $self->path, @path );

    my $sub_dir = BI::Dir->new( path => $sub_dir_path );

    return $sub_dir;
}

__PACKAGE__->meta->make_immutable;

1;

