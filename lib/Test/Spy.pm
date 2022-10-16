package Test::Spy;

use v5.10;
use strict;
use warnings;

use Moo;
use Mooish::AttributeBuilder;
use Util::H2O;
use Carp qw(croak);

use Test::Spy::Method;

has field 'mocked_subs' => (
	default => sub { {} },
);

has field 'object' => (
	lazy => 1,
	clearer => -hidden
);

with qw(Test::Spy::Facade);

sub _no_method
{
	my ($self, $method_name) = @_;

	croak "method $method_name was not mocked!";
}

sub _build_object
{
	my ($self) = @_;

	my %methods = %{$self->mocked_subs};
	my %init_hash;

	for my $method_name (keys %methods) {
		my $method = $self->mocked_subs->{$method_name};
		$init_hash{$method_name} = sub {
			return $method->_called(@_);
		};
	}

	return h2o -meth, \%init_hash;
}

sub add_method
{
	my ($self, $method_name, @returns) = @_;

	$self->_clear_object;
	my $method = $self->mocked_subs->{$method_name} = Test::Spy::Method->new(method_name => $method_name);

	if (@returns) {
		$method->should_return(@returns);
	}

	return $method;
}

sub method
{
	my ($self, $method_name) = @_;

	return $self->mocked_subs->{$method_name}
		// $self->_no_method($method_name);
}

sub call_history
{
	my ($self) = @_;

	my $context = $self->context;
	croak 'no context was set in ' . ref $self
		unless $self->has_context && $context;

	return $self->mocked_subs->{$context}->call_history
		// $self->_no_method($context);
}

1;

