package FutureTransactions;

use strict;
use warnings;

use Carp;
use Exporter 'import';
use Text::CSV 'csv';

our @ISA    = qw(Exporter);
our @EXPORT = qw(read_line read_file translate_row write_csv);

=head1 NAME

Akips::Model::Ticket

=head1 SYNOPSIS

   use FutureTransactions;
   my $rows = read_file($file);

=head1 DESCRIPTION

This module processed a fixed-width text file from 'System A', and
retrieves the information required to write a CSV file.

The format of the incoming file is available from
'System A File Specification.pdf'.

=head1 METHODS

=head2 read_line ($line)

Reads a line from the Future Movement file and returns a hashref
representing the information of that line.

=cut

sub read_line {
    my $line = shift;

    my @fields = (
        [ 'record_code',              1,   3 ],
        [ 'client_type',              4,   7 ],
        [ 'client_number',            8,   11 ],
        [ 'account_number',           12,  15 ],
        [ 'subaccount_number',        16,  19 ],
        [ 'opposite_party_code',      20,  25 ],
        [ 'product_group_code',       26,  27 ],
        [ 'exchange_code',            28,  31 ],
        [ 'symbol',                   32,  37 ],
        [ 'expiration_date',          38,  45 ],
        [ 'currency_code',            46,  48 ],
        [ 'movement_code',            49,  50 ],
        [ 'buy_sell_code',            51,  51 ],
        [ 'quantity_long_sign',       52,  52 ],
        [ 'quantity_long',            53,  62 ],
        [ 'quantity_short_sign',      63,  63 ],
        [ 'quantity_short',           64,  73 ],
        [ 'exch_broker_fee_dec',      74,  85 ],
        [ 'exch_broker_fee_d_c',      86,  86 ],
        [ 'exch_broker_fee_cur_code', 87,  89 ],
        [ 'clearing_fee_dec',         90,  101 ],
        [ 'clearing_fee_d_c',         102, 102 ],
        [ 'clearing_fee_cur_code',    103, 105 ],
        [ 'commission',               106, 117 ],
        [ 'commission_d_c',           118, 118 ],
        [ 'commission_cur_code',      119, 121 ],
        [ 'transaction_date',         122, 129 ],
        [ 'future_reference',         130, 135 ],
        [ 'ticket_number',            136, 141 ],
        [ 'external_number',          142, 147 ],
        [ 'transaction_price_dec',    148, 162 ],
        [ 'trader_initials',          163, 168 ],
        [ 'opposite_trader_id',       169, 175 ],
        [ 'open_close_code',          176, 176 ],
    );

    my %details = ();
    foreach my $field (@fields) {
        my ( $key, $start, $finish ) = @$field;
        $details{$key} = substr( $line, $start - 1, $finish - $start + 1 );
    }

    return \%details;
}

=head2 read_file ($file_name)

Will read the specified file and return an arrayref of hashes representing
each row in the file

=cut

sub read_file {
    my $file_name = shift;
    my @rows      = ();

    open( my $fh, '<', $file_name ) or croak "Cannot open $file_name: $!";
    while ( my $line = <$fh> ) {
        push @rows, read_line($line);
    }
    close $fh;

    return \@rows;
}

=head2 translate_row ($fields)

Takes a hashref of fields from the file, and extracts the required
information. Returns a hashref with the keys client_info, product_info and total.

=cut

sub translate_row {
    my $fields = shift;

    return {
        client_info => join( '', map { $fields->{$_} } qw(client_type client_number account_number subaccount_number) ),
        product_info => join( '', map { $fields->{$_} } qw(exchange_code product_group_code symbol expiration_date) ),
        total        => $fields->{quantity_long} - $fields->{quantity_short},
    };
}

=head2 write_csv ($AoA, $outfile)

Write the CSV information (an arryayref of arrays) to the specified file

=cut

sub write_csv {
    my ( $rows, $out_file ) = @_;

    csv( in => $rows, out => $out_file ) or croak "Cannot write CSV file: $!";
}

1;
