<?php
require 'vendor/autoload.php';

$response = new SignalWire\LaML();
$dial = $response->dial();

//Diagnostics for self testing script
//php mmv-response.php 1 or 2 or 3 or "Joshua Michael" or voicmail or hangup
if ( $argv[1] == "1" || $argv[1] == "2" || $argv[1] == "3" ) {
	$_POST['Digits'] = $argv[1];
} elseif ( $argv[1] == "Joshua Michael" || $argv[1] =="voicemail" || $argv[1] == "hangup" ) {
	$_POST['SpeechResult'] = $argv[1];
}

//XML Producer for POST requests
if ( $_POST["Digits"] == "1" || $_POST["SpeechResult"] == "Joshua Michael" ) {
	$dial->number("+XXXXX");
} elseif ( $_POST["Digits"] == "2" || $_POST["SpeechResult"] == "voicemail" ) {
	$response->say("Please leave a voicemail after the beep.", array('voice' => 'man'));
	$response->record(array('action' => 'deliver-vm.php', 'method' => 'POST', 'timeout' => 60 ));
} elseif ( $_POST["Digits"] == "3" || $_POST["SpeechResult"] == "hangup" ) {
	$response->say("You have a good day, bye bye now.");
	$response->hangup();
} else {
	$response->say("Incorrect choice. Hanging up.");
}

echo $response;

?>
