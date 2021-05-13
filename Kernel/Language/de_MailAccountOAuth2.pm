# --
# Copyright (C) 2019–present Efflux GmbH, https://efflux.de/
# Part of the OAuth2 package.
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_OAuth2;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminMailAccount
    $Self->{Translation}->{'Profiles'} = 'Profile';
    $Self->{Translation}->{'Profiles can be specified in the system configuration under the setting "OAuth2::Profiles".'} = 'Profile können in der Systemkonfiguration unter der Einstellung "OAuth2::Profiles" festgelegt werden.';

    # SysConfig
    $Self->{Translation}->{'Configure custom OAuth 2 application profiles. "Name" should be unique and will be displayed on the Mail Account Management screen. "ProviderName" can be "MicrosoftAzure", "GoogleWorkspace" or a custom provider like "Custom1" (see OAuth2::Providers).'} = 'Konfiguration von OAuth 2 Anwendungsprofilen. "Name" wird in der E-Mail-Kontenverwaltung angezeigt und sollte eindeutig sein. "ProviderName" kann "MicrosoftAzure", "GoogleWorkspace" oder ein benutzerdefinierter Anbieter wie "Custom1" sein (siehe OAuth2::Providers).';
    $Self->{Translation}->{'Custom authorization server settings.'} = 'Benutzerdefinierte Einstellungen für Autorisierungsserver.';
}

1;
