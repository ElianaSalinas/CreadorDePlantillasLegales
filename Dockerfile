FROM node:22-alpine

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install ALL dependencies (including devDependencies needed for build)
RUN npm ci

# Copy source code
COPY . .

# ---------------------------------------------------------------
# Variables que Next necesita DURANTE el build, no al arrancar.
#
# Todo lo que empieza por NEXT_PUBLIC_ lo sustituye el compilador por
# su valor literal. Si no existe aqui dentro, queda `undefined` para
# siempre en el bundle, y ninguna variable puesta en Railway lo
# arregla despues: hay que volver a construir.
#
# Railway pasa las variables del servicio como build arguments, pero
# solo llegan a las que estan declaradas con ARG. Esta linea es lo
# que faltaba el dia que /precios se desplego con el mensaje de error
# ya escrito en el HTML.
# ---------------------------------------------------------------
ARG NEXT_PUBLIC_GA_ID
ENV NEXT_PUBLIC_GA_ID=$NEXT_PUBLIC_GA_ID

# Build the Next.js app
RUN npm run build

# Expose port
EXPOSE 3000

ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
ENV PORT=3000

# Escucha en el puerto que inyecta Railway ($PORT). Si no existe, usa 3000.
CMD ["sh", "-c", "node_modules/.bin/next start -H 0.0.0.0 -p ${PORT:-3000}"]
