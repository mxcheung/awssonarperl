# awssonarperl
awssonarperl

# Environment

export PATH="/home/ec2-user/perl5/lib/perl5:$PATH"
export PERL5LIB=/home/ec2-user/perl5/lib/perl5
export PATH="/home/ec2-user/perl5/bin:$PATH"

# Start up


cd /home/ec2-user/awsmc/awssonarperl/sonar-perl
docker-compose up -d sonarperl

http://ec2-13-54-11-135.ap-southeast-2.compute.amazonaws.com:9000/projects?sort=-analysis_date



# Test
```
cd /home/ec2-user/awsmc/awssonarperl/sonar-perl/perl/mailslot5
perlcritic --cruel --quiet --verbose "%f~|~%s~|~%l~|~%c~|~%m~|~%e~|~%p~||~%n" lib t > perlcritic_report.txt
prove -t -a testReport.tgz
cover -test -report SonarGeneric
```

# Docker

docker-compose build mailslot4 mailslot5
docker-compose run mailslot4 mailslot5



# Links

https://gist.github.com/npearce/6f3c7826c7499587f00957fee62f8ee9

http://54.252.193.146:9000/about

https://github.com/sonar-perl/sonar-perl
