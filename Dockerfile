# Bruger Python 3.9-baseret Alpine Linux som grundlæggende image.
# Alpine er et letvægts Linux-distribution, der gør containere mindre.
FROM python:3.9-alpine3.13

# Tilføjer metadata om, hvem der vedligeholder dette image.
LABEL maintainer="RKLJ"

# Sørger for, at output fra Python bliver sendt direkte til terminalen,
# i stedet for at blive bufferet (nyttigt til logging i containere).
ENV PYTHONUNBUFFERED 1

# Kopierer requirements.txt (afhængigheder) fra projektmappen til en midlertidig mappe i containeren.
COPY ./requirements.txt /tmp/requirements.txt

# Kopierer hele app-mappen fra værten (din computer) til /app-mappen i containeren.
COPY ./app /app

# Sætter arbejdsdirektoriet til /app, så alle følgende kommandoer køres herfra.
WORKDIR /app

# Åbner port 8000 i containeren, så Django-applikationen kan tilgås udefra.
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        -D django-user


# Kører flere kommandoer:
#RUN python -m venv /py && \  # Opretter et virtuelt Python-miljø i /py
 #   /py/bin/pip install --upgrade pip && \  # Opdaterer pip til nyeste version
 #   /py/bin/pip install -r /tmp/requirements.txt && \  # Installerer alle afhængigheder fra requirements.txt
 #   rm -rf /tmp && \  # Fjerner den midlertidige mappe /tmp for at spare plads
 #   adduser \  # Tilføjer en ny bruger til containeren for sikkerheds skyld
 #       --disabled-password \  # Deaktiverer adgangskode (da vi ikke har brug for login)
 #       --no-create-home \  # Forhindrer oprettelse af en hjemmemappe (ikke nødvendigt i en container)
 #       -D django-user  # Opretter brugeren 'django-user' i Alpine Linux

# Tilføjer /py/bin til PATH-variablen, så python og pip kan køres uden at angive den fulde sti.
ENV PATH="/py/bin:$PATH"

# Skifter til den ikke-administrative bruger 'django-user' for at øge sikkerheden.
USER django-user
