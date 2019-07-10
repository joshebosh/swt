<?php
require 'vendor/autoload.php';

$response = new SignalWire\LaML();

$gather = $response->gather(['action' => 'mmv-response.php',
                              'input' => 'dtmf speech',
                             'method' => 'POST',
                            'timeout' => '5',
                      'speechTimeout' => 'auto',
                          'numDigits' => '2',
                              'hints' => 'Joshua Michael, voicemail, hangup',
]);

$gather->say("To speak with me, say Joshua Michael, or press 1", array('voice' => 'man'));
$gather->say("To leave a voice mail, say voicemail, or press 2", array('voice' => 'man'));
$gather->say("If you dont know Joshua, say hangup, or press 3", array('voice' => 'man'));

$response->say("I did not get a response, goodbye", array('voice' => 'man'));

echo $response;

?>