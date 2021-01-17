### Trabajo Final TTPS Ruby 2020

# Gemas
* Ejecutar el comando `bundle install` para cargar las gemas correspondientes
* Se utiliza la gema `Kramdown` para el exportación, `Devise` para el CRUD de usuarios y manejo de sesiones

# Base de Datos
* Se utiliza el motor `mysql`
* En el archivo `config/database.yml` modificar los campos *username:* y *password:* con sus datos de DBMS

# Migraciones
* Ejecutar el comando `db:reset` en caso de que las base de datos *ttps2020_development*, *ttps2020_test* y/o *ttps2020_production* ya existan
* En caso de que no existan, ejecutar el comando `db:create`
* En ambos casos, luego ejecutar `db:migrate`