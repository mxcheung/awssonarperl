package Fruit;
use strict;
use warnings;

 sub new {
     my ( $class, %args ) = @_;
     my $self = \%args;

     send_message();
     bless $self, $class;
     return $self;
 };

sub set_name {

    my $self = shift;
    return  $self->{'name'} = shift;
};

sub get_name {
    my $self = shift;
    return $self->{'name'};
};
    
sub set_color {
    
     my $self = shift;
     return  $self->{'color'} = shift;
};

sub get_color {
     my $self = shift;
     return  $self->{'color'};
};   
    
    sub send_message {
       my $awsAccessKey =  $ENV{'AWS_ACCESS_KEY'};
       my $awsSecretAccessKey =  $ENV{'AWS_SECRET_ACCESS_KEY'};
       my $awsTopicARN =  $ENV{'AWS_TOPIC_ARN'};
       my $awsSNSServiceURL =  $ENV{'AWS_SNS_SERVICE_URL'};


       # Get/set SNS service url, something like 'http://sns.us-east-1.amazonaws.com'.
       #       $sns->service($awsSNSServiceURL);


       # create a new topic and publish
#       my $topic = $sns->CreateTopic('perlsns')  or die $sns->error;

       # publish to a known ARN


    };
1;

__END__

=head1 NAME

Fruit.pm - Define Fruit Object - Getters and Setters

=head1 SYNOPSIS

Fruit has name, colour and taste

=head1 DESCRIPTION

Define attributes for Fruit using test driven development

=cut


