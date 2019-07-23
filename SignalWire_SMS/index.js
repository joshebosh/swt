/*/
//    Do some installation prequisite commands on your server project directory
//
    npm install express --save
    npm install @signalwire/node --save
    npm install body-parser --save
    npm install ws --save
    npm install fs --save
    npm install http --save
    npm install https --save
    npm install util --save
    npm install process --save
    npm install child_process --save
*/

// use strict syntax checking to help find common errors
'use strict';

// utilize and processing tools for debugging objects
const util = require('util');
const process = require('process');

// initiallize some empty global variables to prevent if clause choking
var port;
var sport;
var ip;
var pk;
var at;
var su;
var pn;
var cn;
var sms;

// these are used in the callbacks section and are define there
var la;
var cb;

// declared for security certs
var privkey;
var cert;
var fullchain;

/******************************
 setup your personal variables
******************************/
function get_vars() {
    // your local port
    port='3000';

    // local https port
    sport='3001';

    // your local ip address of your server
    ip='192.168.X.X';

    // your space name url
    su='example.signalwire.com';

    // your project key
    pk='XXXXXXXX';

    // your api token
    at='XXXXXXXXXX';

    // your signalwire phone number
    pn='+1XXXXXXXXX';

    // your cellphone number
    cn='+1XXXXXXXXXX';

    // body of sms message
    sms = 'welcome to signalwire';

    // specify paths to your certs
    //privkey = '/etc/letsencrypt/live/XXXX/privkey.pem';
    //cert = '/etc/letsencrypt/live/XXXX/cert.pem';
    //fullchain = '/etc/letsencrypt/live/XXXX/fullchain.pem';

}


/////////////////////////////////////////////////////////
//
//  There are various sections you can enable/disable.
//  Only enable one section at a time.
//  Each section themselves are complete minimum examples.
//  They will NOT work if multiple sections are enabled.
//  You can set your SignalWire particulars above once.
//  Each section will make a function call to those vars.
//
//    SECTIONS:
//
//      -> START/END MINIMUM SERVER FOR OUTGOING MESSAGE
//           Very bare bones, but works on sending messages from server to SignalWire.
//
//      -> START/END MINIMUM SERVER FOR GET REQUEST - INCOMING MESSAGE
//           Very bare bones, but works on recieving messages from SignalWire to Server
//
//      -> START/END MINIMUM SERVER FOR INCOMING MESSAGE AUTO REPLY - GET REQUEST
//           Send a message to your sw number, and you should receive and automatic reply.
//           This section generates a LaML response for SignalWire to process.
//
//      -> START/END MINIMUM SERVER FOR MESSAGE RELAY - LaML REDIRECT - POST REQUEST
//           Getting deeper into capabilites. This will keep both end users numbers private..
//           Communicating both ways through a single SignalWire Number.
//           Can parse a special self desgned message format for initiating messages as the owner.
//           Review server startup logs for more info.
//
//      -> START/END MINIMUM SERVER FOR STATUS CALLBACKS - GET AND POST
//           Getting better. This is how to setup server for callbacks.
//           Do some "curl" GET/POST requests or visit url as seen in server startup log.
//
//      -> START/END MINIMUM SERVER FOR CLIENT WEBSOCKET COMMUNICATION
//           This is basic example for completion sake. Web client and Server can communicate.
//           GET and POST requests should work between client/server and server/SignalWire.
//           And Websocket communication between client/server should allow 2 way data flow.
//           You should be able to send out bulk messages at this point.
//           You should be able to visit the web client when hosted from anywhere of your choosing.
//           Or visited the web client hosted from the nodejs server itself. See startup log for links.
//
/////////////////////////////////////////////////////////







/*
////////////////////////////////////////////////
// START MINIMUM SERVER FOR OUTGOING MESSAGE
////////////////////////////////////////////////
// THIS WILL CHARGE ACCOUNT FOR ONE OUTBOUND SMS
////////////////////////////////////////////////

// function call to get peronal vars.
if (typeof get_vars === "function") {
    get_vars()
}

const { RestClient } = require('@signalwire/node');
const signalwire = new RestClient( pk, at, { signalwireSpaceUrl: su });

signalwire.messages
.create({ from: pn, to: cn, body: sms })
.then( sw_json_response => {
  console.log(sw_json_response);
  console.log("Your Message Sid: " + sw_json_response.sid)})
.catch( error => { console.log(error) })
.done(console.log("sending message, awaiting JSON response from SignalWire..."));
//////////////////////////////////////////
// END MINIMUM SERVER FOR OUTGOING MESSAGE
//////////////////////////////////////////
*/









/*
//////////////////////////////////////////////////////////
// START MINIMUM SERVER FOR GET REQUEST - INCOMING MESSAGE
//////////////////////////////////////////////////////////
// SENDING MESSAGE TO THIS WILL CHARGE ACCOUNT FOR ONE INBOUND SMS
//////////////////////////////////////////////////////////////////

// function call to get personal vars.
if (typeof get_vars === "function") {
  get_vars()
}

const express = require('express');
const server = express();
const { RestClient } = require('@signalwire/node');
const signalwire = new RestClient( pk, at, { signalwireSpaceUrl: su });

server.get("/sendSMS", function (req,res) {
    //console.log(req)  // versose request info
    console.log(req.query)

    // notice in dashboard LaML Messaging Logs, it show failed, even though the message indeed reached our server
    res.send("GET Request is working. Ready for inbound SMS.")

    // comment above, uncomment below, to simply add an empy response element back to SignalWire so it will show success.
    //res.set('Content-Type', 'text/xml');
    //res.send('<Response></Response>')
});

server.listen(port, ip);
console.log('now listening on port ' + port + ' at ip ' + ip);
console.log('\nGo to this url in browser to the server is working:\n  \x1b[33m%s\x1b[0m',  'http://' + ip + ':' + port + '/sendSMS?testing=cool%20it%20works')
console.log("\nor issue this curl command in another terminal to view the same:\n  \x1b[33mcurl -X GET %s\x1b[0m",  "http://" + ip + ":" + port + "/sendSMS?testing=cool%20it%20works")
console.log('\nsend an sms to \x1b[33m%s\x1b[0m and view node console log', pn)
////////////////////////////////////////////////////////
// END MINIMUM SERVER FOR GET REQUESTS - INCOMING MESSAGE
////////////////////////////////////////////////////////
*/










