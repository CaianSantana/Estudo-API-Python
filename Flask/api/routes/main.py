from flask import Flask
from flask import render_template
from flask import request
from flask import Blueprint
from ..schemas.UsuarioSchema import UsuarioSchema
from ..services.UsuarioService import UsuarioService

usuario_route = Blueprint('api', __name__, 
                          template_folder='../templates')


@usuario_route.get("/")
def default_page():
    return render_template("index.html")

@usuario_route.post("/response")
def form_response():
    try:
        usuario_validado = UsuarioSchema(**request.form)
    except ValueError as e:
        return f"Erro de validação: {e}", 400
    
    try:
        UsuarioService.criarUsuario(usuario_validado)
    except ValueError as e:
        return f"Erro ao salvar no banco: {e}", 500

    return f"<h1>Obrigado por responder, {usuario_validado.nome}!</h1>"