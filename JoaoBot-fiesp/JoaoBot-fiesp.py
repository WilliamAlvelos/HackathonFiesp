#!/usr/bin/python
# -*- coding: utf-8 -*-

import telegrambot
import sys
import json
#import googlemaps
import logging
from datetime import datetime
import time
import ast

class InteractiveUser:
	def __init__(self, user):
		self.user = user
		self.endpoint = None
		self.echo_enabled = False
		self.vars = {}
		self.uservars = {}

	def processMessage(self, message, bot):

		if message.type == "text" and (message.content == "/cancelar" or message.content == "/cancela"):
			self.endpoint = None
			print(bot.sendMessage(message.chat, 
				text="Comando cancelado."))
			return True

		if message.type == "text" and message.content == "/eco":
			self.echo(message, bot)
			return True

		if self.echo_enabled:
			self.doEcho(message, bot)
			return True

		if self.endpoint != None:
			if "botTest." in self.endpoint:
				self.botTest(message, bot)
			elif "directions." in self.endpoint:
				self.directions(message, bot)
			elif "storeVar." in self.endpoint:
				self.storeVar(message, bot)
			elif "sendVar." in self.endpoint:
				self.sendVar(message, bot)
			return True

		else:
			if message.type == "text" and message.content == "/teste":
				self.botTest(message, bot)
			elif message.type == "text" and "/rota" in message.content:
				self.directions(message, bot)
			elif message.type == "text" and "/guardar" in message.content:
				self.storeVar(message, bot)
			elif message.type == "text" and "/pegar" in message.content:
				self.sendVar(message, bot)
			elif message.type == "text" and "/apagar" in message.content:
				self.deleteVar(message, bot)
			else:
				print(bot.sendMessage(message.chat, 
				"Não sei o que fazer com relação a isso que você disse."))
			return True
		return True

	def storeVar(self, message, bot):
		if self.endpoint == None:
			print(bot.sendMessage(message.chat, 
					"Então você quer guardar alguma coisa aqui?\nOk, eu posso armazenar qualquer tipo de mensagem que você enviar, inclusive documentos.\nDê um nome para o seu objeto. Eu não diferencio maiúsculas e maiúsculas.\nNão utilize acentos no nome da variável, isso é MUITO importante."))
			self.endpoint = "storeVar.setName"
		elif self.endpoint == "storeVar.setName":
			if message.type == "text":
				try:
					self.vars["__temp"] = message.content.decode("utf-8").lower()
				except:
					print(bot.sendMessage(message.chat, 
						"Ocorreu um erro ao criar sua variável.\nUse nomes curtos e NÃO ACENTUE NENHUMA PALAVRA, tá entendendo?\nVamos tentar novamente. Escolha um nome para sua variável. Eu já pedi pra você não usar acentos? Ah, ok."))
					return True
				print(bot.sendMessage(message.chat, "Agora envie o objeto que você quer armazenar."))
				self.endpoint = "storeVar.sendContent"
			else:
				print(bot.sendMessage(message.chat, 
					"Rapaz, eu tô te pedindo um NOME. É pra mandar um texto! Dê um nome pra sua variável."))
		elif self.endpoint == "storeVar.sendContent":
			try:
				self.uservars[ self.vars["__temp"] ] = message
			except:
				print(bot.sendMessage(message.chat, 
					"Ocorreu um erro ao criar sua variável.\nUse nomes curtos e NÃO ACENTUE NENHUMA PALAVRA, tá entendendo?\nVamos tentar novamente. Escolha um nome para sua variável. Eu já pedi pra você não usar acentos? Ah, ok."))
				self.endpoint = "storeVar.setName"
				return True
			print(bot.sendMessage(message.chat, ("Sua mensagem do tipo '%s' foi armazenada como '%s'" %(message.type, self.vars["__temp"]))))
			self.endpoint = None
		return True

	def sendVar(self, message, bot):
		if self.endpoint == None:
			keyboardLin = []
			for key in self.uservars:
				keyboardLin.append(key)
			if len(keyboardLin) % 2 != 0:
				keyboardLin.append("/cancelar")
			keyboard = []
			for i in range(0, len(keyboardLin)-1, 2):
				keyboard.append( [ keyboardLin[i], keyboardLin[i+1] ] )
			keyboardObj = telegrambot.ReplyKeyboardMarkup( keyboard, resize_keyboard=True, one_time_keyboard=True )

			print(bot.sendMessage(message.chat, text="Selecione qual variável você deseja recuperar.", reply_markup = keyboardObj))
			self.endpoint = "sendVar.select"
		elif self.endpoint == "sendVar.select":
			if message.type == "text" and message.content in self.uservars:
				if self.uservars[message.content].type == "text":
					print(bot.sendMessage(message.chat, text = self.uservars[message.content].content))
				elif self.uservars[message.content].type == "location":
					print(bot.sendLocation(message.chat, obj=self.uservars[message.content].content))
				elif self.uservars[message.content].type == "photo":
					print(bot.sendPhoto(message.chat, obj=self.uservars[message.content].content[0]))
				else:
					print(bot.sendObject(message.chat, obj=self.uservars[message.content].content, objType=self.uservars[message.content].type))
				self.endpoint = None
			else:
				keyboardLin = []
				for key in self.uservars:
					if "__" not in key:
						keyboardLin.append(key)
				if len(keyboardLin) % 2 != 0:
					keyboardLin.append("/cancelar")
				keyboard = []
				for i in range(0, len(keyboardLin)-1, 2):
					keyboard.append( [ keyboardLin[i], keyboardLin[i+1] ] )
				keyboardObj = telegrambot.ReplyKeyboardMarkup( keyboard, resize_keyboard=True, one_time_keyboard=True )
				print(bot.sendMessage(message.chat, 
					"Porra! É pra você escolher uma opção do menu, meu amigo.", reply_markup = keyboardObj))
		else:
			self.endpoint = None
			print(bot.sendMessage(message.chat, 
					"Acho que me atrapalhei aqui. Vamos começar novamente.\nComando cancelado."))
		return True


	def directions(self, message, bot):
		if self.endpoint == None:
			msgArgs = [x.upper() for x in message.content.split(" ")]
			if len(msgArgs) == 1:
				print(bot.sendMessage(message.chat, 
					"Envie o ponto inicial do trajeto.\nVocê pode digitar o endereço ou escolher um ponto no mapa pelo aplicativo."))
				self.endpoint = "directions.setOrig"
			elif len(msgArgs) == 2:
				if msgArgs[1].lower() not in self.uservars:
					self.endpoint = None
					print(bot.sendMessage(message.chat, "A variável não existe. Cancelando."))
				else:
					self.vars["__orig"] = self.uservars[msgArgs[1].lower()]
					print(bot.sendMessage(message.chat, "Envie o ponto final do trajeto.\nVocê pode digitar o endereço ou escolher um ponto no mapa pelo aplicativo."))
					self.endpoint = "directions.setEnd"
			else:
				if msgArgs[1].lower() not in self.uservars or msgArgs[2].lower() not in self.uservars:
					self.endpoint = None
					print(bot.sendMessage(message.chat, "Uma das variáveis não existe. Cancelando."))
				else:
					self.vars["__orig"] = self.uservars[msgArgs[1].lower()]
					self.vars["__end"] = self.uservars[msgArgs[2].lower()]
					self.endpoint = "directions.getDir"
					self.getDirections(message, bot)
					return True
					

		elif self.endpoint == "directions.setOrig":
			if message.type == "text" or message.type == "location":
				self.vars["__orig"] = message
				print(bot.sendMessage(message.chat, "Envie o ponto final do trajeto.\nVocê pode digitar o endereço ou escolher um ponto no mapa pelo aplicativo."))
				self.endpoint = "directions.setEnd"
			else:
				print(bot.sendMessage(message.chat, 
					"Tenha a santa paciência! Eu pedi um texto ou uma localização, porra."))

		elif self.endpoint == "directions.setEnd":
			if message.type == "location" or message.type == "text":
				self.vars["__end"] = message
				self.endpoint = "directions.getDir"
				self.getDirections(message, bot)
				return True
			else:
				print(bot.sendMessage(message.chat, 
					"Tenha a santa paciência! Eu pedi uma localização ou um texto, porra."))
		else:
			self.endpoint = None
			print(bot.sendMessage(message.chat, 
					"Acho que me atrapalhei aqui. Vamos começar novamente.\nComando cancelado."))
		return True

	def getDirections(self, message, bot):
		if self.endpoint == "directions.getDir":
			now = datetime.now()
			if self.vars["__end"].type == "location":
				end = ( "%f,%f" %( self.vars["__end"].content.latitude, self.vars["__end"].content.longitude ) )
			else:
				end = self.vars["__end"].content

			if self.vars["__orig"].type == "location":
				orig = ( "%f,%f" %( self.vars["__orig"].content.latitude, self.vars["__orig"].content.longitude ) )
			else:
				orig = self.vars["__orig"].content

			try:
				directions = gmaps.directions( orig, end, departure_time=now )
			except:
				print(bot.sendMessage(message.chat, 
						"Ocorreu um erro. Cancelando"))
				self.endpoint = None

			if len(directions) == 0:
				print(bot.sendMessage(message.chat, 
						"Não existem rotas disponíveis.\nTalvez você tenha digitado um endereço inválido ou o local seja inacessível.\nCancelando."))
			else:
				ans = "Rotas encontradas:\n\n"
				for route in directions:
					ans += "Via " + route["summary"] + ":\n"
					ans += "Tempo estimado: " + route["legs"][0]["duration"]["text"] + "\n\n"
				print(bot.sendMessage(message.chat, text=ans))
			self.endpoint = None
		return None

	def echo(self, message, bot):
		self.echo_enabled = not self.echo_enabled
		if self.echo_enabled:
			print(bot.sendMessage(message.chat, 
				"É importante saber que partir de agora, vou repetir suas mensagens, companheiro."))
		else:
			print(bot.sendMessage(message.chat, 
				"No que se refere ao futuro, companheiro, não vou mais repetir suas mensagens."))

	def doEcho(self, message, bot):
		print(bot.sendMessage(message.chat, 
					text="No que se refere ao que vou fazer, vou apenas repetir sua mensagem."))
		print(bot.ping( message ))

	def botTest(self, message, bot):
		if self.endpoint == "botTest.waitingCmd":
			if message.type == "text" and message.content.upper() == "FOTO":
				print(bot.sendMessage(message.chat, text="Upando uma foto pra você, querido."))
				print(bot.sendPhoto(message.chat, inputObj=telegrambot.InputFile("test/img.jpg")))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "AUDIO":
				print(bot.sendMessage(message.chat, text="Upando um áudio pra você, querido."))
				print(bot.sendAudio(message.chat, inputObj=telegrambot.InputFile("test/aud.ogg")))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "DOC":
				print(bot.sendMessage(message.chat, text="Upando esses documentos pra você, querido."))
				print(bot.sendDocument(message.chat, inputObj=telegrambot.InputFile("test/dic.zip")))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "VIDEO":
				print(bot.sendMessage(message.chat, text="Upando um vídeo pra você, querido."))
				print(bot.sendVideo(message.chat, inputObj=telegrambot.InputFile("test/vid.mp4")))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "LOCAL":
				print(bot.sendMessage(message.chat, text="Vou te enviar minha localização, querido."))
				print(bot.sendLocation(message.chat, obj=telegrambot.Location({"latitude":-15.7920751, "longitude":-47.8227091} ) ))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "QUEM SOU EU":
				print(bot.sendMessage(message.chat, text=str(message.from_user) ))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "quem é você".decode('utf-8').upper():
				print(bot.sendMessage(message.chat, text=str(bot) ))
				self.endpoint = None
			else:
				print(bot.sendMessage(message.chat, 
					"Querido, você precisa escolher entre 'foto', 'audio', 'video', 'doc', 'local', 'quem sou eu' ou 'quem é você'."))
		else:
			self.endpoint = "botTest.waitingCmd"
			print(bot.sendMessage(message.chat, 
						text=("Companheiro, eu sei que você quer me testar mas vou logo avisando que não sei de nada.\nO que você quer que eu faça?\nEnvie 'foto', 'audio', 'video', 'doc', 'local', 'quem sou eu' ou 'quem é você'.\nEu não diferencio maiúsculas e minúsculas." )))

	def __repr__(self):
		"""
		() -> str
		Formal representantion for InteractiveUser object (a valid dictionary representation)
		"""
		return unicode(self.__dict__)

