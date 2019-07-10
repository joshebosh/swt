require ESL;

my $con = new ESL::ESLconnection("127.0.0.1", "8021", "ClueCon");

$con->events("plain", "all");

while($con->connected()) {
  #my $e = $con->recvEventTimed(100);
  my $e = $con->recvEvent();

  if ($e) {
    #print $e->serialize();
    my $h = $e->firstHeader();
    while ($h) {
      printf "Header: [%s] = [%s]\n", $h, $e->getHeader($h);
      $h = $e->nextHeader();
    }
  }
}