/*
//////////////////////////////////////////////////////////////////////
// START MINIMUM SERVER FOR INCOMING MESSAGE AUTO REPLY - GET REQUEST
//////////////////////////////////////////////////////////////////////
// THIS WILL CHARGE FOR TWO SMS, ONE INBOUND SMS, AND ONE OUTBOUND SMS
//////////////////////////////////////////////////////////////////////

// function call to get personal vars.
if (typeof get_vars === "function") {
    get_vars()
}

const express = require('express');
const server = express();
const { RestClient } = require('@signalwire/node');
const signalwire = new RestClient( pk, at, { signalwireSpaceUrl: su });

server.get("/sendSMS", function (req,res) {
    console.log("GET Request from SignalWire to nodejs:\n" + JSON.stringify(req.query));
    res.set('Content-Type', 'text/xml');
    res.send('<Response><Message>Its working. This is a GET Response from nodejs to generate LaML for SignalWire to process.\nMessageSid: ' + req.query.MessageSid + '</Message></Response>');
});


// puts the server into operation
if ((ip !== "SERVER_IP_HERE" ) && ( port !== '' )) {
    server.listen(port, ip);
    console.log('now listening on port ' + port + ' at ip ' + ip);
    console.log("\nGo to this url in browser and see LaML generation and make sure it's working:\n  \x1b[33m%s\x1b[0m",  "http://" + ip + ":" + port + "/sendSMS")
    console.log("\nOr issue this curl command in another terminal to see LaML generation is working:\n  \x1b[33mcurl -X GET %s\x1b[0m",  "http://" + ip + ":" + port + "/sendSMS")
    console.log('\nGo to SignalWire dashboard \x1b[33mPhone Number > Edit Settings > WHEN A MESSAGE COMES IN:\x1b[0m and set url to \x1b[33mhttp://' + ip + ':3000/sendSMS\x1b[0m')
    console.log('\nNow send an sms to \x1b[33m%s\x1b[0m and await the auto-reply\n', pn)
} else {
    console.log("ERROR: Please give variables \"ip=" + ip + "\" and \"port=" + port + "\" proper values")
}
///////////////////////////////////////////////////////////////////
// END MINIMUM SERVER FOR INCOMING MESSAGE AUTO REPLY - GET REQUEST
///////////////////////////////////////////////////////////////////
*/









