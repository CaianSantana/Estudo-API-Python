from ..extensions import db

class UsuarioModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(80), unique=False, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    mensagem = db.Column(db.String(300), unique=False, nullable=True)

    def __repr__(self):
        return f"<Usuario(nome='{self.nome}', email='{self.email}')>"