const signalwire = require('@signalwire/node');
var express = require("express");
var app = express();

app.get("/main-menu", (req, res, next) => {
    var response = new signalwire.RestClient.LaML.VoiceResponse();
    var gather = response.gather({ action: 'http://sub.domain.com:3000/mmv-response',
				   method: 'GET',
				   input: 'dtmf speech',
				   hints: 'help, conference, expert'
				 })
    gather.say("Hello, you've reached the node JS IVR.", {voice: 'man'});
    gather.say("If you're a customer in need of help, press 1, or say help.", {voice: 'man'});
    gather.say("If you have been invited to a conference, press 2, or say conference.", {voice: 'man'});
    gather.say("If you're an expert assisting customers, press 3, or say expert.", {voice: 'man'});
    response.say("here is non-response response, goodbye");

    res.set('Content-Type', 'text/xml');
    res.send(response.toString());
    console.log("main-menu Request Params from server  --->" + JSON.stringify(req.query));
});

app.get("/mmv-response", (req, res, next) => {
    var response = new signalwire.RestClient.LaML.VoiceResponse();
    var dial = response.dial();
    var digits = req.query.Digits;
    var speech = req.query.SpeechResult;

    if ( digits == "1" || speech == "help" ){ response.enqueue('joshebosh'); }
    else if ( digits == "2" || speech == "conference" ){ dial.conference('joshebosh'); }
    else if ( digits == "3" || speech == "expert" ){ dial.queue('joshebosh');
						     response.redirect('http://sub.domain.com:3000/requeue-agent', {method: 'GET'});
						   }
    else { response.say('incorrect option. Goodbye.'); }

    res.set('Content-Type', 'text/xml');
    res.send(response.toString());
    console.log("mmv-response Request Params from server  --->" + JSON.stringify(req.query));
});

app.get("/requeue-agent", (req, res, next) => {
    var response = new signalwire.RestClient.LaML.VoiceResponse();
    var dial = response.dial();

    dial.queue('joshebosh');

    res.set('Content-Type', 'text/xml');
    res.send(response.toString());
    console.log(response.toString());
    console.log("mmv-response Request Params from server  --->" + JSON.stringify(req.query));

});

//START SERVER
app.listen(3000, () => { console.log("Server running on port 3000"); });


//const project = '981ab3f3-3bee-408f-ad96-5ebe87c318ac';
//const token = 'PT5716c661760815f0c1ef236dcfa8410f9b701b606e1e8d88';
//const RestClient = require('signalwire').RestClient;
//const client = new RestClient(project, token);
//client.messages
//    .create({from: '+12012673379', body: 'test message from shsahi ignore ', to: '+19312989898', statusCallback:'http://139.59.81.245', mediaUrl: 'https://callerwho.com/uploads/mms/20190107_chip-gorman.vcf'})
//    .then(message => console.log(message.sid))
//    .done();
