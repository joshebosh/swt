#!/usr/bin/python

import SocketServer
from ESL import *

class ESLRequestHandler(SocketServer.BaseRequestHandler ):
	def setup(self):
		print self.client_address, 'connected!'

		fd = self.request.fileno()
		print fd

		con = ESLconnection(fd)
		print "Connected: " 
		print  con.connected()
		if con.connected():

			info = con.getInfo()

			uuid = info.getHeader("unique-id")
			print uuid
			con.execute("answer", "", uuid)
			con.execute("playback", "tone_stream://%(2000,4000,440,480)", uuid)
                        con.execute("echo")

#server host is a tuple ('host', port)
server = SocketServer.ThreadingTCPServer(('', 8024), ESLRequestHandler)
server.serve_forever()


