package PVE::SafeSyslog;

use strict;
use warnings;
use File::Basename;
use Sys::Syslog ();
use Encode;
use base 'Exporter';

our $VERSION = '1.00';

our @EXPORT = qw(syslog initlog);

my $log_tag = "unknown";

# never log to console - thats too slow, and
# it corrupts the DBD database connection!

sub syslog {
    my ($level, @param) = @_;

    $level = 'warning' if $level eq 'warn';

    eval { Sys::Syslog::syslog($level, @param); }; # ignore errors
}

sub initlog {
    my ($tag, $facility) = @_;

    if ($tag) {
        $tag = basename($tag);

        $tag = encode("ascii", decode_utf8($tag));

        $log_tag = $tag;
    }

    $facility = "daemon" if !$facility;

    # never log to console - thats too slow
    Sys::Syslog::setlogsock('unix');

    Sys::Syslog::openlog($log_tag, 'pid', $facility);
}

sub tag {
    return $log_tag;
}

1;
