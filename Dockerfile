FROM python:3.10-bullseye as initial

WORKDIR /opt/app
COPY pyproject.toml /opt/app/
COPY poetry.lock /opt/app/

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y

ENV POETRY_HOME=/opt/poetry
ENV PATH="$POETRY_HOME/bin:$PATH"
RUN curl -sSL https://install.python-poetry.org | python3 - &&\
    poetry config virtualenvs.create false
RUN poetry install --no-root --no-interaction --no-ansi -vvv

FROM initial as runtime

WORKDIR /opt/app
COPY . /opt/app

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app
