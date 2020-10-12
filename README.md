# XIM Runway Dispatcher

Используемые компоненты:
* Redis
* ActionCable
* RabbitMQ
* React.js

Состав:
* script/side_worker.rb - воркер по обработке очереди самолетов на взлет, запускается отдельным процессом. Читает очередь с Redis, отправляет событие в RabbitMQ, ждет ответа от сервиса. Отправляет события в ActionCable.
* script/takeoff_service.rb - "сервис" по взлёту, подписывается на очередь в RabbitMQ, спит 10..15 секунд отправляет событие о взлёте

Для упрощения сервис для взлета лежит в приложении.
В реальности сервис для взлета будет отдельным приложением.

Env:
* RAILS_ENV=development
* RAILS_MASTER_KEY=90b19a889e99006ee9d9f9819dcc1d5a
* WEB_CONCURRENCY=2
* RAILS_MAX_THREADS=2
* RAILS_MIN_THREADS=2
* XIM_DATABASE_URL=postgres://xim:1@172.16.23.20:5432/xim
* XIM_REDIS_URL=redis://password@localhost:6379/15
* XIM_BUNNY_URL=amqp://guest:guest@localhost:5672/

Хотелось это все запихнуть в докер, но уже времени недостаточно