/*
////////////////////////////////////////////////////////////////////////
// START MINIMUM SERVER FOR MESSAGE RELAY - LaML REDIRECT - POST REQUEST
/////////////////////////////////////////////////////////////////
// EDIT PHONE SETTINGS IN SIGNALWIRE DASHBOARD TO "POST"
// YOU WILL BE CHARGED FOR 4 SMS prices using this.
//   1. Inbound from somebody to server.
//   2. Outbound from server to you.
//   3. Inbound from you to server.
//   4. Outbound from server to somebody.
////////////////////////////////////////////////////////

// function call to get personal vars.
if (typeof get_vars === "function") {
  get_vars()
}

const express = require('express');
const server = express();
const { RestClient } = require('@signalwire/node');
const signalwire = new RestClient( pk, at, { signalwireSpaceUrl: su });

// needed for POST requests
const bp = require('body-parser');
server.use(bp.urlencoded({ extended: true }));

// needed to get external ip for help/log print outs when starting server. Not really used in nodejs functions.
const { execSync } = require('child_process');
var eip = execSync('curl --silent ifconfig.me')

// declare a var to keep track of somebody's number who is intiating an sms to me.
// In real world, this might be a database call. But a global var for training will do
var initiator = 'none'

server.post("/sendSMS", function (req,res) {
    console.log('entering POST request')
    console.log(req.body)

    // first we check if initiator isnt me, then just forward message to my cell.
    if ( req.body.From !== cn ) {
	console.log("\nsomebody initiated an sms to you\n")

	// remember who sent you the sms
	initiator = req.body.From
	// clear the remberance after 5 minutes, is case you forget to "RESET" manually (see below)
	setTimeout(() => { initiator = 'none'; sendSMS(pn, cn, "iniiator cleared automatically by timeout."); }, 300000);
	try {
	    sendSMS(pn, cn, req.body.Body)
	    res.send('<Response>It Works</Response>')
	} catch(e) {
	    console.log("error: " + e)
	}

    // if I am the iniator, then do a smart parse of my special format, so sms will get send to my recipient
    // the special format is "+NUMBER@MESSAGE" i.e. "+18885551212@This is my body to send"
    } else if ((req.body.From === cn) && (initiator === 'none') ) {

	var init = req.body.Body
	var re = new RegExp("^(\\+[0-9]{11})@(.*)")
	if (re.test(init)) {

	    var match = re.exec(init)
	    var mTo = match[1]
	    var mBody = match[2]

	    console.log("\nRelay Number: " + mTo)
	    console.log("Relay Body: " + mBody + "\n")

	    try {
		sendSMS(pn, mTo, mBody)
		res.send('<Response></Response>')
	    } catch(e) {
		console.log("error: " + e)
	    }

        // If i'm the initiator, and my special format isnt found in body, send me back a reminder of what that is
	} else {
	    console.log('\nyou are trying to initiate an sms to somebody, but did not use the special foramt "+NUMBER@MESSAGE\"\n')
	    res.send('<Response><Message>No initiator yet. To initatite message, use format without quotes:\n"+NUMBER@MESSAGE"</Message></Response>')
	    console.log("\nYou are iniating and sms to somebody\n")
	}

    // When somebody SMS me, and the 5 minute rememberance of their number begins, at any time I can send sms with all caps "RESET"
    //   to reset the initiator so I can send to a new recipient of my choosing without waiting.
    } else if ((req.body.From === cn) && (initiator) && (req.body.Body === "RESET")) {
	initiator = 'none'
	console.log("You have cleared initiator, ready for new recipient")
	res.send('<Response><Message>Initiator cleared. Ready for new recipient</Message></Response>')

    // and final condition is to simply to forward my reply to whomever initiated an sms.
    } else {
	console.log("\nYou are replying to an sms that sombody else initiated to you\n")
	try {
	    sendSMS(pn, initiator, req.body.Body)
	    res.send('<Response></Response>')
	} catch(e) {
	    console.log("error: " + e)
	}
    }
});

// this is the function that actually sends out the SMS requests to SignalWire
function sendSMS(init_from, init_to, init_body) {
    signalwire.messages.create({ from: init_from, to: init_to, body: init_body })
	.then(response => {
	    console.log(response);
	    console.log("sid: " + response.sid)
	})
	.catch(error => { console.log(error) })
	    .done(console.log("sending message, awaiting JSON response from SignalWire..."));
}

if ((ip !== "SERVER_IP_HERE" ) && ( port !== '' )) {
    // puts the server into operation
    server.listen(port, ip);

    // gives you alot of info when starting up
    console.log('NodeJs is listening on port \x1b[33m' + port + '\x1b[0m with local ip \x1b[33m' + ip + '\x1b[0m, and your external ip is \x1b[33m' + eip +'\x1b[0m\n');
    console.log('\nIn your Signalwire dashboard, you need to create a LaML Bin and put this LaML code in the bin.\nThis will only work if your port is forwarded from router to server.\n\n' +
		'\x1b[33m<Response>\n' +
		'  <Redirect method="POST">http://' + eip + ':' + port + '/sendSMS</Redirect>\n' +
		'</Response>\x1b[0m\n\n' +
		'Copy the bin link from the bins list page, go edit your Phone Number and paste in for \x1b[33mWHEN A MESSAGE COMES IN:\x1b[0m webhook\n' +
		'Choose the POST method dropdown. Now your SignalWire number will hit the LaML Bin first, and the bin will redirect message to your server.\n' +
		'This is needed for capturing \x1b[33mFrom\x1b[0m, \x1b[33mTo\x1b[0m, and \x1b[33mBody\x1b[0m values from other people initiating sms, and passing it on to you.')
    console.log('Also, We need to remember who they are in order to send sms back to them. That why "initiator=" variable exists.')
    console.log("\nFor POST request from browser address bar, paste this full string:\n  \x1b[33m%s\x1b[0m",  "data:text/html,<body onload=\"document.body.firstChild.submit()\"><form method=\"post\" action=\"http://" + ip + ":" + port + "/sendSMS\"><input type=\"text\" name=\"Body\" value=\"testing\">")
    console.log('\nOr issue this curl command in another terminal:\n  \x1b[33mcurl -X POST -d "Body=Testing" %s\x1b[0m',  'http://' + ip + ':' + port + '/sendSMS')
    console.log('\nFor a full duplex (x4 SMS) test, have classmate send an sms to \x1b[33m%s\x1b[0m. And you reply. Both parties numbers should be masked by your SignalWire number.', pn)
    console.log('\nWhen someone sends SMS to your SW number, it forwards to your cell. You have 5 minutes to respond, or else the remembrance of initiators number will reset.')
    console.log('You can manually reset the rembrance before the 5 minutes lapses by sending all caps \x1b[33mRESET\x1b[0m to your SW number. Then you are free to iniate SMS to whomever else.')
    console.log('The format for iniating an SMS from your cell is \x1b[33m+NUMBER@MESSAGE\x1b[0m i.e. \x1b[33m+1888551212@This is my message\x1b[0m\n')
} else {
    console.log("ERROR: Please give variables \"ip=" + ip + "\" and \"port=" + port + "\" proper values")
}
//////////////////////////////////////////////////////////////////////
// END MINIMUM SERVER FOR MESSAGE RELAY - LaML REDIRECT - POST REQUEST
//////////////////////////////////////////////////////////////////////
*/










