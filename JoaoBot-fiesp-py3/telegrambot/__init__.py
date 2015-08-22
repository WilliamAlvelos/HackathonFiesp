"""
Python package for Telegram Bots API
"""

__version__ = "0.1"
__author__ = "renan.lino@gmail.com"

from .types import (Update, User, ChatGroup, Message, PhotoSize, 
					Audio, Document, Sticker, Video, Contact, 
					Location, InputFile, UserProfilePhotos,
					ReplyKeyboardMarkup, ReplyKeyboardHide, ForceReply)
from .bot import Bot
from .aux import openFile

__all__ = [Update, User, ChatGroup, Message, PhotoSize, 
			Audio, Document, Sticker, Video, Contact, 
			Location, InputFile, UserProfilePhotos, Bot,
			ReplyKeyboardMarkup, ReplyKeyboardHide, ForceReply]