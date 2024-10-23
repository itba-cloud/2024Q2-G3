# Utiliza una imagen base oficial de AWS Lambda con Python 3.11
FROM public.ecr.aws/lambda/python:3.11

# Argumento para el nombre de la función Lambda
ARG LAMBDA_FILE

# Copia los archivos necesarios dentro de la imagen
COPY db.py models.py ${LAMBDA_FILE} /var/task/

RUN mv /var/task/${LAMBDA_FILE} /var/task/lambda_function.py

# Instala las dependencias
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Comando para ejecutar la función Lambda
CMD ["lambda_function.lambda_handler"]
