package REPORT;

# WRITTEN BY GORDON YEONG

use strict;
use warnings;

use Readonly;
use IO::File;

# CONFIGURATIONS - for this test, I have opted to keep everything in the package
# but in the real world, some organisations will opt for a yaml config (which
# can be done easily)

Readonly my $max_input_characters_per_line => 302;

# configuration for input elements in the input file.
# the value of the hash ref represents the length of the element's string
# Assumption: There must only be one slice per hashref

Readonly::Array my @input_element_placements => (
    { 'RECORD_CODE'              => 3, },
    { 'CLIENT_TYPE'              => 4, },
    { 'CLIENT_NUMBER'            => 4, },
    { 'ACCOUNT_NUMBER'           => 4, },
    { 'SUBACCOUNT_NUMBER'        => 4, },
    { 'OPPOSITE_PARTY_CODE'      => 6, },
    { 'PRODUCT_GROUP_CODE'       => 2, },
    { 'EXCHANGE_CODE'            => 4, },
    { 'SYMBOL'                   => 6, },
    { 'EXPIRATION_DATE'          => 8, },
    { 'CURRENCY_CODE'            => 3, },
    { 'MOVEMENT_CODE'            => 2, },
    { 'BUY_SELL_CODE'            => 1, },
    { 'QUANTITY_LONG_SIGN'       => 1, },
    { 'QUANTITY_LONG'            => 10, },
    { 'QUANTITY_SHORT_SIGN'      => 1, },
    { 'QUANTITY_SHORT'           => 10, },
    { 'EXCH/BROKER_FEE/DEC'    => 12, },
    { 'EXCH/BROKER_FEE_DC'       => 1, },
    { 'EXCH/BROKER_FEE_CUR_CODE' => 3, },
    { 'CLEARING_FEE/DEC'       => 12, },
    { 'CLEARING_FEE_D_C'         => 1, },
    { 'CLEARING_FEE_CUR_CODE'    => 3, },
    { 'COMMISSION'               => 12, },
    { 'COMMISSION_D_C'           => 1, },
    { 'COMMISSION_CUR_CODE'      => 3, },
    { 'TRANSACTION_DATE'         => 8, },
    { 'FUTURE_REFERENCE'         => 6, },
    { 'TICKET_NUMBER'            => 6, },
    { 'EXTERNAL_NUMBER'          => 6, },
    { 'TRANSACTION_PRICE/DEC'    => 15, },
    { 'TRADER_INITIALS'          => 6, },
    { 'OPPOSITE_TRADER_ID'       => 7, },
    { 'OPEN_CLOSE_CODE'          => 1, },
#    { 'FILLER'                   => 127, },
);

# methods
sub identify_transaction_elements
{
    my ($transaction_line) = @_;
    my $transaction_line_has_valid_data = (
        (defined($transaction_line))
        and ($transaction_line =~ m{\w})
    );

    unless ($transaction_line_has_valid_data)
    {
        return;
    }

    my @raw_data = split qr{}, $transaction_line, $max_input_characters_per_line;

    # Sanitise the data. We don't want trailing spaces at the end of
    # data. For example, 'SGXDC ' will be 'SGXDC' which is much
    # neater for reporting/display purposes.
    @raw_data = map { defined $_ and $_ =~ m{\w} ? $_ : q{ } } @raw_data;

    my %data = ();
    my $index = 0;
    foreach my $element_config (@input_element_placements)
    {
        ELEMENT_NAME: foreach my $element_name (keys %{$element_config})
        {
            my $ending_index = $index + $element_config->{$element_name} - 1;
            $data{ $element_name } = join q{}, @raw_data[ $index .. $ending_index];

            $index = $ending_index+1;
            last ELEMENT_NAME;
        }
    }

    return %data;
}

sub _get_client_information
{
    my ($data) = @_;
    return join q{,}, (
        $data->{'CLIENT_TYPE'},
        $data->{'CLIENT_NUMBER'},
        $data->{'ACCOUNT_NUMBER'},
        $data->{'SUBACCOUNT_NUMBER'},
    );
}

sub _get_product_information
{
    my ($data) = @_;
    return join q{,}, (
        $data->{'EXCHANGE_CODE'},
        $data->{'PRODUCT_GROUP_CODE'},
        $data->{'SYMBOL'},
        $data->{'EXPIRATION_DATE'},
    );
}

sub _get_total_transaction_amount
{
    my ($data) = @_;
    return $data->{'QUANTITY_LONG'} - $data->{'QUANTITY_SHORT'} + 0;
}

# Pass it an array which has hashref of parsed data
# It will find the unique sets of product and customers, and get its totals
sub get_summary_data {
    my (@parsed_data) = @_;
    my %summary_data = ();
    foreach my $parsed_data_element (@parsed_data) {
        my $client_information
            = _get_client_information($parsed_data_element);
        my $product_information
            = _get_product_information($parsed_data_element);
        my $total = _get_total_transaction_amount($parsed_data_element);
        if (defined(
                $summary_data{$client_information}->{$product_information}
            )
            )
        {
            $summary_data{$client_information}->{$product_information}
                += $total;
        }
        else {
            $summary_data{$client_information}->{$product_information}
                = $total;
        }
    }
    return %summary_data;

}

# Given a file name and a hashref of data, it will generate a csv file
sub write_csv_report {
    my ($args) = @_;
    my $file_write_mode = q{w};

    my $fh = IO::File->new( $args->{'file'}, $file_write_mode );
    if ( defined $fh ) {
        my $header_string = join q{,}, (
             q{Client_Information},
             q{Product_Information},
             q{Total_Transaction_Amount},
        );
        print $fh $header_string . qq{\n};

        # Given the data is pretty straightforward(i.e. does not have
        # commas in them, i decided not to escape the contents).
        # 'Less is more'

        my $data = $args->{'data'};
        foreach my $customer ( keys %{$data} ) {
            foreach my $product ( keys %{ $data->{$customer} } ) {
                my $data_string = join q{,},
                    (
                        $customer,
                        $product,
                        $data->{$customer}->{$product},
                    );
                print $fh $data_string . qq{\n};
            }
        }
        undef $fh;
    }
    else {
        die qq{Cannot write csv report: $!};
    }
    return;
}

1;


=head1 NAME

REPORT

=head1 DESCRIPTION

Does the heavy lifting of generating a daily summary report for ABN AMRO BANK.


CONFIGURATIONS - for the purpose of simplicity in this technical test,
I have opted to keep everything in the package
but in the real world, some organisations will opt for a yaml config (which
can be done easily)

Written by GORDON YEONG


=head1 REQUIRES


L<IO::File> 

L<Readonly> 


=head1 METHODS

=head2 get_summary_data

 get_summary_data();

Pass it an array which has hashref of parsed data
It will find the unique sets of product and customers, and get its totals


=head2 identify_transaction_elements

 identify_transaction_elements();

methods


=head2 write_csv_report

 write_csv_report();

Given a file name and a hashref of data, it will generate a csv file



=cut

