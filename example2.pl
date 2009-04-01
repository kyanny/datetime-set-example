#!/usr/bin/perl
use strict;
use warnings;

use DateTime;
use DateTime::Set;
use DateTime::Span;
use Getopt::Long;

my $date;
GetOptions('date=s' => \$date);

my ($start, $end);
if ($date =~ m{^(\d{4})-(\d{2})-(\d{2})[:/](\d{4})-(\d{2})-(\d{2})$}) {
    $start = DateTime->new(year => $1, month => $2, day => $3, time_zone => 'Asia/Tokyo');
    $end = DateTime->new(year => $4, month => $5, day => $6, time_zone => 'Asia/Tokyo');
}
else {
    die;
}

my $span = DateTime::Span->from_datetimes(start => $start, end => $end);
my $set = DateTime::Set->from_recurrence(
    span => $span,
    recurrence => sub {
        return $_[0]->truncate(to => 'day')->add(days => 1);
    },
);
my @dt = $set->as_list;
for (@dt) {
    warn $_->ymd;
}
