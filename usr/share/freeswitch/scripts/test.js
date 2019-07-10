var esl = require('modesl'),
    conn = new esl.Connection('127.0.0.1', 8021, 'ClueCon', function() {
	conn.api('status', function(res) {
	    //res is an esl.Event instance
	    console.log(res.getBody());
	});
	conn.api("originate user/1009 'read:0 10 misc/sorry.wav DIALED 10000 #',att_xfer:user/${DIALED} inline", function(res) {
	    //res is an esl.Event instance
	    console.log(res.getBody());
	});

    });
