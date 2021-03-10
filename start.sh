#!/bin/bash

# TODO: Enable this script by removing the above.

export SECRET_KEY_BASE=r0ZqmXKFwRGpEtBpS5r18OpghlHZrutfzTIiaXOK9GvQPq9K73KkXlT4yVhAOpMP
export MIX_ENV=prod
export PORT=5234
export DATABASE_URL=ecto://events:fa6Ahx0eeris@localhost:5432/events_dev_hw08


echo "Stopping old copy of app, if any..."

_build/prod/rel/events/bin/events stop || true

echo "Starting app..."

export PORT=5234
_build/prod/rel/events/bin/events start

# TODO: Add a systemd service file
#       to start your app on system boot.

