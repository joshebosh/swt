const sIdOfClientSession =process.argv[2];

var languageCode = "en";
var soundDir = "sound/";

function playFile(fileName, callBack, callBackArgs)
{
    session.streamFile(soundDir + languageCode + "/" + fileName, callBack, callBackArgs);
}

session.answer();
playFile("HelloWorld.wav");




//SHASHI says this works...
console_log("INFO",argv[0]);
const uuid=argv[0];
console_log("INFO", ">>>>>>>>>>>>>>>>>>>>>"+uuid);
