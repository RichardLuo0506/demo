FROM python:3

WORKDIR /hello_world

RUN pip install --upgrade pip

COPY . .

RUN pip3 install -r deps.txt

CMD ["gunicorn", "-b", "0.0.0.0:8000", "hello:app"]