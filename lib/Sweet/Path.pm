package Sweet::Path;
{
  $Sweet::Path::VERSION = '20131029';
}
use Moose;
use MooseX::StrictConstructor;

use Try::Tiny;


__PACKAGE__->meta->make_immutable;

1;

