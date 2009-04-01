#!/usr/bin/perl
use strict;
use warnings;
use DateTime;
use DateTime::Set;
use DateTime::Span;
use Data::Dumper;

my $d1 = DateTime->new(year => 2009, month => 2, day => 27);
my $d2 = DateTime->new(year => 2009, month => 4, day => 1);

my $span = DateTime::Span->from_datetimes(start => $d1, end => $d2);

# recurrence
my $days = DateTime::Set->from_recurrence(
    span => $span,
    recurrence => sub {
        return $_[0]->truncate(to => 'day')->add(days => 1)
    },
);

warn $days;
warn $days->min;
warn $days->max;

warn '='x80;

# iterator
my $iter = $days->iterator;
while (my $d = $iter->next) {
    warn $d->ymd;
}

warn '='x80;

# as_list
my @dt = $days->as_list;
warn $_->ymd for @dt;

warn '='x80;

# map
my $set1 = $days->map(
    sub {
        return $_->add(days => 99);
    }
);
warn $_->ymd for $set1->as_list;

warn '='x80;

my $set2 = $days->grep(
    sub {
        return ($_->day % 2) != 0;
    }
);
warn $_->ymd for $set2->as_list;
