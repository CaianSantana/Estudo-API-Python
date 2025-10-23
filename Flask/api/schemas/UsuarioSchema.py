from pydantic import BaseModel, EmailStr, constr, ConfigDict

class UsuarioSchema(BaseModel):
    model_config = ConfigDict(extra='ignore')
    nome: constr(strip_whitespace=True, min_length=1) 
    email: EmailStr 
    mensagem: str = ""