from sqlalchemy import Column, String, Text, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
import datetime

Base = declarative_base()

class Comment(Base):
    __tablename__ = 'comments'

    comment_id = Column(String, primary_key=True)
    content = Column(Text, nullable=False)
    user_id = Column(String, ForeignKey('users.user_id'), nullable=False)
    publication_id = Column(String, ForeignKey('publications.publication_id'), nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.now, nullable=False)

    user = relationship("User", back_populates="comments")
    publication = relationship("Publication", back_populates="comments")

    def to_dict(self):
        return {
            'comment_id': str(self.comment_id),
            'content': self.content,
            'user_id': str(self.user_id),
            'publication_id': str(self.publication_id),
            'created_at': self.created_at.isoformat(),
            'user': self.user.to_dict()
        }

class Publication(Base):
    __tablename__ = 'publications'
    publication_id = Column(String, primary_key=True)
    title = Column(String(100), nullable=False)
    content = Column(Text, nullable=False)
    user_id = Column(String, ForeignKey('users.user_id'), nullable=False) 
    created_at = Column(DateTime, default=datetime.datetime.now, nullable=False)

    user = relationship("User", back_populates="publications")
    comments = relationship("Comment", back_populates="publication") 

    def to_dict(self):
        return {
            'publication_id': str(self.publication_id),
            'title': self.title,
            'content': self.content,
            'user_id': str(self.user_id),
            'created_at': self.created_at.isoformat(),
            'user': self.user.to_dict()
        }

class User(Base):
    __tablename__ = 'users'

    user_id = Column(String, primary_key=True)
    username = Column(String(100), nullable=False, unique=True)
    email = Column(String(100), nullable=False, unique=True)

    publications = relationship("Publication", back_populates="user")
    comments = relationship("Comment", back_populates="user")

    def to_dict(self):
        return {
            'user_id': str(self.user_id),
            'username': self.username,
            'email': self.email
        }
