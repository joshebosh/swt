#!/usr/bin/lua
require("ESL")
local esl = ESL.ESLconnection("127.0.0.1", "8021", "ClueCon")
local fsversion = esl:api("version")
local version = fsversion:getBody()
print(version)
