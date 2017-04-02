package App::Notifier::Service;

use strict;
use warnings;

use IO::Socket::INET ();

use 5.014;

use List::MoreUtils qw();

use POSIX ":sys_wait_h";
use Errno;

sub _reaper
{
    local $!;    # don't let waitpid() overwrite current error
    while ( ( my $pid = waitpid( -1, WNOHANG ) ) > 0 && WIFEXITED($?) )
    {
    }
    $SIG{CHLD} = \&_reaper;    # loathe SysV
}

$SIG{CHLD} = \&_reaper;

my $serving_socket = IO::Socket::INET->new(
    Listen    => 5,
    LocalAddr => 'localhost',
    LocalPort => 6300,
    Proto     => 'tcp'
);
if ( !defined($serving_socket) )
{
    die $@;
}

while (1)
{
    while ( my $conn = $serving_socket->accept() )
    {
        my @cmd_line = ( 'mpv', '/path/to/non-exist.webm' );
        my $pid;
        if ( !defined( $pid = fork() ) )
        {
            die "Cannot fork: $!";
        }
        elsif ( !$pid )
        {
            # I'm the child.
            system { $cmd_line[0] } @cmd_line;
            exit(0);
        }
        $conn->close;
    }
}

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
