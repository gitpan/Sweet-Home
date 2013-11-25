package Sweet::HomeDir;
{
  $Sweet::HomeDir::VERSION = '20131125';
}
use Moose;
use MooseX::StrictConstructor;

extends 'Sweet::Dir';

use Try::Tiny;


__PACKAGE__->meta->make_immutable;

1;