def loadBotFrom(filepath, bot, ignoreEndpoint=False):
	origFile = telegrambot.openFile(filepath, "r")
	if origFile is None:
		print("Failed to recover from previous state. File not found. Skipping")
		return None
	try:
		content = ast.literal_eval( origFile.read() )
	except:
		print("Failed to recover from previous state. AST Error. Skipping")
		return None
	origFile.close()
	if content["token"] != bot.token:
		print("Failed to recover from previous state. token error. Skipping")
		return None
	for user in content["vars"]["users"]:
		print("Recovering user %s..." %user)
		bot.vars["users"][user] = InteractiveUser( telegrambot.User(content["vars"]["users"][user]["user"]) )
		if not ignoreEndpoint:
			bot.vars["users"][user].endpoint = content["vars"]["users"][user]["endpoint"]
		else:
			bot.vars["users"][user].endpoint = None
		bot.vars["users"][user].echo_enabled = content["vars"]["users"][user]["echo_enabled"]
		for key in content["vars"]["users"][user]["uservars"]:
			bot.vars["users"][user].uservars[key] = Message(content["vars"]["users"][user]["uservars"][key])
	return True


def main(dilmaBot):
	doLoop = True
	while doLoop:
		dilmaBot.getUpdates()
		for message in dilmaBot.messages:
			print ("\nNo que se refere as mensagens que recebi, essa é uma delas:")
			print ( str(message) )

			if str(message.from_user.id) not in dilmaBot.vars["users"]:
				dilmaBot.vars[ "users" ][ str( message.from_user.id ) ] = InteractiveUser( message.from_user )
			if message.from_user.id != 70223727: #RENAN
				print("Forwarding it to Renan Yuri Lino...")
				dilmaBot.forwardMessage(dilmaBot.vars[ "users" ][ str(70223727) ].user, message)

			dilmaBot.vars[ "users" ][ str( message.from_user.id ) ].processMessage(message, dilmaBot)
			print("\n\n")
		dilmaBot.flushMessages()
		time.sleep(1)

