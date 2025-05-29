FROM python:3.9-alpine3.13
LABEL maintainer="rebecca"

ENV PYTHONUNBUFFERED 1

# Copy requirements from my computer to docker image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Sets the working directory inside the image to /app.
# Effect: All subsequent commands (RUN, CMD, etc.) will be executed in /app.
WORKDIR /app

COPY ./app /app

# Documents that the container will listen on port 8000 at runtime.
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"
USER django-user