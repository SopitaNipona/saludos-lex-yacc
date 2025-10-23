# Multi-stage build: compile with build tools, ship a tiny runtime
FROM debian:stable-slim AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    flex bison gcc make libc6-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy sources
COPY saludos.l saludos.y ./

# Generate parser first because saludos.l includes saludos.tab.h
RUN bison -d saludos.y && \
    flex -i saludos.l && \
    gcc -O2 -s -o saludos lex.yy.c saludos.tab.c

# --- runtime image ---
FROM debian:stable-slim

WORKDIR /app
COPY --from=build /app/saludos /usr/local/bin/saludos

# Default: read from STDIN
ENTRYPOINT ["/usr/local/bin/saludos"]
