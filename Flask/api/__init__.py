import os
from flask import Flask
from .extensions import db
from .routes.main import usuario_route 

def create_app():
    app = Flask(__name__)

    db_uri = os.environ.get('DATABASE_URI', 'sqlite:///seu_banco.db')

    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)

    app.register_blueprint(usuario_route)

    return app