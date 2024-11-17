# Usa Ruby 3.3.6 como base
FROM ruby:3.3.6

# Instala dependencias necesarias para Rails y PostgreSQL
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

# Instala Bundler y Rails 8.0.0
RUN gem install bundler:2.5.0
RUN gem install rails -v 8.0.0

# Establece el directorio de trabajo
WORKDIR /app

# Copia Gemfile y Gemfile.lock para instalar las dependencias del proyecto
COPY Gemfile Gemfile.lock ./

# Instala las gemas necesarias
RUN bundle install

# Copia el resto del código del proyecto
COPY . .

# Expone el puerto para el servidor de Rails
EXPOSE 3000

# Comando predeterminado para iniciar Rails
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
