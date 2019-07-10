<?php

require 'vendor/autoload.php';
use SignalWire\Rest\Client;

$response = new SignalWire\LaML();
$response->say("Message being delivered, goodbye.", array('voice' => 'man'));
echo $response;

$_ENV['SIGNALWIRE_API_HOSTNAME'] = "XXXXX.signalwire.com";
//putenv("SIGNALWIRE_API_HOSTNAME=XXXXX.signalwire.com");

$project = 'XXXXX';
$token = 'PTXXXXXX';
$client = new Client($project, $token);

$CELL = "+1XXXXX";
$TO = $_POST['To'];
$FROM = $_POST['From'];
$URL= $_POST['RecordingUrl'];

$message = $client->messages->create($CELL, array("From" => $TO, "Body" => "VM $FROM @ $URL" ));

$message->sid;

?>
