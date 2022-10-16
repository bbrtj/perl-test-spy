package Test::Spy::Facade;

use v5.10;
use strict;
use warnings;

use Moo::Role;
use Mooish::AttributeBuilder;
use Carp qw(croak);

has option 'context' => (
	writer => 1,
	clearer => 1,
);

with qw(Test::Spy::Interface);

sub _get_context
{
	my ($self) = @_;

	croak 'no context was set in ' . ref $self
		unless $self->has_context;

	return $self->context;
}

sub called_times
{
	my ($self, @args) = @_;

	return $self->_get_context->called_times(@args);
}

sub call_history
{
	my ($self, @args) = @_;

	return $self->_get_context->call_history(@args);
}

sub called_with
{
	my ($self, @args) = @_;

	return $self->_get_context->called_with(@args);
}

sub first_called_with
{
	my ($self, @args) = @_;

	return $self->_get_context->first_called_with(@args);
}

sub next_called_with
{
	my ($self, @args) = @_;

	return $self->_get_context->next_called_with(@args);
}

sub last_called_with
{
	my ($self, @args) = @_;

	return $self->_get_context->next_called_with(@args);
}

sub was_called
{
	my ($self, @args) = @_;

	return $self->_get_context->was_called(@args);
}

sub was_called_once
{
	my ($self, @args) = @_;

	return $self->_get_context->was_called_once(@args);
}

sub clear
{
	my ($self, @args) = @_;

	return $self->_get_context->clear(@args);
}

1;