/*
///////////////////////////////////////////////////////////
// START MINIMUM SERVER FOR STATUS CALLBACKS - GET AND POST
///////////////////////////////////////////////////////////

// function call to get personal vars.
if (typeof get_vars === "function") {
    get_vars()
}


//
// setup some constant server needs
//
const express = require('express');
const server = express();
const { RestClient } = require('@signalwire/node');
const signalwire = new RestClient(pk, at, { signalwireSpaceUrl: su })

//
// needed to get external ip for help/log print outs when starting server. Not really used in nodejs functions.
//
const { execSync } = require('child_process');
var eip = execSync('curl --silent ifconfig.me')

//
// setup needed for parsing the body of POST statusCallbacks, GET alone does not require this
//
var bp = require('body-parser');
server.use(bp.urlencoded({ extended: true }));

//
// Handling SMS GET Requests
//
server.get("/laml", (req, res) => {
    console.log("\nProcessing client GET request on NodeJS")
    console.log("Request:\n" + util.inspect(req.query))

    // pass the GET request to our sendSMS() function for decisions
    sendSMS(req.query,res)  // notice for GET we're passing req.query
    // we pass the "res" stuff too, so "res.send()" will work in sendSMS().
});


//
// Handling SMS POST Requests
//
server.post("/laml", (req, res) => {
    console.log("\nProcessing client POST request on NodeJS")
    console.log("Request:\n" + util.inspect(req.body))

    // pass the POST request to our sendSMS() function for decisions
    sendSMS(req.body, res)  // notice for POST we're passing req.body
    // we pass the "res" stuff too, so "res.send()" will work in sendSMS().
});

// When dealing with GET and POST, we want to pass along the Body of the message to sendSMS() function.
// When a GET hits express server.get(), the message body object is accessible by using "req.query.Body"
// When a POST hits express server.post(), the message body object is accessible by using "req.body.Body"
// Therefore, if we pass along either just "req.query" or just "req.body" as seen above,
//    we'll use "req.Body" as seen below to fulfill the REST API param for "body" like [[  .create(...  body: req.Body  ...)  ]]
// This way our sendSMS() function can operate with both GET and POST requests...

function sendSMS(req, res) {

    // to enable message status callbacks, fill in properly before
    // uncommenting one, or other, or both. See more info below regarding callbacks.
    // if both are uncommented, statusCallback will take priority

    // OPTIONAL: your LaML Application Sid, can be GET or POST in dashboard
    //la=''

    // OPTIONAL: your own callback url, is POST only
    //cb='http://example.com:3000/status'

    // make decisions whether to use callbacks or not
    if (cb && la) {
	console.log("\nApplicationSid and StatusCallback parameters in use for status updates, but StatusCallback is taking precendence\n")

        signalwire.messages
            .create({from: pn, body: req.Body, to: cn, applicationSid: la, statusCallback: cb})
	    .then(message => { console.log("Message Sid: " + message.sid)
			       res.send("<Response></Response>"); })
	    .catch(error => {console.log("error: " + error); res.send(error)});
    } else if (cb) {
        console.log("\nstatusCallback parameter being used for status callback")
        signalwire.messages
            .create({from: pn, body: req.Body, to: cn, statusCallback: cb, statusCallbackMethod: 'GET'})
            .then(message => { console.log("Message Sid: " + message.sid)
			       res.send("<Response></Response>"); })
	    .catch(error => {console.log("error: " + error); res.send(error)});
    } else if (la) {
        console.log("\napplicationSid parameter being used for status callback")
        signalwire.messages
            .create({from: pn, body: req.Body, to: cn, applicationSid: la})
            .then(message => { console.log("Message Sid: " + message.sid)
			       res.send("<Response></Response>"); })
	    .catch(error => {console.log("error: " + error); res.send(error)});
    }  else {
        console.log("\nno sms callback parameters used")
	signalwire.messages
            .create({from: pn, body: req.Body, to: cn})
            .then(message => { console.log("Message Sid: " + message.sid)
			       res.send("<Response></Response>"); })
	    .catch(error => {console.log("error: " + error); res.send(error)});
    }
}


//
// If using "applicationSid", set dashboard Laml App to use GET to hit this route and show the StatusCallback is working for message status updates
// Must setup the "WHEN THE MESSAGE IS DELIVERED:" url (i.e. "http://<IP_OR_DOMAIN>:3000/status") in your LaML Apps dashboard")
//
// If using "statusCallback", ensure the port is forwarded from router to nodejs server
//
server.get("/status", function (req,res) {
  console.log("\nMessage Status GET: %s\n", JSON.stringify(req.query));
  // sending an empty LaML response from our server back to SignalWire's message StatusCallback request
  // will the 2-way communication dialog and provide for proper a 200OK in dashboard message log.
  // see more notes in 'server.post' below.
  res.set('Content-Type', 'text/xml');                                                                                                                            res.send('<Response>></Response>');
});


//
// If using "appplicationSid", set dashboard Laml App to use POST to hit this route and show the StatusCallback is working for message status updates
// Must setup the "WHEN THE MESSAGE IS DELIVERED:" url (i.e. "http://<IP_OR_DOMAIN>:3000/status") in your LaML Apps dashboard")
//
// If using "statusCallback", ensure the port is forwarded from router to nodejs server
//
server.post("/status", function (req,res) {
    console.log("\nMessage Status POST: %s\n", JSON.stringify(req.body));
    // Without this empty response, even though your server will still receive the message status updates from SW, your SW dashboard message
    // log will show failed, as SW is waiting for some type of acknowledgement from our server, and times out pending this response..
    // see more notes in 'server.get' above.
    res.set('Content-Type', 'text/xml');
    res.send('<Response>></Response>');
});


//
// If your online dashboard is all prepped, port forwarded, and either "la" and/or "cb" uncommented, these status callback handlers above should just work.
// For an applicationSid, the callback can be a GET or POST depending what you set in the LaML App. Eitherway, this server is ready for both.
// For an statusCallback, it will always be a POST. If you need GET callbacks for your status, use applicationSid instead.
//


// puts the server into operation
if ((ip !== "SERVER_IP_HERE" ) && ( port !== '' )) {
    server.listen(port, ip);
    console.log('NodeJs is listening on port \x1b[33m' + port + '\x1b[0m with local ip \x1b[33m' + ip + '\x1b[0m, and your external ip is \x1b[33m' + eip +'\x1b[0m\n');

    console.log('For this callbacks section to work properly, you will need to setup up a LaML App in your dashboard.\n' +
		'    LaML > Apps > WHEN A MESSAGE COMES IN: \x1b[33mhttp://' + eip + ':' + port + '/laml\x1b[0m\n' +
		'    and           WHEN A MESSAGE IS DELIVERED: \x1b[33mhttp://' + eip + ':' + port + '/status\x1b[0m\n' +
		'For the delivery METHOD, either GET or POST should work. Be sure to try them both.\n')
    console.log('You will need to find the LaML App Sid from the apps list page and fill in the \x1b[33mla = ?\x1b[0m nodejs variable so param \x1b[33mApplicationSid\x1b[0m will work.')
    console.log('And also be sure to fill in the \x1b[33mcb = ?\x1b[0m variable with \x1b[33mhttp://' + eip + ':' + port + '/status\x1b[0m so the \x1b[33mStatusCallback\x1b[0m param will work.')

    console.log('\nIf you send an sms to \x1b[33m%s\x1b[0m, you will get a carbon copy reply in your body, and you will be charged for (2) SMS. Thats (1) Inbound and (1) Outboud.', pn)

    console.log('This section can hanlde incoming messages, but is intended primarily for outbound messages from curl or browser bar to showcase status callbacks.')

    console.log("\nFor GET request from browser address bar, paste this full string:\n  \x1b[33m%s\x1b[0m",  "http://" + ip + ":" + port + "/laml?Body=This%20is%20a%20browser%20GET%20test")

    console.log("\nFor POST request from browser address bar, paste this full string:\n  \x1b[33m%s\x1b[0m",  "data:text/html,<body onload=\"document.body.firstChild.submit()\"><form method=\"post\" action=\"http://" + ip + ":" + port + "/laml\"><input type=\"text\" name=\"Body\" value=\"this is a browser POST test\">")

    console.log("\nOr issue this curl GET command in another terminal:")

    console.log("\n  \x1b[33mcurl -X GET %s\x1b[0m",  "http://" + ip + ":" + port + "/laml?Body=This%20is%20a%20curl%20GET%20test")

    console.log("\nand/or for curl POST")

    console.log('\n  \x1b[33mcurl -X POST --data-urlencode "Body=This is a curl POST test" %s\x1b[0m',  'http://' + ip + ':' + port + '/laml\n')

    console.log('To thoroughly test this section for ensuring all call back types are working you would:\n' +
		'    1. Uncomment and set \x1b[33mla = ?\x1b[0m var in server, set in dashboard \x1b[33mLaML App > DELIVERED > METHOD > GET\x1b[0m, do a browser or curl test\n' +
		'         and see (3) GET callbacks. (1) for \x1b[33mqueued\x1b[0m (1) for \x1b[33msent\x1b[0m, and (1) for \x1b[33mdelivered\x1b[0m. Might possibly see a \x1b[33mfailure\x1b[0m depending\n' +
                '    2. Change your \x1b[33mLaML App > DELIVERD > METHOD > POST\x1b[0m, send another browser/curl test, watch for (3) POST callbacks\n' +
 		'    3. Comment \x1b[33mla = ?\x1b[0m, uncomment and set \x1b[33mcb = \'http://'+ eip + ':' + port + '/status\'\x1b[0m and test again.\n' +
		'When using \x1b[33mApplicationSid\x1b[0m (var la), callback method can be GET or POST. When using \x1b[33mStatusCallback\x1b[0m (var cb), it is POST only.\n' +
		'if you are specifying both in your REST API request to SignalWire, the StatusCallback will be honored, and the other ignored\n')
} else {
  console.log("ERROR: Please give variables \"ip=" + ip + "\" and \"port=" + port + "\" proper values")
}
/////////////////////////////////////////////////////////
// END MINIMUM SERVER FOR STATUS CALLBACKS - GET AND POST
/////////////////////////////////////////////////////////
*/








