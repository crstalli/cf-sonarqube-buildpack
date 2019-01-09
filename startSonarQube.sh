#!/bin/sh

echo "-----> Making java available"
export PATH=$PATH:/home/vcap/app/.java/bin


# Replace all environment variables with syntax ${MY_ENV_VAR} with the value
# thanks to https://stackoverflow.com/questions/5274343/replacing-environment-variables-in-a-properties-file
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ./sonar.properties > ./sonar_replaced.properties
mv ./sonar_replaced.properties ./sonar.properties

cat ./sonar_replaced.properties
cat ./sonar.properties

echo "------------------------------------------------------" > /home/vcap/app/sonarqube/logs/sonar.log

echo "-----> Starting SonarQube"

/home/vcap/app/sonarqube/bin/linux-x86-64/sonar.sh start

echo "-----> Tailing log"
sleep 10 # give it a bit of time to create files
cd /home/vcap/app/sonarqube/logs
tail -f ./sonar.log ./es.log ./web.log ./ce.log ./access.log
