# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019–present Efflux GmbH, https://efflux.de/
# Part of the OAuth2 package. Original file: POP3TLS.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::MailAccount::POP3OAuth2;

use strict;
use warnings;

use Net::POP3;
use MIME::Base64;  # eyazi@efflux:

use parent qw(Kernel::System::MailAccount::POP3);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

# Use Net::SSLGlue::POP3 on systems with older Net::POP3 modules that cannot handle POP3.
BEGIN {
    if ( !defined &Net::POP3::starttls ) {
        ## nofilter(TidyAll::Plugin::OTRS::Perl::Require)
        ## nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)
        require Net::SSLGlue::POP3;
    }
}

sub Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host Timeout Debug)) {
        if ( !defined $Param{$_} ) {
            return (
                Successful => 0,
                Message    => "Need $_!",
            );
        }
    }

    my $Type = 'POP3OAuth2';

    # connect to host
    my $PopObject = Net::POP3->new(
        $Param{Host},
        Timeout => $Param{Timeout},
        Debug   => $Param{Debug},
    );

    if ( !$PopObject ) {
        return (
            Successful => 0,
            Message    => "$Type: Can't connect to $Param{Host}"
        );
    }

    $PopObject->starttls(
        SSL             => 1,
        SSL_verify_mode => 0,
    );

    # authentication

    # ---
    # eyazi@efflux:
    # ---
    my $AccessToken = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type  => 'MailAccount',
        Key   => "AccesToken::MailAccount::$Param{ID}",
    );

    if (!$AccessToken) {
        $AccessToken = $Kernel::OM->Get('Kernel::System::OAuth2::MailAccount')->GetAccessToken(
            MailAccountID => $Param{ID}
        );

        if (!$AccessToken) {
            return (
                Successful => 0,
                Message    => "$Type: Could not request access token for $Param{Login}/$Param{Host}'. The refresh token could be expired or invalid."
            );
        }
    }

    my $SASLXOAUTH2 = encode_base64('user=' . $Param{Login} . "\x01auth=Bearer " . $AccessToken . "\x01\x01");
    $PopObject->command('AUTH', 'XOAUTH2')->response();
    my $NOM = $PopObject->command($SASLXOAUTH2)->response();
    # ---

    if ( !defined $NOM ) {
        $PopObject->quit();
        return (
            Successful => 0,
            Message    => "$Type: Auth for user $Param{Login}/$Param{Host} failed!"
        );
    }

    return (
        Successful => 1,
        PopObject  => $PopObject,
        NOM        => $NOM,
        Type       => $Type,
    );
}

1;