//////////////////////////////////////////////////////////
// START MINIMUM SERVER FOR CLIENT WEBSOCKET COMMUNICATION
//////////////////////////////////////////////////////////

//
// declare globals for reception of client data
//
var clientWsId;
var signalwire;
var reqSpace;
var reqKey;
var reqToken;
var reqFrom;
var reqGroup;
var reqTo;
var reqPrice;
var reqValidity;
var reqLaml;
var reqStatus;
var reqBody;
var reqMedia;

//
// get external ip for help/log print outs when starting server. Not used in any nodejs functions.
//
const { execSync } = require('child_process');
var eip = execSync('curl --silent ifconfig.me')

//
// function call to get personal vars.
//
if (typeof get_vars === "function") {
    get_vars()
}


//
// setup nodejs express server apps... "server.get()" is arbitrary, can be "whatever.get()", so long as you change it everywhere else.
//
const express = require('express');
const server = express();


//
// for serving the client page
//
const path = require('path');
server.use(express.static('public'));
server.use('/favicon.ico', express.static('./favicon.ico'));
server.get('/client', (req,res) => { res.sendFile(path.join(__dirname, '/index.html')); });
server.get('/gwd-events-support.1.0.js', (req,res) => { res.sendFile(path.join(__dirname, '/public/gwd-events-support.1.0.js')); })
server.get('/jquery-3.4.1.min.js', (req,res) =>{ res.sendFile(path.join(__dirname, '/public/jquery-3.4.1.min.js')); })


