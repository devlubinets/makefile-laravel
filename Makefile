## Author
## Kirill Lubynets
## dev.lubinets@gmail.com
## @mrlubinets

# Usage:
# ------
# $ make apidoc           - generate API documentation
# $ make test             - Run tests
# make clear      - Clear cache, config, route
# make migrate    - Migrate table
# make utest       - Run unit tests
# make ftest       - Run feature tests
# make migrate     - Migrate model (params)

# Catch args from cli
%:
	@:
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

##Laravel

#Get version laravel
gvl:
	php artisan --version
#Laravel prefix
a:
	php artisan

ro:
	php artisan optimize:clear

# Init Laravel project
init:
	php artisan key:generate
	php artisan storage:link
	php artisan migrate
	php artisan db:seed

#############
####QUEUE####
#############

# Create queue
q:
	php artisan queue:table && php artisan migrate && echo 'QUEUE_CONNECTION=database' >> .env

# Create jobs
qc:
	php artisan make:job $(args)

qcij:
	php artisan make:job $(args) --sync

# Restart jobs
qr:
	php artisan queue:restart

# Run jobs
ql:
	php artisan queue:listen

qw:
	php artisan queue:work --timeout=600

# Clear cache, config, cache
clear:
	php artisan config:clear
	php artisan cache:clear
	php artisan route:clear
c:
	php artisan config:clear
	php artisan cache:clear
	php artisan route:clear
# Show route list
rl:
	php artisan route:list

# Create Feature test
cftest:
	php artisan make:test $(args)
# Run unit tests
utest:
	./vendor/bin/phpunit
# Run selected unit test
sutest:
#	./vendor/bin/phpunit --filter=@echo $(call args,defaultstring)
# Debug selected unit test
#dsutest:
#	XDEBUG_TRIGGER=yes ./vendor/bin/phpunit
# Run feature tests
rftest:
	./vendor/bin/phpunit --testsuite=Feature
# Run selected feature test
sftest:
	./vendor/bin/phpunit --testsuite=Feature --filter= $(args)
# Debug selected feature test
#dsutest:
#	XDEBUG_TRIGGER=yes ./vendor/bin/phpunit --testsuite=Feature --filter=@echo $(call args,defaultstring)

# Artisan test
atest:
	php artisan	test


# Artisan current test
catest:
	php artisan	test $(args)

#############
###Request###
#############
r:
	php artisan make:request $(args)

################
#####SEEDERS####
################

cs:
	php artisan make:seeder $(args)Seeder

rs:
	php artisan db:seed -v


refs:
	php artisan migrate:refresh --seed


#################
### MIGRATION ###
#################

# Create migration table
##args not plural forms
cmi:
	php artisan make:migration create_$(args)_table

# Migrate ORM Eloquent model
migrate:
	php artisan migrate
m:
	php artisan migrate
# Rollback migrate ORM Eloquent model
mr:
	php artisan migrate:rollback
# Rollback migrate one step ORM Eloquent model
mor:
	php artisan migrate:rollback --step=1
# Откат всех миграций приложения
mreset:
	php artisan migrate:reset
# Откат и миграция с помощью одной команды (удалит все таблицы базы данных независимо от их префикса)
mrefresh:
	php artisan migrate:refresh
# Удаление всех таблиц с последующей миграцией
mfresh:
	php artisan migrate:fresh
# Get status migrate ORM Eloquent model
mstatus:
	php artisan migrate:status

# Refresh table and seed
mfs:
	php artisan migrate:fresh --seed

#############
### MODEL ###
#############
# Create ORM Eloquent model
cm:
	php artisan make:model $(args)
# Create ORM Eloquent model with migrate
cmm:
	php artisan make:model $(args) -m
# Generate a model and a migration, factory
cmmf:
	php artisan make:model $(args) -mf
# Generate a model and a migration, factory, seeder
cmmfs:
	php artisan make:model $(args) -mfs

# Generate a model and a migration, factory, seeder
cmms:
	php artisan make:model $(args) -ms

##TODO если передать много значений не сработает
# Create factory for model
#php artisan make:factory Factory --model=Post
cf:
	php artisan make:factory $(args)

# Create command
mcommand:
	php artisan make:command $(args)
# Start command
pcommand:
	php artisan $(args)
# Start tinker
t:
	php artisan tinker

# Extensions
# Bensampo ENUM
enum:
	php artisan make:enum $(args)

# ORCHID Admin panel

#Install orchid
#composer require orchid/platform

oi:
	php artisan orchid:install

oadmin:
	php artisan orchid:admin dev.lubinets dev.lubinets@gmail.com 1212
oscreen:
	php artisan orchid:screen $(args)Screen
otable:
	php artisan orchid:table $(args)Table
orow:
	php artisan orchid:rows $(args)Row

# Laravel Excel
## Create import
ei:
	php artisan make:import $(args) --model=$(args)

ee:
	php artisan make:export $(args)
	#php artisan make:export $(args) --model=$(args)
# Test add args from cli
test:
	@echo $(args)
#	@echo $(call args,defaultstring)


## Defined commands for project zvlife
zvsync:
	php artisan zvsync:collaborators #Синхронизирует сотрудников
	php artisan zvsync:subdivisions  #Синхронизирует подразделения
	php artisan zvsync:icons         #Синхронизирует иконки
	php artisan zvsync:levels        #Синхронизирует категории сотрудников
	php artisan zvsync:account       #Синхронизирует счета
	php artisan zvsync:groups        #Синхронизирует группы
	php artisan zvsync:telegram      #Синхронизирует телеграм записи

## Docker
db:
	docker build -t zvlife . #TODO затягивать имя проекта как имя корневой директории
de:
	docker exec  -it $(args) /bin/bash
#Delete all container
##don't work from as $(asdasd)
ddc:
	docker rm -f $(docker ps -aq)
## Docker-compose
dcr:
	docker-compose up -d

dcb:
	docker-compose build
## up and build

## Clear laravel.log file
cl:
	> laravel.log

# Log::debug("$key => $page[$key]");

###########
###EVENT###
###########
el:
	php artisan event:list

ec:
	php artisan make:event $(args)

lc:
	php artisan make:listener $(args) --event=$(args)

eg:
	php artisan event:generate

# Create observer
##php artisan make:observer <observerName> -m=<ModelName>
oc:
	php artisan make:observer $(args)

debug:
	php -dxdebug.mode=debug -dxdebug.client_host=192.168.0.177 -dxdebug.client_port=9003 -dxdebug.start_with_request=yes $(args)


################
###Controller###
################

# Create resource controller
crc:
	php artisan make:controller $(args) --resource

crac:
	php artisan make:controller $(args) --api

################
####Resource####
################

# Create resource
cr:
	php artisan make:resource $(args)Resource

##################
####Controller####
##################

cc:
	php artisan make:controller $(args)Controller



####################
###Create Project###
####################
initl6:
	composer create-project --prefer-dist laravel/laravel LaravelLTS6 "6.*"


####################
#####Sluggable######
####################

isslug:
	composer require spatie/laravel-sluggable:*



####################
######Auth##########
####################
rnpm:
	npm install && npm run dev


##Create SQL lite
csqll:
	touch database/database.sqlite
