#!/bin/bash -el

echo
rvm use ruby
rake

echo
rvm use jruby
rake

echo -e "\033[0;32m"
echo -e "                        TESTS PASSED OK!"
echo -e "\033[0m"
