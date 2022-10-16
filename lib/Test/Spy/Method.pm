package Test::Spy::Method;

use v5.10;
use strict;
use warnings;

use Moo;
use Mooish::AttributeBuilder;
use Carp qw(croak);

has param 'method_name';

has field 'call_history' => (
	clearer => -hidden,
	lazy => sub { [] },
);

has field '_call_iterator' => (
	writer => 1,
	clearer => 1,
	predicate => 1,
	lazy => sub { 0 },
);

has field '_throws' => (
	writer => 1,
	clearer => 1,
);

has field '_calls' => (
	writer => 1,
	clearer => 1,
);

has field '_returns' => (
	writer => 1,
	clearer => 1,
);

has field '_returns_list' => (
	writer => 1,
	clearer => 1,
);

with qw(Test::Spy::Interface);

sub _increment_call_iterator
{
	my ($self, $count)  = @_;
	$count //= 1;

	$self->_set_call_iterator($self->_call_iterator + $count);

	return;
}

sub called_times
{
	my ($self) = @_;

	return scalar @{$self->call_history};
}

sub called_with
{
	my ($self) = @_;

	return $self->call_history->[$self->_call_iterator];
}

sub first_called_with
{
	my ($self) = @_;

	$self->_set_call_iterator(0);
	return $self->called_with;
}

sub next_called_with
{
	my ($self) = @_;

	$self->_increment_call_iterator
		if $self->_has_call_iterator;

	return $self->called_with;
}

sub last_called_with
{
	my ($self) = @_;

	$self->_set_call_iterator($self->called_times - 1);
	return $self->called_with;
}

sub was_called
{
	my ($self, $times) = @_;

	return $self->called_times == $times if defined $times;
	return $self->called_times > 0;
}

sub was_called_once
{
	my ($self) = @_;

	return $self->was_called(1);
}

sub clear
{
	my ($self) = @_;

	$self->_clear_call_history;
	$self->_clear_call_iterator;

	return $self;
}

sub _forget
{
	my ($self) = @_;

	$self->_clear_returns;
	$self->_clear_returns_list;
	$self->_clear_calls;
	$self->_clear_throws;

	return;
}

sub should_return
{
	my ($self, @values) = @_;

	$self->_forget;

	if (@values == 1) {
		$self->_set_returns($values[0]);
	}
	else {
		$self->_set_returns_list([@values]);
	}

	return $self->clear;
}

sub should_call
{
	my ($self, $sub) = @_;

	croak 'should_call expects a coderef'
		unless ref $sub eq 'CODE';

	$self->_forget;

	$self->_set_calls($sub);

	return $self->clear;
}

sub should_throw
{
	my ($self, $exception) = @_;

	$self->_forget;

	$self->_set_throws($exception);

	return $self->clear;
}

sub _called
{
	my ($self, $inner_self, @params) = @_;

	push @{$self->call_history}, [@params];

	die $self->_throws
		if defined $self->_throws;

	return $self->_calls->($inner_self, @params)
		if $self->_calls;

	return @{$self->_returns_list}
		if $self->_returns_list;

	return $self->_returns;
}

1;

