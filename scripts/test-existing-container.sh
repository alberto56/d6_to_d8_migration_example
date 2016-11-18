#/bin/bash
#
# Run tests on an existing environment.
#
set -e

# Make sure we can restore Drupal 8 to its pristine state.
./scripts/restore-newly-installed.sh

# Run the migration as described in the README.md
# We will use docker exec instead of docker-compose exec because of
# https://github.com/docker/compose/issues/3379
docker exec "$(docker-compose ps -q drupal8)" /bin/bash -c 'drush en -y my_migration'
docker exec "$(docker-compose ps -q drupal8)" /bin/bash -c 'drush cc drush'
docker exec "$(docker-compose ps -q drupal8)" /bin/bash -c 'drush migrate-status'
docker exec "$(docker-compose ps -q drupal8)" /bin/bash -c 'drush migrate-import --all'

./scripts/test-existing-site.sh