//
// Listen for the GET request from client
//
server.get("/sendSMS", async (req,res) => {
    console.log('entering /sendSMS GET function')
    //console.log('\n\nRequest Body:\n' + JSON.stringify(req.query) + '\n\n');
    //console.log("GET req: " + util.inspect(req))

    // process the GET request
    requestHandler(req,res,'GET')
});


//
// Required for parsing POST body data
//
const bp = require('body-parser');
server.use(bp.urlencoded({ extended: true }));
//
//  Listen for the POST request from client
//
server.post("/sendSMS", async (req,res) => {
    console.log('entering /sendSMS POST function')
    //console.log('\n\nRequest Body:\n' + JSON.stringify(req.body) + '\n\n');
    //console.log("post req: " + util.inspect(req))

    // process the POST request
    requestHandler(req,res,'POST')
});


//
// the request processor
//
function requestHandler(req, res, reqType) {
    //console.log(reqType + ' req: ' + util.inspect(req))
    if (reqType === 'GET') {
	parseGetRequestValues(req)
    } else if (reqType === 'POST') {
	parsePostRequestValues(req)
    } else {
	return "error: no client values sent to nodejs"
    }

    // setup new signalwire connection with client provided creds
    signalwire = new RestClient( reqKey, reqToken, { signalwireSpaceUrl: reqSpace })

    //split up the batch list of "From" and "To" numbers
    var multiFrom = reqFrom.split('\n')
    var multiTo = reqTo.split('\n')
    var countFrom = 0;
    var mFrom;

    // For each "To" number found, send an SMS to it
    multiTo.forEach(batchTo)
    function batchTo(mTo, index, array) {

	// the "From" numbers will continue to re-cycle until the "To" list is exhausted
	mFrom = multiFrom[countFrom];
	if ((mFrom === undefined) || (mFrom === '')) {
	    countFrom = 0;
	    mFrom = multiFrom[countFrom];
	}

	if ((mTo === undefined) || (mTo === '')) {
	    console.log("end of 'To' list")
	    return
	}
	console.log("mTo: " + mTo + "      mFrom: " + mFrom)

	//use the sendSMS() function where it's sent off to SignalWire
	sendSMS(mFrom, reqGroup, mTo, reqPrice, reqValidity, reqLaml, reqStatus, reqBody, reqMedia)
	    .then(stuff => {
		return console.log("");
		//console.log('\ntest stuff ' + reqType + ' response: ' + stuff + '\n');
	    })
	    .catch(error => {
		console.log(reqType + ' caught responseOrError: ' + error);
		res.send(error);
		throw new Error(error);
	    });
	countFrom++
    }
    return true;
}


//
// parse the GET request values from client into global variables
//
function parseGetRequestValues(req) {
    // set the global for client websocket
    clientWsId = req.query.ClientWsId;

    // set the SignalWire vars
    reqSpace = req.query.Space;
    reqKey = req.query.Key;
    reqToken = req.query.Token;
    reqFrom = req.query.From;
    reqGroup = req.query.Group;
    reqTo = req.query.To;
    reqPrice = req.query.MaxPrice;
    reqValidity = req.query.ValidityPeriod;
    reqLaml = req.query.Laml;
    reqStatus = req.query.Status;
    reqBody = req.query.Body;
    reqMedia = req.query.Media;

    //logRequestValues()
}


//
// parse the POST request values from client into global variables
//
function parsePostRequestValues(req) {
    // set the global for client websocket
    clientWsId = req.body.ClientWsId;

    // set the SignwalWire vars
    reqSpace = req.body.Space;
    reqKey = req.body.Key;
    reqToken = req.body.Token;
    reqFrom = req.body.From;
    reqGroup = req.body.Group;
    reqTo = req.body.To;
    reqPrice = req.body.MaxPrice;
    reqValidity = req.body.ValidityPeriod;
    reqLaml = req.body.Laml;
    reqStatus = req.body.Status;
    reqBody = req.body.Body;
    reqMedia = req.body.Media;

    //logRequestValues()
}


//
// log the client value for debuggin purposes
//
function logRequestValues() {
    console.log('')
    console.log('Request values:');
    console.log('Space: ' + reqSpace);
    console.log('Key: ' + reqKey);
    console.log('Token: ' + reqToken);
    console.log('From: ' + reqFrom);
    console.log('Group: ' + reqGroup);
    console.log('To: ' + reqTo);
    console.log('Max Price: ' + reqPrice);
    console.log('Validity Period: ' + reqValidity);
    console.log('LaML Server: ' + reqLaml);
    console.log('Status Server: ' + reqStatus);
    console.log('Body: ' + reqBody);
    console.log('Media URL: ' + reqMedia);
    console.log('');
}


//
// setup the SignalWire library
//
const { RestClient } = require('@signalwire/node');

