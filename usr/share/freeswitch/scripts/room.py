from freeswitch import *

def input_callback(session, what, obj):

    if (what == "dtmf"):
        consoleLog("info", what + " " + obj.digit + "\n")
    else:
        consoleLog("info", what + " " + obj.serialize() + "\n")
        return "pause"

def handler(session,args):
    session.answer()
    session.execute("sleep","2000")

    session.setInputCallback(input_callback)

    session.set_tts_params("gcloud", "default")
    
    session.setVariable("tts_engine", "gcloud")
    session.setVariable("tts_voice", "en-US-Wavenet-A")

    session.speak("Please say something.")
    
    session.execute("detect_speech", "gcloud_dialogflow default default default")
    session.execute("detect_speech", "param speech-timeout 25000")
    session.execute("detect_speech", "param start-input-timers true")
    session.execute("detect_speech", "param project-id my-gcloud-agent")
    session.execute("detect_speech", "param channel-uuid " + session.get_uuid())
    session.execute("detect_speech", "start-input-timers")
    
    #Mary and Samantha arrived at the bus station early but waited until noon for the bus
    session.execute("detect_speech", "param clear-hint")
    session.execute("detect_speech", "param hint yes")

    session.streamFile("silence_stream://30000")
    session.execute("detect_speech", "stop")