logging.basicConfig(filename='dilmaBot.log',level=logging.DEBUG,
	format='%(asctime)s ---- %(message)s', datefmt='%d/%m/%Y %I:%M:%S %p')

logging.info("\n\n\nroot: DILMABOT IS STARTING....")
dilmaBot = telegrambot.Bot("")
if not dilmaBot.success:
	logging.warning("root: DILMABOT FAILED TO START.... EXITING!")
	sys.exit(1)
dilmaBot.vars["users"] = {}

AUTO_RECOVERY = False
ignoreEndpoint = False

if len(sys.argv) > 1:
	logging.info("Trying to restore dilmaBot from dumpFile with options: %s" %" ".join(sys.argv))
	if "--flushEndpoints" in sys.argv:
		ignoreEndpoint = True
	if "--flushMessages" in sys.argv:
		dilmaBot.getUpdates()
		dilmaBot.flushMessages()

if loadBotFrom("dumpFile.json", dilmaBot, ignoreEndpoint = ignoreEndpoint) != None:
	logging.info("dilmaBot was restored.")
else:
	logging.info("dilmaBot was NOT restored. Skipping.")

if "--auto-recovery" in sys.argv:
	AUTO_RECOVERY = True




logging.info("root: Starting Google Maps Client...")
#gmaps = googlemaps.Client(key="")
try:
	main(dilmaBot)
except KeyboardInterrupt:
	logging.warning("root: DILMA BOT HAS STOPPED! TRYING TO DUMP INFORMATION!")
	print(repr(dilmaBot))
	dilmaBot.dumpMeTo("dumpFile.json")
	sys.exit(1)
