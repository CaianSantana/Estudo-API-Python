from ..schemas.UsuarioSchema import UsuarioSchema
from ..models.UsuarioModel import UsuarioModel
from ..extensions import db
from sqlalchemy.exc import IntegrityError

class UsuarioService:
    @staticmethod
    def criarUsuario(usuario_schema: UsuarioSchema): 
        novo_usuario = UsuarioModel(
            nome=usuario_schema.nome, 
            email=usuario_schema.email, 
            mensagem=usuario_schema.mensagem
        )
        
        try:
            db.session.add(novo_usuario)
            db.session.commit()
            
            return novo_usuario
        
        except IntegrityError as e:
            db.session.rollback()
            raise ValueError(f"Erro de integridade ao salvar: {e.orig}")
            
        except Exception as e:
            db.session.rollback()
            raise ValueError(f"Erro inesperado ao salvar: {e}")