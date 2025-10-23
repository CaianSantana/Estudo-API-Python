#!/bin/sh
set -e


echo "Inicializando o banco de dados..."
flask init-db

echo "Iniciando o servidor Flask..."
exec flask run --host=0.0.0.0