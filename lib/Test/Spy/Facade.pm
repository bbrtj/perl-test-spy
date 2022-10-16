package Test::Spy::Facade;

use v5.10;
use strict;
use warnings;

use Moo::Role;
use Mooish::AttributeBuilder;

has option 'context' => (
	writer => 1,
	clearer => 1,
);

with qw(Test::Spy::Interface);

1;

