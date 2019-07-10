# Copyright (c) 2015 Stanislav Sinyagin <ssinyagin@k-open.com>

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

use strict;
use warnings;
use Getopt::Long;
use Time::HiRes;
use POSIX;
use ESL;

$| = 1;

my $fs_host = '192.168.150.3';
my $fs_port = 8021;
my $fs_password = 'ClueCon';

my $callerid = '18005551212';
my $dest = '3500';
my $playback = '${recordings_dir}/josh_video_loop.mp4';
my $context = 'default';
my $endpoint;

my $duration = 60;
my $ncalls = 10;
my $forever;
my $interval;
my $cps = 1;
my $rnd_interval;
my $rnd_cps;


my $help_needed;

my $ok = GetOptions
    (
     'fs_host=s'     => \$fs_host,
     'fs_port=s'     => \$fs_port,
     'fs_password=s' => \$fs_password,
     'cid=s'         => \$callerid,
     'dest=s'        => \$dest,
     'context=s'     => \$context,
     'endpoint=s'    => \$endpoint,
     'duration=i'    => \$duration,
     'ncalls=i'      => \$ncalls,
     'forever'       => \$forever,
     'cps=f'         => \$cps,
     'interval=f'    => \$interval,
     'rc=f'          => \$rnd_cps,
     'ri=f'          => \$rnd_interval,
     'play=s'        => \$playback,
     'help'          => \$help_needed,
    );


if( not $ok or $help_needed or scalar(@ARGV) > 0 )
  {
    print STDERR "Usage: $0 --cps=10 [options...]\n",
    "Options:\n",
    "  --fs_host=HOST    \[$fs_host\] FreeSWITCH host\n",
    "  --fs_port=PORT    \[$fs_port\] FreeSWITCH ESL port\n",
    "  --fs_password=PW  \[$fs_password\] FreeSWITCH ESL password\n",
    "  --cid=NUMBER      \[$callerid\] caller ID\n",
    "  --dest=NUMBER     \[$dest\] destination number\n",
    "  --context=NAME    \[$context\] FreeSWITCH context name\n",
    "  --endpoint=STRING destination endpoint\n",
    "  --duration=N      \[$duration\] call duration in seconds\n",
    "  --ncalls=N        \[$ncalls\] total number of calls\n",
    "  --forever         run endlessly and ignore ncalls\n",
    "  --cps=F           rate in calls per second\n",
    "  --interval=F      interval between calls in seconds (CPS\*\*-1)\n",
    "  --rc=F            random factor in CPS (should be higher than CPS*2)\n",
    "  --ri=F            random factor in interval (should be less than interval/2)\n",
    "  --play=STRING     \[$playback\] playback argument\n",
    "  --help            this help message\n",
    "\n",
    "If endpoint is specified, --dest and --context are ignored.\n",
    "Otherwise, the call is sent to the loopback endpoint with the specified\n",
    "context and destination number\n",
    "The question mark characters (?) in numbers are replaced with random digits\n",
    "\n",
    ;
    exit 1;
  }

if( defined($cps) and defined($interval) )
  {
    print STDERR "Only one of CPS and interval must be defined\n";
    exit 1;
  }

if( not defined($cps) and not defined($interval) )
  {
    print STDERR "Either CPS or interval must be defined\n";
    exit 1;
  }

if( defined($rnd_cps) )
  {
    if( not defined($cps) )
      {
        print STDERR "--rc can only be defined together with --cps\n";
        exit 1;
      }
    elsif( $rnd_cps < $cps * 2 )
      {
        print STDERR "--rc shoudl be higher than CPS*2\n";
        exit 1;
      }
  }

if( defined($rnd_interval) )
  {
    if( not defined($interval) )
      {
        print STDERR "--ri can only be defined together with --interval\n";
        exit 1;
      }
    elsif( $rnd_interval > $interval / 2 )
      {
        print STDERR "--ri should be lower than interval/2\n";
        exit 1;
      }
  }



my $originate_string =
    'originate ' .
    '{ignore_early_media=true,' .
    'origination_uuid=%s,' . 
    'originate_timeout=60,' .
    'origination_caller_id_number=' . $callerid . ',' .
    'origination_caller_id_name=dialer_pl}';

if( defined($endpoint) )
  {
    $originate_string .= $endpoint;
  }
else
  {
    $originate_string .= 'loopback/' . $dest . '/' . $context;
  }

$originate_string .=  ' ' . '&playback(' . $playback . ')';


my $esl = new ESL::ESLconnection($fs_host,
                                 sprintf('%d', $fs_port),
                                 $fs_password);

$esl->connected() or die("Cannot connect to FreeSWITCH");

if( not defined($interval) )
  {
    $interval = 1.0/$cps;
  }

if( defined($rnd_cps) )
  {
    $rnd_interval = 1.0/$rnd_cps;
  }

my $nc = 0;
my $start = Time::HiRes::time();

while( $forever or $nc < $ncalls )
  {
    my $next_time = $start + $nc * $interval;

    if( defined($rnd_interval) )
      {
        $next_time += rand($rnd_interval);
      }

    # Replace "?" with random digits
    my $orig_str = $originate_string;
    while( $orig_str =~ /\?/o )
      {
        my $random_digit = sprintf('%d', rand(10));
        $orig_str =~ s/\?/$random_digit/;
      }

    my $now = Time::HiRes::time();
    if( $next_time > $now )
      {
        Time::HiRes::sleep($next_time - $now);
      }

    my $uuid = $esl->api('create_uuid')->getBody();
    my ($time_epoch, $time_hires) = Time::HiRes::gettimeofday();
    $esl->bgapi(sprintf($orig_str, $uuid));
    $esl->bgapi(sprintf('sched_hangup +%d %s', $duration, $uuid));

    printf("%.6d: %s.%.6d\n",
           $nc,
           POSIX::strftime('%Y-%m-%d %H:%M:%S', localtime($time_epoch)),
           $time_hires);
    $nc++;
  }
