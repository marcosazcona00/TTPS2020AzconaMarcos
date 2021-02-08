### Trabajo Final TTPS Ruby 2020
# Requisitos
* Ruby (>=2.5)
* Bundler installado. En caso de no tenerlo ejecutar `gem install bundler`

# Modelo
* La clase `Book` representa los cuadernos de los usuarios registrados en la aplicación
* La clase `Note` representa las notas del cuaderno global y/o cuadernos pertenecientes a un usuario
* La clase `User` proporcionada por la gema `devise` representa a los usuarios de la aplicacion, los cuales contienen notas (referentes a las notas que no pertenecen a un cuaderno), y cuadernos

# Gemas
* Ejecutar el comando `bundle install` para cargar las gemas correspondientes
* Se utiliza la gema `Kramdown` para el exportación de notas, `Devise` para el CRUD de usuarios y manejo de sesiones, y `Kaminari` para la paginación

# Base de Datos
* Se utiliza el motor `sqlite3`

# Migraciones Production
* Ejecutar el comando `export RAILS_ENV=production` para configurar el ambiente de ejecución a producción. En caso de no poder realizar dicha acción, antes de cada comando insertar la linea `RAILS_ENV=production`, ejemplo: `RAILS_ENV=production rails db:migrate`
* Luego creamos la base de datos de producción ejecutando `rails db:create`
* Finalmente realizar las migraciones con `rails db:migrate`

# Aplicacion
* Para la ejecución del servidor, ejecutar el comando `RAILS_ENV=production rails s` 
