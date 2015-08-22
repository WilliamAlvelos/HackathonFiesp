import telegrambot
import sys
import json
import googlemaps
import logging
from datetime import datetime
import time
import os

PATH_PREFIX = ""
__versionstamp__ = "joaoBot-fiesp.py3.v1.0.1-stable.amazonaws under telegrambot.py3.v0.1-alpha.amazonaws"

"""
CHANGELOG:

v0.1
Fork from dilmaBot.py3.v1.0.1-stable.amazonaws under telegrambot.py3.v0.1-alpha.amazonaws
"""

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
			return True

		else:
			if message.type == "text" and message.content == "/teste":
				self.botTest(message, bot)
			else:
				print(bot.sendMessage(message.chat,
				"Não sei o que fazer com relação a isso que você disse."))
			return True
		return True


	def echo(self, message, bot):
		self.echo_enabled = not self.echo_enabled
		if self.echo_enabled:
			print(bot.sendMessage(message.chat,
				"DEV: REPETINDO MENSAGENS."))
		else:
			print(bot.sendMessage(message.chat,
				"DEV: PARANDO DE  REPETIR MENSAGENS."))

	def doEcho(self, message, bot):
		print(bot.sendMessage(message.chat,
					text="Apenas repetindo sua mensagem."))
		print(bot.ping( message ))

	def botTest(self, message, bot):
		if self.endpoint == "botTest.waitingCmd":
			if message.type == "text" and message.content.upper() == "FOTO":
				print(bot.sendMessage(message.chat, text="Upando uma foto pra você."))
				sentMsg = bot.sendPhoto(message.chat, inputObj=telegrambot.InputFile(PATH_PREFIX + "test/img.jpg"))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "AUDIO":
				print(bot.sendMessage(message.chat, text="Upando um áudio pra você."))
				sentMsg = bot.sendAudio(message.chat, inputObj=telegrambot.InputFile(PATH_PREFIX + "test/aud.ogg"))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "DOC":
				print(bot.sendMessage(message.chat, text="Upando esses documentos pra você."))
				sentMsg = bot.sendDocument(message.chat, inputObj=telegrambot.InputFile(PATH_PREFIX + "test/dic.zip"))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "VIDEO":
				print(bot.sendMessage(message.chat, text="Upando um vídeo pra você."))
				sentMsg =  bot.sendVideo(message.chat, inputObj=telegrambot.InputFile(PATH_PREFIX + "test/vid.mp4"))
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "LOCAL":
				print(bot.sendMessage(message.chat, text="Vou te enviar minha localização."))
				sentMsg = bot.sendLocation(message.chat, obj=telegrambot.Location({"latitude":-15.7920751, "longitude":-47.8227091} ) )
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "QUEM SOU EU":
				sentMsg = bot.sendMessage(message.chat, text=str(message.from_user) )
				self.endpoint = None

			elif message.type == "text" and message.content.upper() == "quem é você".upper():
				sentMsg = bot.sendMessage(message.chat, text=str(bot) )
				self.endpoint = None
			else:
				sentMsg = bot.sendMessage(message.chat,
					"Você precisa escolher entre 'foto', 'audio', 'video', 'doc', 'local', 'quem sou eu' ou 'quem é você'.")
			if sentMsg is None:
				print ("Message not sent.")
				bot.sendMessage(message.chat,
					"Ocorreu um erro ao enviar o conteúdo solicitado.")
			else:
				print(sentMsg)
		else:
			self.endpoint = "botTest.waitingCmd"
			print(bot.sendMessage(message.chat,
						text=("O que você quer que eu faça?\nEnvie 'foto', 'audio', 'video', 'doc', 'local', 'quem sou eu' ou 'quem é você'.\nEu não diferencio maiúsculas e minúsculas." )))

	def __repr__(self):
		"""
		() -> str
		Formal representantion for InteractiveUser object (a valid dictionary representation)
		"""
		return str(self.__dict__)

def main(bot):
	doLoop = True
	while doLoop:
		time.sleep(0.5)

logging.basicConfig(filename=PATH_PREFIX + "joaoBot-fiesp.log",level=logging.DEBUG,
	format='%(asctime)s ---- %(message)s', datefmt='%d/%m/%Y %I:%M:%S %p')

logging.info("\n\n\nroot: JOAOBOT IS STARTING....")
joaoBot = telegrambot.Bot("133283208:AAExbSZtx4njtJnlKTcTMejbsNZ4EpbHmK0")
if not joaoBot.success:
	logging.warning("root: JOAOBOT FAILED TO START.... EXITING!")
	sys.exit(1)
joaoBot.vars["users"] = {}


logging.info("root: Starting Google Maps Client...")
gmaps = googlemaps.Client(key="AIzaSyADxKKWfF2-IXwEsTGG04lw-uVKNjZLl6g")

main(joaoBot)
logging.warning("root: JOAOBOT HAS STOPPED! TRYING TO DUMP INFORMATION!")
