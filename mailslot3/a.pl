#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';
use lib '.';

use Carp;
use FutureTransactions;
use Text::CSV;

sub main {
    my ( $in_file, $out_file ) = @_;

    # Check the user has specified two file names
    croak 'You must specify the input file name'  unless $in_file;
    croak 'You must specify the output file name' unless $out_file;

    # Read the file
    say STDERR "Reading the file $in_file";
    my $rows = read_file($in_file);
    say STDERR scalar(@$rows), ' lines read';

    # Retrieve the required information from each row
    say STDERR 'Generating totals';
    my %totals = ();
    foreach my $row (@$rows) {
        my $fields = translate_row($row);
        $totals{ $fields->{client_info} }{ $fields->{product_info} } += $fields->{total};
    }

    # Generate the rows for the csv file
    say STDERR 'Generating rows';
    my @rows = ( [ 'Client_Information', 'Product_Information', 'Total_Transaction_Amount' ] );
    foreach my $client_info ( sort keys %totals ) {
        push @rows, map { [ $client_info, $_, $totals{$client_info}{$_} ] } sort keys %{ $totals{$client_info} };
    }
    say STDERR scalar(@rows), ' rows written (including the header)';

    # Write the CSV file
    say STDERR "Writing the CSV file $out_file";
    write_csv( \@rows, $out_file );
}

main(@ARGV);
