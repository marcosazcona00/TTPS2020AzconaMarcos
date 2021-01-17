### Trabajo Final TTPS Ruby 2020

# Gemas
* Ejecutar el comando `bundle install` para cargar las gemas correspondientes
* Se utiliza la gema `Kramdown` para el exportación, `Devise` para el CRUD de usuarios y manejo de sesiones

# Base de Datos
* Se utiliza el motor `mysql`
* En el archivo `config/database.yml` modificar los campos *username:* y *password:* con sus datos de DBMS

# Migraciones Production
* Ejecutar el comando `RAILS_ENV=production rails db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1` en caso de que las base de datos *ttps2020_production* ya exista
* En caso de que no existan, ejecutar el comando `RAILS_ENV=production rails db:create DISABLE_DATABASE_ENVIRONMENT_CHECK=1`
* En ambos casos, luego ejecutar `RAILS_ENV=production rails db:migrate DISABLE_DATABASE_ENVIRONMENT_CHECK=1`

# Migraciones Development y Testing
* Ejecutar el comando `rails db:reset` en caso de que las base de datos *ttps2020_development*, *ttps2020_test*
* En caso de que no existan, ejecutar el comando `rails db:create`
* En ambos casos, luego ejecutar `rails db:migrate`

# Aplicacion
* Para correr la aplicación, ejecutar el comando `RAILS_ENV=*ambiente_desarrollo* rails s` 
* El ambiente de desarrollo puede ser reemplazado por *production*, *testing* o *development*. Ej: `RAILS_ENV=production rails s`
* Por defecto, el comando `rails s` ejecuta la aplicacion en *development*