//
// The actual request sent off to SignalWire for processing
// For NodeJS use standard javascript camel case: i.e. if docs say "MaxPrice", use "maxPrice", or if "From", use "from"
//
async function sendSMS(sendFrom, sendGroup, sendTo, sendPrice, sendValidity, sendLaml, sendStatus, sendBody, sendMedia) {
    console.log('entering /sendSMS function ');
    try {
	const message = await signalwire.messages
	      .create(
		  {
		      from: sendFrom,                    // you may use From
		      //messagingServiceSid: sendGroup,    // or use MessageServiceSid, takes precedence if From is also specified
		      to: sendTo,
		      //maxPrice: sendPrice,             // not yet supported on signalwire
		      //validityPeriod: sendValidity,
		      applicationSid: sendLaml,        // use LaML's ApplicationSid for message status callbacks
		      //statusCallback: sendStatus,        // or use StatusCallback, takes precedence if ApplicationSid is also specified
		      body: 'prepended stuff and newline\n ' + sendBody,
		      //mediaUrl: sendMedia,
		  }
	      )
	      .then( stuff => {
		  return console.log("");
		  //console.log(stuff);
	      })
	      .catch( error => {
		  console.log(error)
	      })
              .done(console.log("Message Request sent to SignalWire, awaiting Response"));
	//console.log("message sid: " + message.sid )
	//return "this is a test"
    } catch(error) {
	console.log("caught error in signalwire.messages.create: " + error);
    }
}



//
// Set dashboard LaML App to use GET to hit this route and show ApplicationSid is working
// must setup the "WHEN A MESSAGE COMES IN:" url (i.e "http://<IP_OR_DOMAIN>:3000/laml") in your LaML Apps dashboard
// This will be used to handle incoming messages (via GET) to your SignalWire Phone Number
//
server.get("/laml", (req,res) => {
    console.log('entering GET /laml');
    console.log("Response GET:\n" + JSON.stringify(req.query));
    // if the incoming "To" match SignalWire Phone number, send body to client websocket
    // else process normally as if it's the client sending messages to "/laml" url
    if (req.query.To === pn) {
	incomingSMS(req.query,res)
    } else {
	requestHandler(req,res,'GET')
    }
});

//
// Set dashboard LaML App to use POST to hit this route and show ApplicationSid is working
// must setup the "WHEN A MESSAGE COMES IN:" url (i.e "http://<IP_OR_DOMAIN>:3000/laml") in your LaML Apps dashboard
// This will be used to handle incoming message (via POST) to your SignalWire Phone Number
//
server.post("/laml", (req,res) => {
    console.log('entering POST /laml');
    console.log("Response POST:\n" + JSON.stringify(req.body));
    // if the incoming "To" match SignalWire Phone number, send body to client websocket
    // else process normally as if it's the client sending messages to "/laml" url
    if (req.body.To === pn) {
	incomingSMS(req.body,res)
    } else {
	requestHandler(req,res,'POST')
    }
});

//
// handle incoming sms from "/laml" or "/fallback" urls
// essentially you can direct your "pop" button var "inputServer" to either "/sendSMS", "/laml", or "/fallback" and they should all work.
//
function incomingSMS(req,res) {
    // in other words, if you send client sms to "<IP>:<PORT>/laml" instead of "<IP>:<PORT>/sendSMS" outgoing sms will still get processed out.
    // but we have an incoming sms out of the blue, the client should be able to receive with the above "if" condition
    // dont expect callbacks from wild incoming messages. We did not orginate the sms, so there will be none
    console.log("incoming message from " + pn);
    if (connections[clientWsId]) {
	res.set('Content-Type', 'text/xml');
	res.send('<Response></Response>');
	connections[clientWsId].send("incoming message: " + JSON.stringify(req));
	//console.log("\nsent message status update to client")
    } else {
	console.log("\nconnection not found")
    }
}


//
// ideally, this GET fallback would be on a seperat server, but here to prove it works in training...
// Set dashboard LaML App to use GET to hit this route as a fallback in case /laml fails
// must setup in SW Dashboad > Phone Numbers > number > Edit Settings > "IF PRIMARY WEBHOOK FAILS:" url (i.e "http://<IP_OR_DOMAIN>:3000/fallback")
//
server.get("/fallback", (req,res) => {
    console.log('entering GET /fallback');
    //console.log("Response GET:\n" + JSON.stringify(req.query));
    if (req.query.To === pn) {
	incomingSMS(req.query,res);
    } else {
	requestHandler(req,res,'GET')
    }
});

//
// ideally, this POST fallback would be on a seperat server, but here to prove it works in training...
// Set dashboard LaML App to use POST to hit this route as a fallback in case /laml fails
// must setup in SW Dashboad > Phone Numbers > number > Edit Settings > "IF PRIMARY WEBHOOK FAILS:" url (i.e "http://<IP_OR_DOMAIN>:3000/fallback")
//
server.post("/fallback", (req,res) => {
    console.log('entering POST /fallback');
    //console.log("Response POST:\n" + JSON.stringify(req.body));
    if (req.body.To === pn) {
	incomingSMS(req.body,res);
    } else {
	requestHandler(req,res,'POST')
    }
});

//
// Set dashboard Laml App to use GET to hit this route and show the StatusCallback is working for message status updates
// Must setup the "WHEN THE MESSAGE IS DELIVERED:" url (i.e. "http://<IP_OR_DOMAIN>:3000/status") in your LaML Apps dashboard")
//
server.get("/status", (req,res) => {
    console.log('\nentering GET /status');
    statusHandler(req.query,res,'GET')
});

//
// Set dashboard Laml App to use POST to hit this route and show the StatusCallback is working for message status updates
// Must setup the "WHEN THE MESSAGE IS DELIVERED:" url (i.e. "http://<IP_OR_DOMAIN>:3000/status") in your LaML Apps dashboard")
//
server.post("/status", (req,res) => {
    console.log('\nentering POST /status');
    statusHandler(req.body,res,'POST')
});

