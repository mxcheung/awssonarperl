#!/usr/bin/env perl

use strict;
use warnings;
use FindBin '$Bin';
use Test::More tests => 43;

use lib "$Bin/..";
use_ok('FutureTransactions');

diag('Reading test file');
my $rows = read_file("$Bin/test.txt");
is( scalar(@$rows), 4, '4 rows read' );

diag('Check some random values from the file');
is( $rows->[0]{record_code},         '315',          'First record code' );
is( $rows->[1]{expiration_date},     '20100910',     'Second expiration date' );
is( $rows->[2]{exch_broker_fee_dec}, '000000000000', 'Third exchange broker fee' );
is( $rows->[3]{external_number},     '000443',       'Fourth external number' );

diag('Check we can read all values in a row');
my $fields = read_line(
    '315CL  432100030001FCC   FUCME N1    20100910JPY01S 0000000000 0000000003000000000000DUSD000000000015DUSD000000000000DJPY20100819059616      000449000093350000000             O'
);

is( $fields->{record_code},              '315',             'Correct record_code' );
is( $fields->{client_type},              'CL  ',            'Correct client_type' );
is( $fields->{client_number},            '4321',            'Correct client_number' );
is( $fields->{account_number},           '0003',            'Correct account_number' );
is( $fields->{subaccount_number},        '0001',            'Correct subaccount_number' );
is( $fields->{opposite_party_code},      'FCC   ',          'Correct opposite_party_code' );
is( $fields->{product_group_code},       'FU',              'Correct product_group_code' );
is( $fields->{exchange_code},            'CME ',            'Correct exchange_code' );
is( $fields->{symbol},                   'N1    ',          'Correct symbol' );
is( $fields->{expiration_date},          '20100910',        'Correct expiration_date' );
is( $fields->{currency_code},            'JPY',             'Correct currency_code' );
is( $fields->{movement_code},            '01',              'Correct movement_code' );
is( $fields->{buy_sell_code},            'S',               'Correct buy_sell_code' );
is( $fields->{quantity_long_sign},       ' ',               'Correct quantity_long_sign' );
is( $fields->{quantity_long},            '0000000000',      'Correct quantity_long' );
is( $fields->{quantity_short_sign},      ' ',               'Correct quantity_short_sign' );
is( $fields->{quantity_short},           '0000000003',      'Correct quantity_short' );
is( $fields->{exch_broker_fee_dec},      '000000000000',    'Correct exch_broker_fee_dec' );
is( $fields->{exch_broker_fee_d_c},      'D',               'Correct exch_broker_fee_d_c' );
is( $fields->{exch_broker_fee_cur_code}, 'USD',             'Correct exch_broker_fee_cur_code' );
is( $fields->{clearing_fee_dec},         '000000000015',    'Correct clearing_fee_dec' );
is( $fields->{clearing_fee_d_c},         'D',               'Correct clearing_fee_d_c' );
is( $fields->{clearing_fee_cur_code},    'USD',             'Correct clearing_fee_cur_code' );
is( $fields->{commission},               '000000000000',    'Correct commission' );
is( $fields->{commission_d_c},           'D',               'Correct commission_d_c' );
is( $fields->{commission_cur_code},      'JPY',             'Correct commission_cur_code' );
is( $fields->{transaction_date},         '20100819',        'Correct transaction_date' );
is( $fields->{future_reference},         '059616',          'Correct future_reference' );
is( $fields->{ticket_number},            '      ',          'Correct ticket_number' );
is( $fields->{external_number},          '000449',          'Correct external_number' );
is( $fields->{transaction_price_dec},    '000093350000000', 'Correct transaction_price_dec' );
is( $fields->{trader_initials},          '      ',          'Correct trader_initials' );
is( $fields->{opposite_trader_id},       '       ',         'Correct opposite_trader_id' );
is( $fields->{open_close_code},          'O',               'Correct open_close_code' );

diag('Checking row translation');
my $translated = translate_row($fields);
is( $translated->{client_info},  'CL  432100030001',     'Correct client_info' );
is( $translated->{product_info}, 'CME FUN1    20100910', 'Correct product_info' );
is( $translated->{total},        -3,                     'Correct total' );
