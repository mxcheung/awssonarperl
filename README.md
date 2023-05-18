# awssonarperl
awssonarperl

# Environment

```
export PATH="/home/ec2-user/perl5/lib/perl5:$PATH"
export PERL5LIB=/home/ec2-user/perl5/lib/perl5
export PATH="/home/ec2-user/perl5/bin:$PATH"
```

# Start up


cd /home/ec2-user/awsmc/awssonarperl/sonar-perl

docker-compose up -d sonarperl

http://ec2-13-54-11-135.ap-southeast-2.compute.amazonaws.com:9000/projects?sort=-analysis_date



# Test
```
cd /home/ec2-user/awsmc/awssonarperl/sonar-perl/perl/mailslot5

cd /home/ec2-user/environment/awssonarperl/sonar-perl/perl/mailslot5

perlcritic --cruel --quiet --verbose "%f~|~%s~|~%l~|~%c~|~%m~|~%e~|~%p~||~%n" lib t > perlcritic_report.txt

prove -t -a testReport.tgz

cover -test -report SonarGeneric

```

# Docker

```
docker-compose build mailslot4 mailslot5


cd /home/ec2-user/awsmc/awssonarperl/sonar-perl/
docker-compose build mailslot6
docker-compose run mailslot6

```


# copy code

```
rm ~/environment/awssonarperl/sonar-perl/perl/Dancer/lib/*.pm
rm ~/environment/awssonarperl/sonar-perl/perl/Dancer/t/*.pl
cp ~/environment/awssonarperl/mailslot1/perlcritic_report.txt ~/environment/awssonarperl/sonar-perl/perl/Dancer/
cp ~/environment/awssonarperl/mailslot1/testReport.tgz  ~/environment/awssonarperl/sonar-perl/perl/Dancer/
cp ~/environment/awssonarperl/mailslot1/lib/file_processor.pm ~/environment/awssonarperl/sonar-perl/perl/Dancer/lib/
cp ~/environment/awssonarperl/mailslot1/t/report.t ~/environment/awssonarperl/sonar-perl/perl/Dancer/t/
cd ~/environment/awssonarperl/sonar-perl/
docker-compose build dancer
docker-compose run dancer

rm ~/environment/awssonarperl/sonar-perl/perl/mailslot4/lib/*.pm
rm ~/environment/awssonarperl/sonar-perl/perl/mailslot4/t/*.pl
cp ~/environment/awssonarperl/mailslot2/perlcritic_report.txt ~/environment/awssonarperl/sonar-perl/perl/mailslot4/
cp ~/environment/awssonarperl/mailslot2/testReport.tgz  ~/environment/awssonarperl/sonar-perl/perl/mailslot4/
cp ~/environment/awssonarperl/mailslot2/lib/REPORT.pm ~/environment/awssonarperl/sonar-perl/perl/mailslot4/lib/
cp ~/environment/awssonarperl/mailslot2/t/report.t ~/environment/awssonarperl/sonar-perl/perl/mailslot4/t/
cd ~/environment/awssonarperl/sonar-perl/
docker-compose build mailslot4
docker-compose run mailslot4

rm ~/environment/awssonarperl/sonar-perl/perl/mailslot5/lib/*.pm
rm ~/environment/awssonarperl/sonar-perl/perl/mailslot5/t/*.pl
cp ~/environment/awssonarperl/mailslot2/perlcritic_report.txt ~/environment/awssonarperl/sonar-perl/perl/mailslot5/
cp ~/environment/awssonarperl/mailslot2/testReport.tgz  ~/environment/awssonarperl/sonar-perl/perl/mailslot5/
cp ~/environment/awssonarperl/mailslot2/lib/*.* ~/environment/awssonarperl/sonar-perl/perl/mailslot5/lib/
cp ~/environment/awssonarperl/mailslot2/t/*.* ~/environment/awssonarperl/sonar-perl/perl/mailslot5/t/
cd ~/environment/awssonarperl/sonar-perl/
docker-compose build mailslot5
docker-compose run mailslot5


```


# Links
https://awstip.com/installing-sonarqube-on-aws-ec2-instance-and-integrating-it-with-aws-codepipeline-abec99416ba4
https://gist.github.com/npearce/6f3c7826c7499587f00957fee62f8ee9

http://54.252.193.146:9000/about

https://github.com/sonar-perl/sonar-perl
https://hub.docker.com/r/sonarperl/sonar-perl

https://awstip.com/installing-sonarqube-on-aws-ec2-instance-and-integrating-it-with-aws-codepipeline-abec99416ba4

https://yum-info.contradodigital.com/view-package/base/perl-Perl-Critic/