//
// process the message status
//
function statusHandler (req,res,reqType) {
    console.log('\nmessage status ' + reqType + ' body:\n' + JSON.stringify(req));
    //console.log("\nObject.keys.connections: " + Object.keys(connections))
    //console.log("\nutil shows:\n" + util.inspect(req))
    if (connections[clientWsId]) {
	connections[clientWsId].send(JSON.stringify(req));
	//console.log("\nsent message status update to client")
    } else {
	console.log("\nconnection not found")
    }

    // theses two headers were needed for ealier stages of client dev to overcome "CORS origin" errors when opening client locally on desktop and sending SMS.
    //   but those errors have since been solved and I cannot remember how to reproduce those errors on demand to explain more clearly the situation.
    //   so leaving these headers here for remembrance. This discovery arose from using Google Web Designer to build client, and using the "Preview" button
    //   to view and test progress locally. These lines resolved the CORS errors. But also, they may not have orginally sat in this function. I think i was
    //   originally using them in "server.get()" and "server.post()", just before doing "res.send()". Hope this note helps any CORS issues for local testing in GWD.
    //res.header("Access-Control-Allow-Origin", "*");
    //res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

    res.set('Content-Type', 'text/xml');
    res.send('<Response><Message>' + reqType + ' response from nodejs express /status to SignalWire!</Message></Response>');
}

//
// setup http non-secure server in way that uses express "server" apps
//
const http = require('http');
const options = {
    host: ip,
    port: port
}
var httpServer = http.createServer(options, server)
httpServer.listen(port);



//
// setup websocket non-secure server so we can send the status callbacks to client
//
const WebSocket = require('ws').Server;
const ws = new WebSocket({ server: httpServer });
const connections = {}
ws.on('connection', (clientWsConn) => { socketHandler(clientWsConn, ' non-secure') });

//
// if no certs present, do not setup secure server stuff
///
if ((privkey) && (cert) && (fullchain)) {
    //
    // setup https secure server in a way that uses express "server" apps securely
    //
    const https = require('https');
    const fs = require('fs');
    const soptions = {
	key: fs.readFileSync(privkey),
	cert: fs.readFileSync(cert),
	ca: fs.readFileSync(fullchain),
    };
    var httpsServer = https.createServer(soptions, server)
    httpsServer.listen(sport);

    //
    // setup websocket secure server so we can send the status callbacks to client securely
    //
    const wss = new WebSocket({ server: httpsServer });
    wss.on('connection', (clientWsConn) => { socketHandler(clientWsConn, ' secure') });
}

//
// setup uuid for uniquely identifying client websocket connections
// ideally you'd use this for handleing multiple client connections, but this training currently only handles one client.
//
const uuid = require('uuid/v4')

//
// ws and wss handler
//
function socketHandler(clientWsConn, sec) {
    //console.log(clientWsConn)
    clientWsId = uuid()
    clientWsConn.send('websocket' + sec + ' connection id: ' + clientWsId);
    connections[clientWsId] = clientWsConn
    console.log("websocket secure connection id: " + clientWsId)

    clientWsConn.on('open', opened => {
	console.log('\nclient connection opened')
	console.log(opened)
	clientWsConn.send('this connection message send from nodejs letting you know your connection is open')
    });

    clientWsConn.on('message', (message) => {
	console.log(`data received from client:\n${message}`);
    });

    clientWsConn.on('end', (end) => {
	delete connections[clientWsId];
	console.log('\nConnection ended: ' + end);
    });
    //console.log("Client Websocket Connections: " + util.inspect(connections))
}

console.log('Non-secure NodeJs server should be up and running.')
console.log('Provided port \x1b[33m'+ port + '\x1b[0m is forward from router to server, these connections details should work.\n');
console.log('NodeJS internal non-secure client connection:\n');
console.log('\x1b[33mhttp://' + ip + ':' + port + '/client\x1b[0m');
console.log('\x1b[33mws://' + ip + ':' + port + '\x1b[0m\n');
console.log('Nodejs external non-secure client connection:\n');
console.log('\x1b[33mhttp://' + eip + ':' + port + '/client\x1b[0m');
console.log('\x1b[33mws://' + eip + ':' + port + '\x1b[0m\n\n');

if ((privkey) && (cert) && (fullchain)) {
    console.log('Secure NodeJs server should be up and running.')
    console.log('Provided your security certs are inplace, and port \x1b[33m' + sport + '\x1b[0m is forwarded, these connections details should work.\n');
    console.log('Nodejs internal secure client connection:\n');
    console.log('\x1b[33mhttps://' + ip + ':' + sport + '/client\x1b[0m');
    console.log('\x1b[33mwss://' + ip + ':' + sport + '\x1b[0m\n');
    console.log('Nodejs external secure client connection:\n');
    console.log('\x1b[33mhttps://' + eip + ':' + sport + '/client\x1b[0m');
    console.log('\x1b[33mwss://' + eip + ':' + sport + '\x1b[0m\n\n');
}

console.log('Additionally, you should be able to open a local copy of the client file \x1b[33mindex.html\x1b[0m directly in any browser. But, I digress :-)');
console.log('Search the code comments for "CORS" if you run into those type errors when running the index locally on your desktop.\n');

//
// to start the server type "node index.js" in your project directory
//

////////////////////////////////////////////////////////
// END MINIMUM SERVER FOR CLIENT WEBSOCKET COMMUNICATION
////////////////////////////////////////////////////////
