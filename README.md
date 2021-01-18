### Trabajo Final TTPS Ruby 2020

# Modelo
* La clase `Book` representa los cuadernos de los usuarios registrados en la aplicación
* La clase `Note` representa las notas del cuaderno global y/o cuadernos pertenecientes a un usuario
* La clase `User` proporcionada por la gema `devise` representa a los usuarios de la aplicacion, los cuales contienen notas (referentes a las notas que no pertenecen a un cuaderno), y cuadernos

# Gemas
* Ejecutar el comando `bundle install` para cargar las gemas correspondientes
* Se utiliza la gema `Kramdown` para el exportación, `Devise` para el CRUD de usuarios y manejo de sesiones, `Kaminari` para la paginación

# Base de Datos
* Se utiliza el motor `mysql`
* En el archivo `config/database.yml` modificar los campos *username:* y *password:* con sus datos de DBMS

# Migraciones Production
* Ejecutar el comando `export RAILS_ENV=production` para configurar el ambiente de ejecución a producción
* Ejecutar el comando `rails db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1` en caso de que las base de datos *ttps2020_production* ya exista
* En caso de que no existan, ejecutar el comando `rails db:create DISABLE_DATABASE_ENVIRONMENT_CHECK=1`
* En ambos casos, luego ejecutar `rails db:migrate DISABLE_DATABASE_ENVIRONMENT_CHECK=1`

# Aplicacion
* Para la ejecución del servidor, ejecutar el comando `rails s` 
