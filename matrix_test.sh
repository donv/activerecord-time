#!/bin/bash -el

for rb in ruby jruby-head ; do
  rvm use $rb
  for AR_VERSION in "~>4.2.1" "~>4.1.10" "~>4.0.13" "~>3.2.21" ; do
    export AR_VERSION
    bundle update
    for DB in postgresql sqlite3 ; do
      export DB
      echo
      echo Testing $rb $DB $AR_VERSION
      echo
      bundle exec rake
    done
  done
done

echo -e "\033[0;32m"
echo -e "                        TESTS PASSED OK!"
echo -e "\033[0m"
