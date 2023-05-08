FROM python:3.6
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 5002
CMD python -m flask run --host=0.0.0.0 --port=5002