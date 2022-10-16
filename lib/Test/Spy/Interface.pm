package Test::Spy::Interface;

use v5.10;
use strict;
use warnings;

use Moo::Role;

requires qw(
	called_times
	call_history
	called_with
	first_called_with
	next_called_with
	last_called_with
	was_called
	was_called_once
	clear
);

1;

