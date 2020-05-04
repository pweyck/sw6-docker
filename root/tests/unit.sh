#!/bin/sh

set -e

sleep 10

echo 'Starting php-fpm'
echo
php-fpm > /dev/null 2>&1 &

echo 'Starting nginx'
echo
nginx > /dev/null 2>&1 &

sleep 1


cd /app

phpConnTest=$(cat <<'PHPDOC'
include "vendor/autoload.php";
$u = explode("/", $_SERVER["DATABASE_URL"]);

for ($i=0; $i< 10; ++$i) {
    try {
        \Doctrine\DBAL\DriverManager::getConnection(["url" => $u[0] . "//" . $u[2]])->connect();
        exit(0);
    } catch (\Throwable $e) {
        sleep(1);
    }
}
exit(2);
PHPDOC
)

echo "Connecting to db "

php -r "$phpConnTest"

bin/console system:install --drop-database --basic-setup --force

TEST_SUITES="administration storefront checkout content framework profiling migration system elasticsearch docs"

for TEST_SUITE in $TEST_SUITES; do
    php -d memory_limit=1824M vendor/bin/phpunit --configuration phpunit.xml.dist --colors=never --testsuite "$TEST_SUITE"
done
