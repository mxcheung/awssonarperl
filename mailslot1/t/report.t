#!/usr/bin/perl

# WRITTEN BY GORDON YEONG

use strict;
use warnings;

use Test::More;
use Test::Exception;

use lib 'lib/';
{
	use_ok('REPORT');
}
{
	can_ok('REPORT', q{identify_transaction_elements});
	my $transaction_line = q{315CL  432100020001SGXDC FUSGX NK    20100910JPY01B 0000000001 0000000000000000000060DUSD000000000030DUSD000000000010DJPY201008200012400     688058000092500000000GORDON       O};
	my %elements = REPORT::identify_transaction_elements($transaction_line);

	my %expected_elements = (
          'TICKET_NUMBER' => '0     ',
          'BUY_SELL_CODE' => 'B',
          'EXTERNAL_NUMBER' => '688058',
          'EXCH/BROKER_FEE/DEC' => '000000000060',
          'ACCOUNT_NUMBER' => '0002',
          'CLEARING_FEE_D_C' => 'D',
          'CLEARING_FEE/DEC' => '000000000030',
          'MOVEMENT_CODE' => '01',
          'CURRENCY_CODE' => 'JPY',
          'QUANTITY_LONG_SIGN' => ' ',
          'COMMISSION' => '000000000010',
          'EXCHANGE_CODE' => 'SGX ',
          'COMMISSION_D_C' => 'D',
          'OPPOSITE_TRADER_ID' => '       ',
          'SYMBOL' => 'NK    ',
          'COMMISSION_CUR_CODE' => 'JPY',
          'EXPIRATION_DATE' => '20100910',
          'OPEN_CLOSE_CODE' => 'O',
          'TRANSACTION_DATE' => '20100820',
          'EXCH/BROKER_FEE_DC' => 'D',
          'EXCH/BROKER_FEE_CUR_CODE' => 'USD',
          'CLIENT_TYPE' => 'CL  ',
          'QUANTITY_LONG' => '0000000001',
          'RECORD_CODE' => '315',
          'TRANSACTION_PRICE/DEC' => '000092500000000',
          'SUBACCOUNT_NUMBER' => '0001',
          'CLEARING_FEE_CUR_CODE' => 'USD',
          'QUANTITY_SHORT' => '0000000000',
          'PRODUCT_GROUP_CODE' => 'FU',
          'TRADER_INITIALS' => 'GORDON',
          'OPPOSITE_PARTY_CODE' => 'SGXDC ',
          'FUTURE_REFERENCE' => '001240',
          'CLIENT_NUMBER' => '4321',
          'QUANTITY_SHORT_SIGN' => ' '	
	);

	is_deeply(
		\%elements,
		\%expected_elements,
		q{Elements parsed as expected from raw transaction line}
	);
}

{
    can_ok( 'REPORT', q{get_summary_data} );
    my @parsed_data = (
        {   'CLIENT_TYPE'        => q{EVO},
            'CLIENT_NUMBER'      => q{4321},
            'ACCOUNT_NUMBER'     => q{98},
            'SUBACCOUNT_NUMBER'  => q{1},
            'EXCHANGE_CODE'      => q{CME},
            'PRODUCT_GROUP_CODE' => q{PROD1},
            'SYMBOL'             => q{M},
            'EXPIRATION_DATE'    => q{2021Jan18},
            'QUANTITY_LONG'      => 6111,
            'QUANTITY_SHORT'     => 8111,
            'TRADER_INITIALS'    => 'GORDON',
        },
        {   'CLIENT_TYPE'        => q{EVO},
            'CLIENT_NUMBER'      => q{4321},
            'ACCOUNT_NUMBER'     => q{98},
            'SUBACCOUNT_NUMBER'  => q{3},
            'EXCHANGE_CODE'      => q{CME},
            'PRODUCT_GROUP_CODE' => q{PROD1},
            'SYMBOL'             => q{M},
            'EXPIRATION_DATE'    => q{2021Jan18},
            'QUANTITY_LONG'      => 5777,
            'QUANTITY_SHORT'     => 8777,
            'TRADER_INITIALS'    => 'GORDON',
        },
        {   'CLIENT_TYPE'        => q{EVO},
            'CLIENT_NUMBER'      => q{4321},
            'ACCOUNT_NUMBER'     => q{98},
            'SUBACCOUNT_NUMBER'  => q{1},
            'EXCHANGE_CODE'      => q{CME},
            'PRODUCT_GROUP_CODE' => q{PROD1},
            'SYMBOL'             => q{M},
            'EXPIRATION_DATE'    => q{2021Jan18},
            'QUANTITY_LONG'      => 5222,
            'QUANTITY_SHORT'     => 8222,
            'TRADER_INITIALS'    => 'YEONG',
        },
        {   'CLIENT_TYPE'        => q{GRIEVO},
            'CLIENT_NUMBER'      => q{8827},
            'ACCOUNT_NUMBER'     => q{28},
            'SUBACCOUNT_NUMBER'  => q{3},
            'EXCHANGE_CODE'      => q{CME},
            'PRODUCT_GROUP_CODE' => q{PROD4},
            'SYMBOL'             => q{M},
            'EXPIRATION_DATE'    => q{2021Jan18},
            'QUANTITY_LONG'      => 333,
            'QUANTITY_SHORT'     => 300,
            'TRADER_INITIALS'    => 'YEONG',
        },
        {   'CLIENT_TYPE'        => q{GRIEVO},
            'CLIENT_NUMBER'      => q{8827},
            'ACCOUNT_NUMBER'     => q{28},
            'SUBACCOUNT_NUMBER'  => q{5},
            'EXCHANGE_CODE'      => q{CME},
            'PRODUCT_GROUP_CODE' => q{PROD3},
            'SYMBOL'             => q{M},
            'EXPIRATION_DATE'    => q{2021Jan18},
            'QUANTITY_LONG'      => 932,
            'QUANTITY_SHORT'     => 100,
            'TRADER_INITIALS'    => 'YEONG',
        },
    );

    my %summary_data = REPORT::get_summary_data(@parsed_data);
    my $expected_results = {
        'EVO,4321,98,3'    => { 'CME,PROD1,M,2021Jan18' => -3000 },
        'GRIEVO,8827,28,5' => { 'CME,PROD3,M,2021Jan18' => 832 },
        'EVO,4321,98,1'    => { 'CME,PROD1,M,2021Jan18' => -5000 },
        'GRIEVO,8827,28,3' => { 'CME,PROD4,M,2021Jan18' => 33 }
    };

    is_deeply(
        $expected_results,
        \%summary_data,
        q{  Unique product and customer sets identified with correct net totals}
    );
}
{
    my %summary_data = ();
    can_ok( 'REPORT', q{write_csv_report} );
    dies_ok(
        sub {
            REPORT::write_csv_report( { 'data' => \%summary_data, } );
        },
        q{write_csv_report dies as expected when no valid file path is given}
    );

    lives_ok(
        sub {
            REPORT::write_csv_report(
                {   'data' => \%summary_data,
                    'file' => q{/var/tmp/test_output.csv},
                }
            );
        },
        q{write_csv_report does not exit as expected when a valid file path is given}
    );

 # More comprehensive tests can be written if I could get more requirements :)
}

done_testing();
