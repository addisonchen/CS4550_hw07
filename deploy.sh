#!/bin/bash

export SECRET_KEY_BASE=r0ZqmXKFwRGpEtBpS5r18OpghlHZrutfzTIiaXOK9GvQPq9K73KkXlT4yVhAOpMP
export MIX_ENV=prod
export PORT=5234
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"
export DATABASE_URL=ecto://events:fa6Ahx0eeris@localhost:5432/events_dev_hw08


echo "Building..."

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest

echo "Generating release..."
mix release

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/practice/bin/practice stop || true

echo "Starting app..."

PROD=t ./start.sh
