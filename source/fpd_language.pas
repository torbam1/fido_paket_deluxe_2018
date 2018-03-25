unit fpd_language;
// language file for Fido-Package deluxe (www.fido-deluxe.de.vu)
// last change: 04-NOV-2005

// VerzeichnisAuswahl.LabelCaptions und .NewFolderCaptions zusдtzlich anpassen
// "Installations-Verzeichnis:" -> "Install folder:" -> ...
// "Neues Verzeichnis" -> "New directory" -> ...

interface

var s: array[1..295] of string;
    sprache  : String[20]; // Sprache (deutsch, englisch, flaemisch, russisch, spanisch)
    sprache_Hinweis, sprache_Fehler, sprache_Info: PChar;
    sprache_Fehlercode: string;

procedure sprachen_strings_initialisieren(sprache: String);
procedure englisch_strings_initialisieren;
procedure flaemisch_strings_initialisieren;
procedure russisch_strings_initialisieren;
procedure spanisch_strings_initialisieren;
procedure deutsch_strings_initialisieren;

implementation

procedure sprachen_strings_initialisieren(sprache: String);
begin
  if sprache = 'englisch' then englisch_strings_initialisieren
  else if sprache = 'flaemisch' then flaemisch_strings_initialisieren
  else if sprache = 'russisch' then russisch_strings_initialisieren
  else if sprache = 'spanisch' then spanisch_strings_initialisieren
  else deutsch_strings_initialisieren;
end;

procedure englisch_strings_initialisieren;
begin
  s[0001] := 'Fido-Package deluxe';
  s[0002] := 'Fido-Package deluxe Setup';
  s[0003] := 'Fido-Package deluxe - Setup';
  s[0004] := 'Welcome to the Fido-Package deluxe - installation program' + Chr(13)
             + '%s, by Michael Haase (m.haase@gmx.net)';
  s[0005] := 'Homepage with the always latest version: http://www.fido-deluxe.de.vu';
  s[0006] := 'Do you want to install the Fido-Package deluxe, now?';
  s[0007] := '&Update';
  s[0008] := '&Yes';
  s[0009] := '&Exit setup';

  s[0010] := 'Now, please make sure that the network connection is online, it';
  s[0011] := 'Now, please make sure that the internet connection is online, it';
  s[0012] := 'Now, please make sure that the internet connection is ready to use, it';
  s[0013] := 'Now, please turn on the modem / ISDN device, it';
  s[0014] := Chr(13) + 'will be tried to build up a connection to the selected' + Chr(13)
             + 'Fido sysop.';

  s[0015] := 'No actual internet connection recognized.';

  s[0016] := 'Password for %s:';
  s[0017] := 'Internet connection';

  s[0018] := 'An error occurred during building up the connection, the' + Chr(13)
             + 'connection was disconnected before sending and receiving the mails.' + Chr(13)
             + 'Error at action: Poll' + Chr(13)
             + 'Message: %s';

  s[0019] := 'Connection established.';

  s[0020] := 'Status:';
  s[0021] := 'Fido registration is running..';

  s[0022] := 'Installation successfully finished.' + Chr(13)
             + 'A link has been created in start menu and' + Chr(13)
             + 'on desktop (Fido-Menu).';

  s[0023] := 'An error occurred.' + Chr(13)
             + 'Error code: %s' + Chr(13)
             + 'Action: Poll';

  s[0024] := 'Connection failed. Perhaps this is due to a' + Chr(13)
             + 'temporary error. Perhaps try again later.' + Chr(13)
             + 'For further information you might want to have a look into' + Chr(13)
             + 'the log file (%s' + '\binkley\binkd.log).';

  s[0025] := 'Faulty data (CDN) received. Error code: %s';
  sprache_Fehlercode := 'Error code'; //  ^^^^^^^^^^ must be this!

  s[0026] := 'The registration data have been successfully transfered.' + #13
             + 'Now, the first Fido area is connected, finally, and therefore '
             + 'tested if everything has been installed completely.' + #13
             + #13
             + 'After installation is completed you will find a manual for '
             + 'this Fido-Package and further interesting information under the '
             + ' menu point "Info about Fido, Help ..." in the main menu.' + #13
             + #13
             + 'Your first step probably will be that you subscribe to some '
             + 'areas (also called echo). This is done in the menu "Connect or '
             + 'Disconnect an echo". If you are interested in Star Trek Voyager, '
             + 'for example, you might like to subscribe to TREK_VOYAGER. Or '
             + 'the Simpsons (SIMPSONS)? PC hardware (HARDWARE)? There are '
             + 'quite a lot interesting areas, so have a look into the list '
             + 'and subscribe to the one or the other that you like.';

  s[0027] := 'Installation of the Fido-Package deluxe';
  s[0028] := 'Name';
  s[0029] := 'Please enter first and last name';
  s[0030] := 'Location';
  s[0031] := 'Phone';
  s[0032] := 'Please enter area code and phone number, seperated by a dash';
  s[0033] := ''; // wird nicht mehr benцtigt
  s[0034] := ''; // wird nicht mehr benцtigt
  s[0035] := ''; // wird nicht mehr benцtigt
  s[0036] := '(Internet-) Connect via Dial-Up Network with:';
  s[0037] := ''; // wird nicht mehr benцtigt
  s[0038] := ''; // wird nicht mehr benцtigt
  s[0039] := 'Operating system';
  s[0040] := 'Recognized operating system: ';
  s[0041] := 'Choose installation directory';
  s[0042] := 'Installation directory: %s' + ':\FIDO';
  s[0043] := 'Register as Fido member (Point) at the following Fido System:';
  s[0044] := 'Phone        Location                                        Sysop name';
  s[0045] := 'Start &installation';
  s[0046] := '&Abort (Quit)';
  s[0047] := 'Poll';
  s[0048] := 'The connection is establishing...';
  s[0049] := 'Status of the connection:';
  s[0050] := 'Abort';

  s[0051] := 'The given CDN file wasnґt found:' + Chr(13)
             + '%s';
  s[0052] := 'Please give the complete path to the CDN file!' + chr(13)
             + '(e.g.: c:\example\example.cdn)';

  s[0053] := 'The Dial-Up Network is not installed, but an internet connection.' + Chr(13)
             + 'is detected. So, you may proceed installation, but you will' + Chr(13)
             + 'only be able to use internet connections.';

  s[0054] := 'The Dial-Up Network is not installed, but is required.' + Chr(13)
             + 'Please install it by selecting Software / Windows-Setup' + Chr(13)
             + 'found in My Computer / Control Panel, and start again' + Chr(13)
             + 'the installation of the Fido-Package deluxe, then.';
  s[0055] := 'Error during installation';

  s[0056] := 'internet connection';

  s[0057] := 'There is no modem or ISDN device installed in the Dial-Up Network.' + Chr(13)
             + 'Please do it and then start again the installation of' + Chr(13)
             + 'the Fido-Package deluxe.';

  s[0058] := 'It occurred an unknown error by creating a new' + Chr(13)
             + 'connection in the Dial-Up Network.' + Chr(13)
             + 'Installation is stopped.';

  s[0059] := 'Recognized operating system: %s';

  s[0060] := 'Error by opening the file "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + 'Error code: %s';

  s[0061] := 'No international dial prefix has been entered, yet.';
  s[0062] := 'Error in input';
  s[0063] := 'No name has been entered, yet.';
  s[0064] := 'The given name is not complete.';
  s[0065] := 'No location has been entered, yet.';
  s[0066] := 'The given location is not valid.';
  s[0067] := 'No telephone number has been entered, yet.';
  s[0068] := 'Please separate area code from phone number with "-",' + Chr(13)
             + 'for example: 02732-12345';
  s[0069] := 'The given phone number is not valid.';
  s[0070] := 'For the Call-By-Call number only figures are allowed.' + Chr(13)
             + '(Or leave the field empty.)';

  s[0071] := 'There is not enough free space left on' + Chr(13)
             + 'disk drive (%s' + ':).' + Chr(13)
             + 'At least 20 MB are required.';

  s[0072] := 'Fido-Menu';
  s[0073] := 'Cancel Fido membership';
  s[0074] := 'Uninstall Fido-Package deluxe';

  s[0075] := 'No reason given, probably a temporary error.' + Chr(13)
             + 'Perhaps try again later.' + Chr(13)
             + 'For further information you might want to have a look into' + Chr(13)
             + 'the log file (%s' + '\binkley\binkd.log).';
  s[0076] := 'The selected Fido system doesnґt accept new Fido members (Points)'
             + Chr(13) + 'at the moment. The given reason:' + Chr(13);
  s[0077] := 'Please stop the installation of Fido-Package deluxe, or'
             + Chr(13) + 'choose another Fido system.';

  s[0078] := 'Shall the so far installed files be removed?';
  s[0079] := 'Abort of installation';
  s[0080] := 'All so far installed files removed.';

  s[0081] := 'There must not be any spaces (" ") in the path.'
             + Chr(13) + 'Directory: %s' + Chr(13)
             + Chr(13) + 'Please choose another directory.';
  s[0082] := 'The selected install directory already exists.'
             + Chr(13) + 'Directory: %s' + Chr(13)
             + '*** All contained files and sub directories will be deleted! ***'
             + Chr(13) + Chr(13)
             + 'Sure?';
  s[0083] := 'Warning';

  s[0084] := 'Installation directory: %s';

  s[0085] := 'other internet provider';

  s[0086] := 'No old installation found.'
             + Chr(13) + 'Directory: %s'
             + Chr(13) + 'File searched: point.cdn' + Chr(13)
             + Chr(13) + Chr(13)
             + 'Please select another directory.';

  s[0087] := 'Update successfully finished.';

  s[0088] := 'Fido-Package deluxe (10 MB) is going to be installed.' + Chr(13)
             + 'Please wait.';

  s[0089] := 'Really abort installation?';
  s[0090] := 'Abort';
  s[0091] := 'Shall the so far installed files be removed?';
  s[0092] := 'All so far installed files removed.';

  s[0093] := 'network card = no dial-up connection';
  s[0094] := 'internet connection';
  s[0095] := 'An unexpected error occurred by gathering the connections' + Chr(13)
             + 'in the Dial-Up Network.' + Chr(13);
  s[0096] := 'Error code: %s' + Chr(13)
             + 'Please report this to the author:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := 'An unexpected error occurred by allocating memory.' + Chr(13);
  s[0098] := 'no modem or ISDN capi found';

  s[0099] := 'isdn'; // do not change!
  s[0100] := 'modem'; // do not change!
  s[0101] := 'Kommunikationskabel'; // do not change until you know what you do!

  s[0102] := 'The Dial-Up Network is not installed. Now, an active internet connection is searched..';
  s[0103] := 'Internet connection is active, donґt search anymore';

  s[0104] := 'Fido-Package';

  s[0105] := 'CDN file no longer found.' + Chr(13)
             + 'Please do not copy it in the installation directory!';

  s[0106] := 'The Fido-Package deluxe is uninstalled, now.';
  s[0107] := 'Uninstall';
  s[0108] := 'Really uninstall the Fido-Package deluxe?';

  s[0109] := '&Show Fido Menu';
  s[0110] := 'E&xit';

  s[0111] := ' Main menu (Fido-Package deluxe)';
  s[0112] := 'Fido-Package deluxe %s' + Chr(13)
             + '          by Michael Haase';
  s[0113] := '  Send and receive mails (Poll)      ';
  s[0114] := '  Read and write mails (Editor)        ';
  s[0115] := '   Connect or Disconnect an echo ';
  s[0116] := '  Search files at the File-List-Server';
  s[0117] := '  See and cut logfiles                      ';
  s[0118] := '    Info about Fido, Help ...                      ';
  s[0119] := '  Quit     ';
  s[0120] := '  Bug report';

  s[0121] := 'The internet connection is not available.';
  s[0122] := 'Password:';

  s[0123] := 'You have new (personal) mail.' + Chr(13)
             + 'Netmails: %s' + Chr(13)
             + 'Echomail: %s';

  s[0124] := ''; // wird nicht mehr benцtigt

  s[0125] := 'An error occurred.' + Chr(13)
             + 'Error code: %s' + Chr(13)
             + 'Action: Editor';

  s[0126] := 'Do you really want to cancel Fido membership' + Chr(13)
             + 'and cancel subscription for all areas?';
  s[0127] := 'Cancel Fido membership?';

  s[0128] := 'Number of connected areas: %s';

  s[0129] := 'The given search keyword wasnґt found.';
  s[0130] := 'Search';
  s[0131] := 'No further hits for the given search keyword.';

  s[0132] := 'Really abort (all changes become lost)?';

  s[0133] := 'Number of available areas: %s';

  s[0134] := ' Area administration';
  s[0135] := 'For (dis-)connecting an area do a double click on it.';
  s[0136] := 'Area selection:';
  s[0137] := '   main';
  s[0138] := '    North-American';
  s[0139] := '   local';
  s[0140] := '    regional';
  s[0141] := 'Search keyword';
  s[0142] := 'search';
  s[0143] := 'search next';
  s[0144] := 'OK';

  s[0145] := 'Number of available North-American areas: %s';
  s[0146] := 'Number of available bbs areas: %s';
  s[0147] := 'Number of available (regional) net areas: %s';

  s[0148] := 'Really abort (donґt generate search request)?';
  s[0149] := 'The search request has been generated. The next time' + Chr(13)
             + 'you poll (Send and receive mails), the search' + Chr(13)
             + 'will be processed and you can get the results a short time' + Chr(13)
             + 'after (poll again).';

  s[0150] := 'The logfile is smaller than 300 KB, so it' + Chr(13)
             + 'is not neccessary to cut it.';
  s[0151] := 'Logfile doesnґt exist.';
  s[0152] := 'Size of the logfile: %s KB';
  s[0153] := 'Logfile';
  s[0154] := 'Cut logfile';
  s[0155] := 'Back';

  s[0156] := 'Please insert the Fido-Package deluxe CD and click again on "Other".';
  s[0157] := 'Pictures';

  s[0158] := ' Fido Infos';
  s[0159] := '    Fido Infos';
  s[0160] := '     Your nodeґs infos';
  s[0161] := '     Golded manual';
  s[0162] := '    Other';
  s[0163] := ''; // wird nicht mehr benцtigt
  s[0164] := 'back';
  s[0165] := 'next';
  s[0166] := 'Close';

  s[0167] := 'AutoPoll: Poll all %s'
             + ' minutes automatically, when window is minimized';
  s[0168] := 'Scale for AutoPoll; units in minutes';
  s[0169] := 'Internet provider:';

  s[0170] := 'Not all RAS functions (Dial-Up network) have been found.' + Chr(13)
             + 'Anyway, it will be tried to continue.' + Chr(13)
             + 'If any error occurs, please report this to the author:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';

  s[0171] := 'AutoPoll';
  s[0172] := 'Colors in editor';
  s[0173] := 'Groups';
  s[0174] := 'Address macros';
  s[0175] := 'Data';
  s[0176] := 'History';
  s[0177] := 'Updates';

  s[0178] := 'Text';
  s[0179] := 'Quote level';
  s[0180] := 'Background';
  s[0181] := 'Black';
  s[0182] := 'Blue';
  s[0183] := 'Green';
  s[0184] := 'Cyan';
  s[0185] := 'Red';
  s[0186] := 'Magenta';
  s[0187] := 'Brown';
  s[0188] := 'Grey';
  s[0189] := 'Light Grey';
  s[0190] := 'Light Blue';
  s[0191] := 'Light Green';
  s[0192] := 'Light Cyan';
  s[0193] := 'Light Red';
  s[0194] := 'Light Magenta';
  s[0195] := 'Yellow';
  s[0196] := 'White';

  s[0197] := 'The always latest version and updates are available at the '
             + 'homepage.' + Chr(13)
             + 'The actual addresses (URLs) are:';

  s[0198] := 'Bold';
  s[0199] := 'Italic';
  s[0200] := 'Underlined';

  s[0201] := 'In Golded (editor) you can use an address macro for writing '
             + 'a message to often used names. At "To:" simply enter the '
             + 'macro, e.g. mh for Michael Haase, 2:2432/280.';

  s[0202] := 'Warning: The point number and the passwords only should be changed '
             + 'if you know what you do. Otherwise, the result could be that '
             + 'you are not able to receive or send mails, anymore!';
  s[0203] := 'Point address';
  s[0204] := '(on change the old AKA will be cancelled!)';
  s[0205] := 'Session';
  s[0206] := 'Password';
  s[0207] := 'Areafix';
  s[0208] := 'Filemgr';
  s[0209] := 'Footer below each message:';

  s[0210] := 'Error occured during reading of %s' + Chr(13)
             + '(File does not exist or is not complete)!' + Chr(13)
             + 'Because of this the data (address and passwords) is not' + Chr(13)
             + 'changeable.';

  s[0211] := 'Expert configurations';
  s[0212] := 'no proxy';
  s[0213] := 'IP address';

  s[0214] := 'The old point number will be cancelled, now.';

  s[0215] := ''; // wird nicht mehr benцtigt

  s[0216] := 'Groups in the editor (Golded):';
  s[0217] := 'add group name';
  s[0218] := 'remove group name';
  s[0219] := 'change group name';
  s[0220] := 'Existing areas:';
  s[0221] := 'selected area belongs to group:';
  s[0222] := 'Grup name';
  s[0223] := 'New group name:';

  s[0224] := 'no log file found';

  s[0225] := 'Please enter the file name (or a part of it) you are looking for '
             + 'and press enter (or click on OK). You can enter up to 3 search '
             + 'key words. Important: No wildcards (stars or question marks) '
             + 'allowed!';
  s[0226] := 'Search key word:';
  s[0227] := 'Files containing the following search key words will be searched:';
  s[0228] := 'Notice: The search request at first will be generated. The actual '
             + 'search will be done when you poll (Send and receive mails) the '
             + 'next time.';
  s[0229] := 'generate search request';
  s[0230] := 'remove selected entries';
  s[0231] := 'Del'; // Entfernen-Taste
  s[0232] := 'show results';

  s[0233] := 'Configuration';
  s[0234] := 'Poll';

  s[0235] := ''; // wird nicht mehr benцtigt
  s[0236] := ''; // wird nicht mehr benцtigt
  s[0237] := ''; // wird nicht mehr benцtigt
  s[0238] := ''; // wird nicht mehr benцtigt
  s[0239] := ''; // wird nicht mehr benцtigt

  s[0240] := '    Configuration                                  ';
  s[0241] := 'Other';

  s[0242] := 'There are new infos from your node.' + Chr(13)
             + 'To see them click on "Info about Fido, Help ..."' + Chr(13)
             + 'and then on "Your nodeґs infos".';

  s[0243] := 'The window with the IRC chat is still open.' + #13
             + 'Really quit?';
  s[0244] := 'Chat with other Fido users..';

  s[0245] := ''; // wird nicht mehr benцtigt

  s[0246] := 'Access to the request file (%s) did not work.';
  s[0247] := 'Empty passwords are not allowed. Password-Change ignored.';

  s[0248] := 'Hello!' + #13#10
             + #13#10
             + 'Welcome to Fido. Because of the automatic registration you '
             + 'can subscribe to areas and read mails immediately. For getting '
             + 'write permission. you have to contact your node (to whom you '
             + 'registered at just a minute ago). For that you can simply  '
             + 'reply to this mail (press key "q" and then Enter key twice, '
             + 'write your text and then press ALT-S and Enter for saving) '
             + 'and send off the reply by the menu point "Send and receive mail '
             + '(Poll)" in the main menu.' + #13#10
             + #13#10
             + 'You also can call or write an eMail:' + #13#10
             + #13#10
             + 'Name: %s' + #13#10
             + 'Phone: %s' + #13#10
             + 'eMail: %s' + #13#10
             + #13#10
             + #13#10
             + 'A manual for this Fido-Package and further info you will find '
             + 'in the main menu under the point "Info about Fido, Help ...".' + #13#10
             + #13#10
             + 'If you should not be able to poll (catch mails) for a longer time, '
             + 'please inform your node, because otherwise you usually will become '
             + 'automatically deleted after 100 days of inactivity.' + #13#10
             + #13#10
             + 'May I ask from where did you hear about this Fido-Package?' + #13#10
             + #13#10
             + 'Wishing you great fun..' + #13#10
             + #13#10
             + '(This is an automatically created mail by the Fido-Package '
             + 'deluxe %s.)' + #13#10;

  s[0249] := 'The Acrobat Reader for displaying PDF documents is not installed. '
             + 'You can get it here:' + #13
             + 'www.adobe.com/products/acrobat/readstep2.html' + #13
             + '(or if you own the Fido-Package cd-rom, it is in '
             + '\sonst\andere-programme\acrobat-reader 5\)' + #13
             + #13
             + 'Alternatively there is the manual also in the RTF format, which '
             + 'can be displayed directly. You can download it here:' + #13
             + 'www.fido-deluxe.de.vu';

  s[0250] := '(Realname, please, Fakes' + #13
             + 'become deleted immediately!)';

  s[0251] := 'Because of rude language and offenses towards new users,' + #13
             + 'rules contradicting against laws or Fido policies,' + #13
             + 'and the exclusion of gay people in the rules, this' + #13
             + 'area has restricted access! If you are really sure you' + #13
             + 'want to subscribe to this area, you should be an advanced' + #13
             + 'Fido user, so you should and have to know how to subscribe' + #13
             + 'manually for this area.' + #13
             + 'The rules just were created as a netmail, you can read them' + #13
             + 'within Golded.' + #13
             + '- NEC 2457, Michael Haase (2:2457/2)';

  s[0252] := 'Window size (number of lines) of Golded (editor):';

  s[0253] := 'At the moment "other Provider" is configured for internet' + #13
             + 'connection. If you have a network (LAN) connection into' + #13
             + 'the internet, then no appropiate selection were available' + #13
             + 'during installation. With network (LAN) it will no longer' + #13
             + 'checked if an internet connection is available.' + #13
             + 'Do you want to change to network (LAN) connection?';
  s[0254] := 'local network (LAN) = no online check';

  s[0255] := 'Old installation found. Shall these data be used for' + #13
             + 'installation (so no new registration)?';

  s[0256] := 'subscribe again all subscribed areas';
  s[0257] := 'List created. With the next Poll ("Send and receive mails")' + #13
             + 'the subscription will be sent.';
  s[0258] := '(with Win 95/98/ME only 25, 43 or 50 lines are possible)';
  s[0259] := 'Node Name';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := 'The point number you entered is not valid!' + #13
             + 'It must be in the format z:nnnn/nnnn.ppppp,' + #13
             + 'e.g. "2:2457/280.13" or "2:2457/280.0".';
  s[0262] := 'Update List';
  s[0263] := 'List updated.';
  s[0264] := 'Connection failure. Internet connection active?';
  s[0265] := 'Transaction failure.';
  s[0266] := 'Invalid Host.';
  s[0267] := 'Update List';
  s[0268] := 'Update list from internet';
  s[0269] := 'Open list from hard disk';
  s[0270] := 'No new registration, I know my access data';
  s[0271] := 'Input of the access data';
  s[0272] := 'Point number:';
  s[0273] := 'Password:';
  s[0274] := 'Areafix password:';
  s[0275] := 'File Ticker password:';
  s[0276] := 'PKT password:';
  s[0277] := 'Areafix name:';
  s[0278] := 'File Ticker name:';
  s[0279] := 'E-Mail address of the node:';
  s[0280] := 'Telephone number of the node:';
  s[0281] := 'Please check the given data twice,' + #13
             + 'with wrong data it does not work!';
  s[0282] := 'Node number (_not_ complete AKA!) (optional):';
  s[0283] := 'Input not complete!';
  s[0284] := 'Selection list faulty, standard list will be used.';
  s[0285] := 'Enter proxy on previous page if necessary. Internet connection must already be active!';
  s[0286] := 'Name of the node:';
  s[0287] := 'Complete node address (e.g. 2:2432/280):';
  s[0288] := 'DNS/IP (e.g. fido.dyndns.org):';
  s[0289] := '### Other node (enter data yourself)'; // must begin with '#'! (because of sorting of the list)
  s[0290] := '    Problem-Check';
  s[0291] := 'Fido-Package manual';

  s[0292] := 'Error occured during reading of binkd.cfg.' + #13
             + 'Does it exist?';
  s[0293] := 'Error detected in the "node"-line in binkd.cfg.' + #13
             + 'DNS entry is missing or faulty.';

  sprache_Hinweis := 'Notice';
  sprache_Fehler := 'Error';
  sprache_Info := 'Info';
end;

procedure flaemisch_strings_initialisieren;
begin
  s[0001] := 'Fido-Pakket deluxe';
  s[0002] := 'Fido-Pakket deluxe Setup';
  s[0003] := 'Fido-Pakket deluxe - Setup';
  s[0004] := 'Welkom bij Fido-Pakket deluxe - Installatie programma' + Chr(13)
             + '%s, van Michael Haase (m.haase@gmx.net)';
  s[0005] := 'Homepage met de meest aktuele versie : http://www.fido-deluxe.de.vu';
  s[0006] := 'Mag Fido-Pakket deluxe nu geinstalleerd worden?';
  s[0007] := '&Update';
  s[0008] := '&Ja';
  s[0009] := 'Setup &afsluiten';

  s[0010] := 'Ok, zie dat de netwerkverbinding nu open staat, het';
  s[0011] := 'Ok, zie dat de internet verbinding nu open staat, het';
  s[0012] := 'Gelieve vast te stellen of de internet verbinding klaar staat voor gebruik le';
  s[0013] := 'Gelieve nu de modem/Isdn apparaat aan te zetten';
  s[0014] := Chr(13) + 'opdat we kunnen uitbellen naar een Fido-sysop.';

  s[0015] := 'Keine bestehende Internet-Verbindung erkannt.';

  s[0016] := 'Passwort fьr %s:';
  s[0017] := 'Internet-Verbindung';

  s[0018] := 'Er is een fout opgetreden bij het verbinden vooraleer' + Chr(13)
              + 'iets verstuurd of ontvangen kon worden van berichten.' + Chr(13)
              + 'Fout bij aktie: Pollen' + Chr(13)
              + 'Melding: %s';

  s[0019] := 'Verbinding gemaakt.';

  s[0020] := 'Status:';
  s[0021] := 'Fido-aanmelding loopt..';

  s[0022] := 'De installatie is succesrijk afgesloten.' + Chr(13)
             + 'Er werd een snelkoppeling aangemaakt in het startmenu en op' + Chr(13)
             + 'het bureaublad (Fido-Menu).';

  s[0023] := 'Er is een fout opgetreden.' + Chr(13)
             + 'Foutnummer: %s' + Chr(13)
             + 'Aktie: Pollen';

  s[0024] := 'Connection failed. Perhaps this is due to a' + Chr(13)
             + 'temporary error. Perhaps try again later.' + Chr(13)
             + 'For further information you might want to have a look into' + Chr(13)
             + 'the log file (%s' + '\binkley\binkd.log).';

  s[0025] := 'Foute gegevens (CDN) ontvangen. Foutcode: %s';
  sprache_Fehlercode := 'Foutcode'; //        ^^^^^^^^ must be this!

  s[0026] := 'De registratiegegevens werden succesvol overgezonden.' + #13
             + 'Nu wordt het eerste Fido gebied aangemaakt, en zal uiteindelijk '
             + 'alles getest worden op een succesrijke installatie.' + #13
             + #13
             + 'Nach der Installation findest Du im Hauptmenь unter dem '
             + 'Menьpunkt "Infos zu Fido, Hilfe ..." ein Handbuch '
             + 'zu diesem Fido-Paket und weitere interessante Informationen.' + #13
             + #13
             + 'Dein erster Schritt wird vermutlich sein, daЯ Du Dir ein paar '
             + 'Areas (auch Echo genannt) anbestellst, dies geht im Menь "Echo '
             + 'an- oder abbestellen". Wenn Du Dich z.B. fьr Star Trek '
             + 'interessierst, dann mцchtest Du vielleicht die Startrek.ger '
             + 'anbestellen (das ".ger" steht fьr German, also deutsch). Oder '
             + 'Witze (Jokes.Ger)? PC-Hardware (Hardware.ger)? Es '
             + 'gibt sehr viele interessante Areas, schau also gleich mal in '
             + 'die Liste und bestell Dir die eine oder andere an, die Du magst.';

  s[0027] := 'Installatie van Fido-Pakket deluxe';
  s[0028] := 'Naam';
  s[0029] := 'Bitte Vornahme-Nahme ingeben';
  s[0030] := 'Gemeente';
  s[0031] := 'Telefoon';
  s[0032] := 'Please enter area code and phone number, seperated by a dash';
  s[0033] := ''; // wird nicht mehr benцtigt
  s[0034] := ''; // wird nicht mehr benцtigt
  s[0035] := ''; // wird nicht mehr benцtigt
  s[0036] := '(Internet-) Verbinding over het telefoonnetwerk wordt aangemaakt met:';
  s[0037] := ''; // wird nicht mehr benцtigt
  s[0038] := ''; // wird nicht mehr benцtigt
  s[0039] := 'Besturingssysteem';
  s[0040] := 'Huidig besturingssysteem: ';
  s[0041] := 'Doeldirectory wijzigen';
  s[0042] := 'Doeldirectory: %s' + ':\FIDO';
  s[0043] := 'Fido-lid (point) worden bij de volgende Fido-server (node):';
  s[0044] := 'Telefoonnr  Gemeente                                    Sysopnaam';
  s[0045] := '&Installatie starten';
  s[0046] := '&Afbreken/Stoppen';
  s[0047] := 'Pollen';
  s[0048] := 'De verbinding wordt aangemaakt...';
  s[0049] := 'Status van de verbinding:';
  s[0050] := 'Afbreken';

  s[0051] := 'De verwachte CDN-gegevens werden niet gevonden:' + Chr(13)
             + '%s';
  s[0052] := 'Gelieve het volledige pad te geven naar deze CDN-gegevens!' + chr(13)
             + '(Bijv.: c:\voorbeeld\voorbeeld.cdn';

  s[0053] := 'Das DFЬ Netzwerk ist nicht installiert, es wurde jedoch' + Chr(13)
             + 'eine Internet-Verbindung erkannt. Daher kann mit der' + Chr(13)
             + 'Installation fortgefahren werden, allerdings wird es nur' + Chr(13)
             + 'mцglich sein, Internet-Verbindungen herzustellen.';

  s[0054] := 'de Externe Toegang werd niet geinstalleerd in Windows, maar' + Chr(13)
             + 'bis wel vereist. Gelieve met behulp van Software/Windows setup' + Chr(13)
             + 'onder Start/Instellingen deze te installeren, en' + Chr(13)
             + 'dan de verdere installatie van het Fido-Pakket Deluxe verder te zetten.';
  s[0055] := 'Fout bij de installatie';

  s[0056] := 'internet-verbinding';

  s[0057] := 'Er werd geen modem of isdn-kaart gevonden in de Externe Toegang.' + Chr(13)
             + 'Gelieve deze te installeren en dan de installatie van het' + Chr(13)
             + 'Fido-Pakket deluxe opnieuw te starten.';

  s[0058] := 'Er is een onbekende fout opgetreden bij het aanmaken van een nieuwe' + Chr(13)
             + 'verbinding met de Externe Toegang.' + Chr(13)
             + 'De installation wordt afgebroken.';

  s[0059] := 'Huidig besturingssysteem: %s';

  s[0060] := 'Fout bij het openen van het bestand "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + 'Foutnummer: %s';

  s[0061] := 'Er werd nog geen internationale kengetal ingegeven.';
  s[0062] := 'Fout bij ingave';
  s[0063] := 'Er werd nog geen naam ingegeven.';
  s[0064] := 'De ingegeven naam is niet volledig.';
  s[0065] := 'Er werd nog geen gemeente ingevoerd.';
  s[0066] := 'De opgegeven lokatie is niet in orde.';
  s[0067] := 'Er werd geen telefoonnummer ingegeven.';
  s[0068] := 'Gelieve bij het telefoonnr ook de prefix te voegen,' + Chr(13)
             + ' bijv : 016-12345';
  s[0069] := 'Er werd een ongeldig telefoonnummer ingegeven.';
  s[0070] := 'Het telefoonnummer kan alleen uit cijfers bestaan.' + Chr(13)
             + '(laat anders het veld leeg.)';

  s[0071] := 'Er is niet genoeg vrije ruimte op de gekozen' + Chr(13)
             + 'doelschijf (%s' + ':) aanwezig.' + Chr(13)
             + 'Er is minstens 20 Mb vereist.';

  s[0072] := 'Fido-Menu';
  s[0073] := 'Afmelden van Fido';
  s[0074] := 'Verwijderen van Fido-Pakket deluxe';

  s[0075] := 'geen reden, waarschijnlijk een tijdelijke fout.' + Chr(13)
             + 'Gelieve later nog eens te proberen.' + Chr(13)
             + 'For further information you might want to have a look into' + Chr(13)
             + 'the log file (%s' + '\binkley\binkd.log).';
  s[0076] := 'Het gekozen Fido-Systeem accepteert voor het moment geen'
             + Chr(13) + 'nieuwe points meer. De reden:' + Chr(13);
  s[0077] := 'Gelieve de installatie van het Fido-Pakket Deluxe af te breken,'
             + Chr(13) + 'of een ander Fido-systeem te kiezen.';

  s[0078] := 'Moeten de reeds geinstalleerte software weggeveegd worden?';
  s[0079] := 'Afbraak van de installatie';
  s[0080] := 'Alle reeds geinstalleerde bestanden werden terug verwijderd.';

  s[0081] := 'Es dьrfen keine Leerzeichen (spaces, " ") im Pfad enthalten sein.'
             + Chr(13) + 'Verzeichnis: %s' + Chr(13)
             + Chr(13) + 'Bitte ein anderes Verzeichnis wдhlen.';
  s[0082] := 'Het geselecteerde installatiepad bestaat reeds.'
            + Chr(13) + 'pad: %s' + Chr(13)
            + '*** Alle bestanden & folders onder dit pad zullen worden verwijderd! ***'
            + Chr(13) + Chr(13)
            + 'Bent U zeker?';
  s[0083] := 'Waarschuwing';

  s[0084] := 'Doeldirectory: %s';

  s[0085] := 'andere internet-provider';

  s[0086] := 'Keen alde installatie gefonden.'
             + Chr(13) + 'pad: %s'
             + Chr(13) + 'Gesuchte Datei: point.cdn' + Chr(13)
             + Chr(13) + Chr(13)
             + 'Bitte ein anderes Verzeichnis wдhlen.';

  s[0087] := 'Update succesrijk afgesloten.';

  s[0088] := 'Het Fido-Pakket deluxe (10 Mb) wordt nu geinstalleerd.' + Chr(13)
             + 'Even geduld aub.';

  s[0089] := 'Installatie werkelijk afbreken?';
  s[0090] := 'Afbreken';
  s[0091] := 'Moeten de reeds geinstalleerte software weggeveegd worden?';
  s[0092] := 'Alle reeds geinstalleerde bestanden worden verwijderd.';

  s[0093] := 'Netwerkkaart = geen keuzeverbinding';
  s[0094] := 'internet-verbinding';
  s[0095] := 'Er is een onverwachte fout opgetreden bij het opvragen van de verbinding' + Chr(13)
             + 'van de externe toegang.' + Chr(13);
  s[0096] := 'Foutcode: %s' + Chr(13)
             + 'Gelieve de programmeur te verwittigen:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := 'Er is een onverwachte Fout bij de allokatie van vrije ruimte opgetreden.' + Chr(13);
  s[0098] := 'kein Modem oder ISDN Capi gefunden';

  s[0099] := 'isdn'; // do not change!
  s[0100] := 'modem'; // do not change!
  s[0101] := 'Kommunikationskabel'; // do not change until you know what you do!

  s[0102] := 'Das DFЬ Netzwerk ist nicht installiert. Es wird jetzt nach einer aktiven Internet-Verbindung gesucht..';
  s[0103] := 'Internet-Verbindung steht, nicht weiter suchen';

  s[0104] := 'Fido-Pakket';

  s[0105] := 'CDN Datei nicht mehr gefunden.' + Chr(13)
             + 'Diese bitte nicht in das Installationsverzeichnis kopieren!';

  s[0106] := 'Das Fido-Paket deluxe ist nun deinstalliert.';
  s[0107] := 'Verwijderen';
  s[0108] := 'Ben je zeker dat je Fido-Pakket Deluxe wilt verwijderen?';

  s[0109] := '&Zeige Fido-Menь';
  s[0110] := 'B&eenden';

  s[0111] := ' Hoofdmenu (Fido-Pakket deluxe)';
  s[0112] := 'Fido-Pakket deluxe %s' + Chr(13)
             + '         van Michael Haase';
  s[0113] := '  Berichten zenden && ontvangen (Pollen)';
  s[0114] := '  Berichten lezen && schrijven (Editor)       ';
  s[0115] := '   Gebieden aan && afsluiten                    ';
  s[0116] := '  Data zoeken bij File-List-Server          ';
  s[0117] := '  Logbestanden bekijken & afkorten       ';
  s[0118] := '  Info''s over Fido, Help ...                   ';
  s[0119] := '  Quit     ';
  s[0120] := '  Bug report';

  s[0121] := 'Die Internet-Verbindung ist nicht verfьgbar.';
  s[0122] := 'Passwort:';

  s[0123] := 'Du hast neue (persцnliche) Mail.' + Chr(13)
             + 'Netmails: %s' + Chr(13)
             + 'Echomail: %s';

  s[0124] := ''; // wird nicht mehr benцtigt

  s[0125] := 'Er is een fout opgetreden.' + Chr(13)
             + 'Foutnummer: %s' + Chr(13)
             + 'Aktie: Tekstverwerker';

  s[0126] := 'Willst Du Dich wirklich vom Fido abmelden' + Chr(13)
             + 'und alle Areas abbestellen?';
  s[0127] := 'Abmelden?';

  s[0128] := 'Aantal aangesloten gebieden: %s';

  s[0129] := 'Het gezochte werd niet gevonden.';
  s[0130] := 'Zoeken';
  s[0131] := 'Geen verdere zoekresultaten meer.';

  s[0132] := 'Werkelijk afbreken (alle gemaakte aanpassingen gaan verloren)?';

  s[0133] := 'Aantal Beschikbare gebieden: %s';

  s[0134] := ' Discussiegebied-keuze';
  s[0135] := 'Slechts een dubbelklik om gebieden aan/af te sluiten.';
  s[0136] := 'Discussiegebied-keuze:';
  s[0137] := '   Duitse';
  s[0138] := '    Amerikaanse';
  s[0139] := '   lokale';
  s[0140] := '    regionale';
  s[0141] := 'Zoekbegrip';
  s[0142] := 'zoeken';
  s[0143] := 'verder zoeken';
  s[0144] := 'OK';

  s[0145] := 'Aantal beschikbare amerikanische discussiegebieden: %s';
  s[0146] := 'Aantal beschikbare lokale discussiegebieden: %s';
  s[0147] := 'Aantal beschikbare (regionale) discussiegebieden: %s';

  s[0148] := 'Ben je zeker dat je wil afbreken (geen zoekaanvraag genereren)?';
  s[0149] := 'De zoek aanvraag werd gegenereerd en zal verstuurd' + Chr(13)
             + 'worden de volgende keer dat je pollt (Berichten versturen en' + Chr(13)
             + 'ontvangen).';

  s[0150] := 'Het logbestand is kleiner dan 300 Kb, en zodus' + Chr(13)
             + 'niet nodig om te verkorten.';
  s[0151] := 'Logbestand bestaat niet.';
  s[0152] := 'Grootte van de Logbestanden: %s Kb';
  s[0153] := 'Logbestand';
  s[0154] := 'Logbestand verkorten';
  s[0155] := 'terug';

  s[0156] := 'Gelieve de Fido-Pakket deluxe CD in de cdromspeler te steken en om op "Varia" te klikkenstiges".';
  s[0157] := 'Bilder';

  s[0158] := ' Fido-Info';
  s[0159] := '   Info over Fido';
  s[0160] := '     Info over je Nodes';
  s[0161] := '     Golded Handboek';
  s[0162] := '      Varia';
  s[0163] := ''; // wird nicht mehr benцtigt
  s[0164] := 'terug';
  s[0165] := 'verder';
  s[0166] := 'Afsluiten';

  s[0167] := 'AutoPoll: Alle %s'
             + ' Minuten automatisch pollen, wenn Fenster minimiert';
  s[0168] := 'Anzeige fьr AutoPoll; Angaben in Minuten';
  s[0169] := 'Internet-Provider:';

  s[0170] := 'Not all RAS functions (Dial-Up network) have been found.' + Chr(13)
             + 'Anyway, it will be tried to continue.' + Chr(13)
             + 'If any error occurs, please report this to the author:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';

  s[0171] := 'AutoPoll';
  s[0172] := 'Farben im Editor';
  s[0173] := 'Gruppen';
  s[0174] := 'Adressmakros';
  s[0175] := 'Daten';
  s[0176] := 'History';
  s[0177] := 'Updates';

  s[0178] := 'Text';
  s[0179] := 'Quoteebene';
  s[0180] := 'Hintergrund';
  s[0181] := 'Schwarz';
  s[0182] := 'Blau';
  s[0183] := 'Grьn';
  s[0184] := 'Cyan';
  s[0185] := 'Rot';
  s[0186] := 'Magenta';
  s[0187] := 'Braun';
  s[0188] := 'Grau';
  s[0189] := 'Hellgrau';
  s[0190] := 'Hellblau';
  s[0191] := 'Hellgrьn';
  s[0192] := 'Hellcyan';
  s[0193] := 'Hellrot';
  s[0194] := 'Hellmagenta';
  s[0195] := 'Gelb';
  s[0196] := 'Weiss';

  s[0197] := 'Die jeweils aktuelle Version und Updates gibt es auf der '
             + 'Homepage.' + Chr(13)
             + 'Die aktuellen Adressen (URLs) sind:';

  s[0198] := 'Fett';
  s[0199] := 'Kursiv';
  s[0200] := 'Unterstrichen';

  s[0201] := 'In Golded (Editor) kann man beim Schreiben einer Mail beim '
             + 'Adressaten ein Adressmakro fьr hдufig verwendete Namen '
             + 'benutzen. Bei "An:" einfach das Kьrzel eingeben, z.B. mh '
             + 'fьr Michael Haase, 2:2432/280.';

  s[0202] := 'Achtung: Die Дnderung der Pointnummer und der Passwцrter sollte '
             + 'nur erfolgen, wenn man weiЯ, was man macht. Ansonsten kann dies '
             + 'dazu fьhren, daЯ keine Mails mehr empfangen oder versendet '
             + 'werden kцnnen!';
  s[0203] := 'Pointadresse';
  s[0204] := '(Bei Дnderung wird die alte AKA abgemeldet!)';
  s[0205] := 'Session';
  s[0206] := 'Passwort';
  s[0207] := 'Areafix';
  s[0208] := 'Filemgr';
  s[0209] := 'Footer unter jeder Mail:';

  s[0210] := 'Fehler beim Lesen von %s aufgetreten' + Chr(13)
             + '(Datei nicht vorhanden oder nicht vollstдndig)!' + Chr(13)
             + 'Deswegen kцnnen die Daten (Adresse und Passwцrter) nicht' + Chr(13)
             + 'geдndert werden.';

  s[0211] := 'Experten-Einstellungen';
  s[0212] := 'kein Proxy';
  s[0213] := 'IP Adresse';

  s[0214] := 'Die alte Pointnummer wird jetzt abgemeldet.';

  s[0215] := ''; // wird nicht mehr benцtigt

  s[0216] := 'Gruppen im Editor (Golded):';
  s[0217] := 'Gruppenname hinzufьgen';
  s[0218] := 'Gruppenname lцschen';
  s[0219] := 'Gruppenname дndern';
  s[0220] := 'Vorhandene Areas:';
  s[0221] := 'selektierte Area gehцrt zu Gruppe:';
  s[0222] := 'Gruppenname';
  s[0223] := 'Neuer Gruppenname:';

  s[0224] := 'kein Logfile gefunden';

  s[0225] := 'Bitte den Dateinamen (oder einen Teil davon)  eingeben, '
             + 'nach dem gesucht werden soll, und Return drьcken (oder '
             + 'auf OK klicken). Es kцnnen bis zu 3 Suchbegriffe '
             + 'eingegeben werden. Wichtig: Keine Wildcards (Sternchen '
             + 'oder Fragezeichen) erlaubt!';
  s[0226] := 'Suchbegriff:';
  s[0227] := 'Es werden Dateien mit diesen Suchbegriffen gesucht:';
  s[0228] := 'Hinweis: Die Suchanfrage wird zunдchst generiert. Die '
             + 'eigentliche Suche wird erst ausgefьhrt, wenn Du das nдchste '
             + 'mal pollst (Mails senden/empfangen).';
  s[0229] := 'Suchanfrage generieren';
  s[0230] := 'markierte Eintrдge lцschen';
  s[0231] := 'Entf'; // Entfernen-Taste
  s[0232] := 'Ergebnisse anzeigen';

  s[0233] := 'Konfiguration';
  s[0234] := 'Pollen';

  s[0235] := ''; // wird nicht mehr benцtigt
  s[0236] := ''; // wird nicht mehr benцtigt
  s[0237] := ''; // wird nicht mehr benцtigt
  s[0238] := ''; // wird nicht mehr benцtigt
  s[0239] := ''; // wird nicht mehr benцtigt

  s[0240] := '  Konfiguration                                     ';
  s[0241] := 'Sonstiges';

  s[0242] := 'Es gibt neue Infos von Deinem Node.' + Chr(13)
             + 'Um sie anzusehen klicke auf "Info''s over Fido, Help ..."' + Chr(13)
             + 'und dann auf "Info over je Nodes".';

  s[0243] := 'Das Fenster mit dem IRC-Chat ist noch offen.' + #13
             + 'Wirklich beenden?';
  s[0244] := 'Chatten mit anderen Fidoleuten..';

  s[0245] := ''; // wird nicht mehr benцtigt

  s[0246] := 'Auf die Request-Datei (%s) konnte nicht zugegriffen werden.';
  s[0247] := 'Leere Passwцrter sind nicht erlaubt. Passwort-Дnderung wird ignoriert.';

  s[0248] := 'Hallo!' + #13#10
             + #13#10
             + 'Willkommen im Fido. Durch die automatische Anmeldung kannst '
             + 'Du sofort Areas anbestellen und Mails lesen. Um Schreibzugriff '
             + 'zu erhalten, musst Du Deinen Node (bei dem Du Dich eben '
             + 'angemeldet hast) kontaktieren. Dazu kannst Du einfach auf diese '
             + 'Mail antworten (Taste "q" und zweimal Return/Enter druecken, '
             + 'Deinen Text schreiben und dann ALT-S und Return/Enter zum '
             + 'Speichern druecken) und die Antwort mittels des Menuepunktes '
             + '"Mails senden und empfangen (Pollen)" im Hauptmenue abschicken.' + #13#10
             + #13#10
             + 'Du kannst auch anrufen, oder eine eMail schreiben:' + #13#10
             + #13#10
             + 'Name: %s' + #13#10
             + 'Telefon: %s' + #13#10
             + 'eMail: %s' + #13#10
             + #13#10
             + #13#10
             + 'Ein Handbuch zu diesem Fido-Paket und weitere Infos findest Du '
             + 'im Hauptmenue unter dem Punkt "Infos zu Fido, Hilfe ...".' + #13#10
             + #13#10
             + 'Solltest Du mal laengere Zeit nicht pollen (Mails holen) koennen, '
             + 'dann informiere bitte Deinen Node, denn sonst wirst Du in der '
             + 'Regel nach 100 Tagen Inaktivitaet automatisch geloescht.' + #13#10
             + #13#10
             + 'Darf ich fragen, woher Du von diesem Fido-Paket erfahren hast?' + #13#10
             + #13#10
             + 'Viel Spass noch..' + #13#10
             + #13#10
             + '(Dies ist eine automatisch erstellte Mail vom Fido-Paket '
             + 'deluxe %s.)' + #13#10;

  s[0249] := 'Du hast den Acrobat Reader zum Anzeigen von PDF Dokumenten nicht '
             + 'installiert. Du kannst diesen hier bekommen:' + #13
             + 'www.adobe.com/products/acrobat/readstep2.html' + #13
             + '(oder falls Du die Fido-Paket CD-Rom hast ist er in '
             + '\sonst\andere-programme\acrobat-reader 5\)' + #13
             + #13
             + 'Alternativ gibt es das Handbuch auch im RTF Format, welches '
             + 'direkt angezeigt werden kann. Du kannst es hier runterladen:' + #13
             + 'www.fido-deluxe.de.vu';

  s[0250] := '(Bitte echter Namen, Fakes' + #13
             + 'werden sofort gelцscht!)';

  s[0251] := 'Wegen rьder Sprache und Beleidigungen gegenьber neuen Usern,' + #13
             + 'Rules, die dem Gesetz oder Fido Policies widersprechen' + #13
             + 'und dem Ausschluss von schwulen Leuten in den Rules, hat' + #13
             + 'diese Area einen eingeschrдnkten Zugriff! Wenn Du wirklich' + #13
             + 'sicher bist, daЯ Du diese Area anbestellen willst, dann solltest' + #13
             + 'Du bereits ein erfahrener Fido User sein, so dass Du wissen' + #13
             + 'solltest und musst, wie man diese Area manuell anbestellt.' + #13
             + 'Die Rules dieser Area wurden Dir gerade als Netmail erstellt,' + #13
             + 'Du kannst sie in Golded lesen.' + #13
             + '- NEC 2457, Michael Haase (2:2457/2)';

  s[0252] := 'FenstergrцЯe (Anzahl Zeilen) von Golded (Editor):';

  s[0253] := 'Momentan ist "anderer Provider" als Internetverbindung' + #13
             + 'eingestellt. Wenn Du eine Netzwerkverbindung (LAN) ins' + #13
             + 'Internet hast, dann gab es bei der Installation keine' + #13
             + 'Auswahl dafьr. Bei Netzwerk (LAN) erfolgt keine Prьfung' + #13
             + 'mehr, ob eine Internetverbindung besteht.' + #13
             + 'Soll auf Netzwerkverbindung (LAN) umgestellt werden?';
  s[0254] := 'lokales Netzwerk (LAN) = keine Onlineprьfung';

  s[0255] := 'Alte Installation gefunden. Sollen diese Daten fьr die' + #13
             + 'Installation benutzt werden (also keine Neuanmeldung)?';

  s[0256] := 'alle anbestellten Echos neu bestellen';
  s[0257] := 'Liste erstellt, beim nдchsten Pollen ("Mails senden' + #13
             + 'und empfangen") wird die Anbestellung gesendet.';
  s[0258] := '(bei Win 95/98/ME gehen nur 25, 43 oder 50 Zeilen)';
  s[0259] := 'Node Name';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := 'Die eingegebene Pointadresse ist ungьltig!' + #13
             + 'Sie muЯ im Format z:nnnn/nnnn.ppppp sein,' + #13
             + 'z.B. "2:2457/280.13" oder "2:2457/280.0".';
  s[0262] := 'Aktualisiere Liste';
  s[0263] := 'Liste aktualisiert.';
  s[0264] := 'Verbindung fehlgeschlagen. Internet-Verbindung aktiv?';
  s[0265] := 'Transaktion fehlgeschlagen.';
  s[0266] := 'Ungьltiger Host.';
  s[0267] := 'Aktualisieren der Liste';
  s[0268] := 'Aktuelle Liste aus Internet laden';
  s[0269] := 'Liste von Festplatte цffnen';
  s[0270] := 'Keine Neuanmeldung, ich kenne die Zugangsdaten';
  s[0271] := 'Eingabe der Zugangsdaten';
  s[0272] := 'Pointnummer:';
  s[0273] := 'Passwort:';
  s[0274] := 'Areafix Passwort:';
  s[0275] := 'File Ticker Passwort:';
  s[0276] := 'PKT Passwort:';
  s[0277] := 'Areafix Name:';
  s[0278] := 'File Ticker Name:';
  s[0279] := 'E-Mail-Adresse des Nodes:';
  s[0280] := 'Telefon-Nummer des Nodes:';
  s[0281] := 'Bitte prьfe die eingegebenen Daten doppelt,' + #13
             + 'bei falschen Daten funktioniert es nicht!';
  s[0282] := 'Node-Nummer (_nicht_ komplette AKA!) (optional):';
  s[0283] := 'Angaben nicht vollstдndig!';
  s[0284] := 'Auswahl-Liste fehlerhaft, Standard-Liste wird verwendet.';
  s[0285] := 'Proxy ggf. auf der vorigen Seite eintragen. Internet-Verbindung muss bereits bestehen!';
  s[0286] := 'Name des Nodes:';
  s[0287] := 'Komplette Node-Adresse (z.B. 2:2432/280):';
  s[0288] := 'DNS/IP (z.B. fido.dyndns.org):';
  s[0289] := '### Anderer Node (Daten selber eingeben)'; // muss mit '#' beginnen! (wegen Sortierung der Liste)
  s[0290] := '    Problem-Prьfung';
  s[0291] := 'Fido-Paket Handbuch';

  s[0292] := 'Fehler beim Lesen der binkd.cfg aufgetreten.' + #13
             + 'Ist diese vorhanden?';
  s[0293] := 'Fehler in der "node"-Zeile in der binkd.cfg entdeckt.' + #13
             + 'DNS-Eintrag fehlt oder ist fehlerhaft.';

  sprache_Hinweis := 'Tip';
  sprache_Fehler := 'Fout';
  sprache_Info := 'Info';
end;

procedure russisch_strings_initialisieren;
begin
  s[0001] := 'Фидо-пакет делюкс';
  s[0002] := 'установка Фидо-пакета делюкс';
  s[0003] := 'Фидо-пакет делюкс, установка';
  s[0004] := 'Добро пожаловать в инсталлятор Фидо-пакета делюкс' + Chr(13)
           + '%s, автор Michael Haase (m.haase@gmx.net)';
  s[0005] := 'Страница с самой свежей версией: http://www.fido-deluxe.de.vu';
  s[0006] := 'Хотите установить Фидо-пакет делюкс прямо сейчас?';
  s[0007] := '&Обновить';
  s[0008] := '&Да';
  s[0009] := '&Прервать установку';

  s[0010] := 'Пожалуйста, убедитесь, что соединение с сетью активно,';
  s[0011] := 'Пожалуйста, убедитесь, что Вы подключились к сети интернет,';
  s[0012] := 'Пожалуйста, убедитесь, что соединение с интернетом готово к использованию,';
  s[0013] := 'Пожалуйста, включите модем / устройство ISDN,';
  s[0014] := Chr(13) + 'проводится попытка соединения с одним из отобранных' + Chr(13)
             + 'Фидо-сисопов.';

  s[0015] := 'Соединение с сетью интернет не было найдено.';

  s[0016] := 'Пароль для %s:';
  s[0017] := 'интернет-cоединение ';

  s[0018] := 'При попытке соединения, соединение было' + Chr(13)
             + 'разорвано до приёма/отсылки почты.' + Chr(13)
             + 'Ошибка при попытке: прозвон(poll)' + Chr(13)
             + 'сообщение: %s';

  s[0019] := 'Соединение установлено.';

  s[0020] := 'Статус:';
  s[0021] := 'Идёт регистрация в Фидо..';

  s[0022] := 'Установка благополучно завершена.' + Chr(13)
             + 'В меню Старт и на Рабочем Столе был' + Chr(13)
             + 'создан ярлык (Fido-menu).';

  s[0023] := 'Возникла ошибка.' + Chr(13)
             + 'Номер ошибки: %s' + Chr(13)
             + 'Действие: прозвон(poll)';

  s[0024] := 'Соединение разорвано. Вероятно,' + Chr(13)
             + 'это случайный сбой.' + Chr(13)
             + 'Обождите и попробуйте снова.' + Chr(13)
             + 'для дальнейшей информации можете посмотреть лог-файл' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';

  s[0025] := 'Приняты неверные данные(CDN). Код ошибки: %s';
  sprache_Fehlercode := 'Код ошибки'; // muъ mit ^^^^^^^^^^ Эbereinstimmen!

  s[0026] := 'Данные регистрации благополучно отправлены.' + #13
             + 'Сейчас создаётся первая фидошная эха, при этом '
             + 'проводится проверка целостности установки.' + #13
             + #13
             + 'По окончанию установки документацию Вы найдёте в главном меню, '
             + 'пункт "Информация о Фидо, помощь, ..." Дальнейшая информация '
             + 'находится там же.' + #13
             + #13
             + 'Для начала Вы, наверняка, подпишетесь на пару '
             + 'эх (Echo/Area), это можно осуществить в меню "Подписаться, '
             + 'отписаться от эх". Если Вас интересует Linux, то '
             + 'имеет смысл выписать RU.LINUX; в RU.HUMOR.FILTERED всегда '
             + 'есть над чем посмеяться. Начинающих встретят в RU.CHAINIK.';

  s[0027] := 'Установка Фидо-пакета делюкс';
  s[0028] := 'Имя';
  s[0029] := 'Укажите имя и фамилию';
  s[0030] := 'Город';
  s[0031] := 'Телефон';
  s[0032] := 'Пожалуйста, введите код города и номера телефона, отделённые знаком минус';
  s[0033] := ''; // wird nicht mehr benЖtigt
  s[0034] := ''; // wird nicht mehr benЖtigt
  s[0035] := ''; // wird nicht mehr benЖtigt
  s[0036] := '(Интернет-)подключение по удалённому соединению с:';
  s[0037] := ''; // wird nicht mehr benЖtigt
  s[0038] := ''; // wird nicht mehr benЖtigt
  s[0039] := 'Операционная система';
  s[0040] := 'Распознанная ОС: ';
  s[0041] := 'Выберите каталог для &установки';
  s[0042] := 'Каталог установки: %s' + ':\FIDO';
  s[0043] := 'В качестве пойнта связаться со следующей системой:';
  s[0044] := 'Телефон      Город                                            Имя сисопа';
  s[0045] := '&Запуск установки';
  s[0046] := '&Прервать (закончить)';

  s[0047] := 'дозвониться(poll)';
  s[0048] := 'Попытка установки соединения...';
  s[0049] := 'Статус соединения:';
  s[0050] := 'Прервать';

  s[0051] := 'Указанный файл CDN не был найден:' + Chr(13)
             + '%s';
  s[0052] := 'Пожалуйста, укажите полный путь к файлу CDN!' + chr(13)
             + '(например: c:\primer\primer.cdn)';

  s[0053] := 'Хотя удалённый доступ не установлен, соединение с сетью' + Chr(13)
             + 'интернет было обнаружено. Вы можете продолжить установку,' + Chr(13)
             + 'однако возможно, что Вам придётся пользоваться готовым' + Chr(13)
             + 'соединением к сети интернет.';

  s[0054] := 'Удалённый доступ не установлен, однако он необходим.' + Chr(13)
             + 'Выберите Мой компьютер/Панель Управления, затем' + Chr(13)
             + 'установка программ/установка Windows и добавьте удалённый доступ.' + Chr(13)
             + 'По окончанию запустите программу установки Фидо-пакета делюкс.';
  s[0055] := 'Во время установки возникла ошибка';

  s[0056] := 'Соединение с сетью интернет';

  s[0057] := 'В удалённом доступе не установлен модем,' + Chr(13)
             + 'либо ISDN устройство.' + Chr(13)
             + 'Исправьте это и перезапустите' + Chr(13)
             + 'программу установки Фидо-пакета делюкс.';

  s[0058] := 'При попытке добавить новое соединение в удалённом доступе' + Chr(13)
             + 'возникла неизвестная ошибка.' + Chr(13)
             + 'Установка будет прекращена';

  s[0059] := 'Распознанная ОС: %s';

  s[0060] := 'Ошибка при попытке открыть файл "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + 'Номер ошибки: %s';

  s[0061] := 'Международный телефонный код не был указан.';
  s[0062] := 'Ошибка при вводе';
  s[0063] := 'Не было указано имя.';
  s[0064] := 'Имя, либо фамилия указаны не полностью.';
  s[0065] := 'Не указан город.';
  s[0066] := 'Указан несуществующий город.';
  s[0067] := 'Номер телефона не был указан.';
  s[0068] := 'Код города, пожалуйста отделяйте знаком "-",' + Chr(13)
             + 'например: 03452-249044';
  s[0069] := 'Указан неверный номер телефона.';
  s[0070] := 'В поле номер телефона допускаются только цифры.' + Chr(13)
             + 'Вы можете оставить его пустым.';

  s[0071] := 'На указанном Вами' + Chr(13)
             + 'диске (%s' + ':) недостаточно места.' + Chr(13)
             + 'Для установки требуются минимум 20 мегабайт.';

  s[0072] := 'Fido-menu';
  s[0073] := 'Отказаться от членства в Фидо';
  s[0074] := 'Удалить Фидо-пакет делюкс.';

  s[0075] := 'Причина не известна, вероятно, случайный сбой.' + Chr(13)
             + 'Попытайтесь ещё раз.' + Chr(13)
             + 'Для дальнейшей информации можно посмотреть лог-файл' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';
  s[0076] := 'Набор пойнтов в выбранной Фидо-системе приостановлен'
             + Chr(13) + 'по причине:' + Chr(13);
  s[0077] := 'Выберите другую Фидо-систему,'
             + Chr(13) + 'либо выберите другую Фидо-систему.';

  s[0078] := 'Удалять уже установленные файлы инсталляции пакета?';
  s[0079] := 'Установка прервана';
  s[0080] := 'Все уже установленные файлы удалены.';

  s[0081] := 'В имени пути не допускаются знаки пробела(" ").'
             + Chr(13) + 'Каталог: %s' + Chr(13)
             + Chr(13) + 'Укажите, пожалуйста, другой каталог.';
  s[0082] := 'Выбранный для установки каталог уже существует.'
             + Chr(13) + 'Каталог: %s' + Chr(13)
             + '*** Все файлы и подкаталоги будут удалены! ***'
             + Chr(13) + Chr(13)
             + 'Вы уверены?';
  s[0083] := 'Предупреждение';

  s[0084] := 'Каталог для установки: %s';

  s[0085] := 'другой интернет-провайдер';

  s[0086] := 'Предыдущая установка пакета не обнаружена.'
             + Chr(13) + 'Каталог: %s'
             + Chr(13) + 'Искомый файл: point.cdn'
             + Chr(13) + Chr(13)
             + 'Пожалуйста, выберите другой каталог.';

  s[0087] := 'Обновление благополучно завершено.';

  s[0088] := 'Фидо-пакет делюкс (10 Мб) устанавливается.' + Chr(13)
             + 'Пожалуйста, подождите.';

  s[0089] := 'Действительно прервать установку?';
  s[0090] := 'Прервать';
  s[0091] := 'Удалить уже установленные файлы?';
  s[0092] := 'Все уже установленные файлы удалены.';

  s[0093] := 'сетевая карта не допускает удалённый доступ';
  s[0094] := 'Интернет-соединение';
  s[0095] := 'При сборе информации о соединениях ву далённом доступе' + Chr(13)
             + 'возникла неожиданная ошибка.' + Chr(13);
  s[0096] := 'Номер ошибки: %s' + Chr(13)
             + 'Пожалуйста, проинформируйте автора:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := 'При выделении памяти возникла неизвестная ошибка.' + Chr(13);
  s[0098] := 'найти модем или ISDN capi не удалось';

  s[0099] := 'isdn'; // nicht Дndern!
  s[0100] := 'modem'; // nicht Дndern!
  s[0101] := 'Kommunikationskabel'; // nicht Дndern!

  s[0102] := 'Удалённый доступ не установлен. Будет произведён поиск активного соединения с сетью интернет..';
  s[0103] := 'Соединение с сетью интернет активно, дальнейший поиск не проводить';

  s[0104] := 'Фидо-пакет';

  s[0105] := 'В этот раз CDN файл не найден.' + Chr(13)
             + 'Пожалуйста, не копируйте его в каталог установки!';

  s[0106] := 'Фидо-пакет удалён.';
  s[0107] := 'Удалить';
  s[0108] := 'На самом деле удалить Фидо-пакет делюкс?';

  s[0109] := '&Отобразить меню';
  s[0110] := '&Закончить';

  s[0111] := ' Главное меню (Фидо-пакет делюкс)';
  s[0112] := 'Фидо-пакет делюкс %s' + Chr(13)
             + '         от Michael Haase';
  s[0113] := '  Почту принять/отправить (дозвон)   ';
  s[0114] := ' Сообщения прочесть/написать (редактор) ';
  s[0115] := '   Подписаться/отписаться от эх       ';
  s[0116] := '  Поиск файла в списке файл-сервера         ';
  s[0117] := '  Лог-файлы посмотреть/урезать              ';
  s[0118] := '  Информация о Фидо, Помощь ...             ';
  s[0119] := '  Закончить';
  s[0120] := '  Автора!';

  s[0121] := 'Интернет-соединение недоступно.';
  s[0122] := 'Пароль:';

  s[0123] := 'Есть новая (личная) почта.' + Chr(13)
             + 'Писем: %s' + Chr(13)
             + 'Сообщений: %s';

  s[0124] := ''; // wird nicht mehr benЖtigt

  s[0125] := 'Возникла ошибка.' + Chr(13)
             + 'Номер ошибки: %s' + Chr(13)
             + 'Операция: редактор';

  s[0126] := 'Вы действительно хотите покинуть Фидо' + Chr(13)
             + 'и отписаться ото всех эх?';
  s[0127] := 'Отписаться?';

  s[0128] := 'Количество выписанных эх: %s';

  s[0129] := 'Искомое слово не найдено.';
  s[0130] := 'Поиск';
  s[0131] := 'Искомое слово более найдено не было.';

  s[0132] := 'Действительно прервать (все предпринятые изменения пропадут)?';

  s[0133] := 'Количество доступных фидошных эх: %s';

  s[0134] := ' Конфигурация эх';
  s[0135] := 'Для того, чтобы подписать или отписать эху, достаточно двойного нажатия мыши на ней.';
  s[0136] := 'Выбор эх:';
  s[0137] := '   основные';
  s[0138] := '    американские';
  s[0139] := '   локальные';
  s[0140] := '    региональные';
  s[0141] := 'Искомое слово';
  s[0142] := 'поиск';
  s[0143] := 'продолжить поиск';
  s[0144] := 'OK';

  s[0145] := 'Количество доступных американских фидошных эх: %s';
  s[0146] := 'Количество доступных эх на BBS: %s';
  s[0147] := 'Количество доступных (региональных) эх: %s';

  s[0148] := 'Действительно прервать (запрос на поиск не будет создан)?';
  s[0149] := 'Запрос на поиск был создан. При следуёщем' + Chr(13)
             + 'дозвоне (приёме и отправке почты), поиск' + Chr(13)
             + 'будет обработан и чуть погодя результат' + Chr(13)
             + 'можно будет получить (ещё раз прозвонившись).';

  s[0150] := 'Лог-файл менее 300 KB, урезать его' + Chr(13)
             + 'не требуется.';
  s[0151] := 'Лог-файл отсутствует.';
  s[0152] := 'Размер лог-файла: %s КБ';
  s[0153] := 'Лог-файл';
  s[0154] := 'Урезать лог-файл';
  s[0155] := 'Назад';

  s[0156] := 'Пожалуйста, вставьте диск с Фидо-пакет делюкс и нажмите ещё раз на "Дополнительно".';
  s[0157] := 'Изображения';

  s[0158] := ' Фидо-информация';
  s[0159] := '    Информация о Фидо';
  s[0160] := '     Данные Вашей ноды';
  s[0161] := '     Документация на GoldEd';
  s[0162] := '    Дополнительно';
  s[0163] := ''; // wird nicht mehr benЖtigt
  s[0164] := 'назад';
  s[0165] := 'вперёд';
  s[0166] := 'закрыть';

  s[0167] := 'Автодозвон: Каждые %s минут при свернутом окне автоматически дозваниваться';

  s[0168] := 'Показания автодозвона; указываются в минутах';
  s[0169] := 'Интернет-провайдер:';

  s[0170] := 'Не все все функции RAS (удалённый доступ) были обнаружены.' + Chr(13)
             + 'Всё-же попробуем продолжить.' + Chr(13)
             + 'При появлении ошибок, сообщите автору:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';

  s[0171] := 'Автодозвон';
  s[0172] := 'Цвета в редакторе';
  s[0173] := 'Группы';
  s[0174] := 'Макросы адресата';
  s[0175] := 'Данные';
  s[0176] := 'История';
  s[0177] := 'Обновления';

  s[0178] := 'Текст';
  s[0179] := 'Цитата';
  s[0180] := 'Фон';
  s[0181] := 'Чёрный';
  s[0182] := 'Синий';
  s[0183] := 'Зелёный';
  s[0184] := 'Циан';
  s[0185] := 'Красный';
  s[0186] := 'Магента';
  s[0187] := 'Коричневый';
  s[0188] := 'Тёмно-серый';
  s[0189] := 'Светло-серый';
  s[0190] := 'Светло-синий';
  s[0191] := 'Светло-зелёный';
  s[0192] := 'Светлый циан';
  s[0193] := 'Светло-красный';
  s[0194] := 'Светлая магента';
  s[0195] := 'Жёлтый';
  s[0196] := 'Белый';

  s[0197] := 'Самая свежая версия программы и её обновления '
             + 'находятся на домашней странице.' + Chr(13)
             + 'На сей момент это (URLs):';

  s[0198] := 'жирный';
  s[0199] := 'курсив';
  s[0200] := 'подчёркивание';

  s[0201] := 'В GoldEd (редактор) при написании письма можно '
             + 'использовать макросы адресата для наиболее частых получателей. '
             + 'В поле "для:" просто ввести сокращение, например,  mh '
             + 'для Michael Haase, 2:2432/280.';

  s[0202] := 'Внимание: Смена номера пойнта и пароля должны производиться '
             + 'только в случае, если Вы точно знаете, что делаете. '
             + 'Иначе может случиться, что Вы не сможете ни отправить, '
             + 'ни забрать почту!';
  s[0203] := 'Номер address';
  s[0204] := '(При изменении старый AKA будет снят с учёта!)';
  s[0205] := 'Сессия';
  s[0206] := 'Пароль';
  s[0207] := 'AreaFix';
  s[0208] := 'Filemgr';
  s[0209] := 'Строка под каждым письмом:';

  s[0210] := 'При чтении %s возникла ошибка' + Chr(13)
             + '(файл отсутствует, или повреждён)!' + Chr(13)
             + 'В связи с этим данные (адреса и пароли)' + Chr(13)
             + 'не могут быть изменены.';

  s[0211] := 'Установки не для начинающих';
  s[0212] := 'без прокси-сервера';
  s[0213] := 'IP адрес';

  s[0214] := 'Старый номер пойнта будет снят с учёта.';

  s[0215] := ''; // wird nicht mehr benЖtigt

  s[0216] := 'Группы в редакторе (GoldEd):';
  s[0217] := 'Добавить имя группы';
  s[0218] := 'Удалить имя группы';
  s[0219] := 'Изменить имя группы';
  s[0220] := 'Доступные эхи:';
  s[0221] := 'Выбранная эха относится к группе:';
  s[0222] := 'Имя группы';
  s[0223] := 'Новое имя группы:';

  s[0224] := 'Лог-файл не найден';

  s[0225] := 'Пожалуйста, укажите имя искомого файла (или его часть), '
             + 'затем нажмите Enter (можно '
             + 'нажать на OK). Допускаются до трёх искомых слов.'
             + 'Важно: метасимволы (звезда "*" '
             + 'и вопросительный знак) не допускаются!';
  s[0226] := 'Искомое слово:';
  s[0227] := 'Поиск файлов, содержащих следующие слова:';
  s[0228] := 'Замечание: сейчас будет построен запрос на поиск. '
             + 'действительно поиск будет осуществлён лишь при '
             + 'последуёщем дозвоне (отправке/приёме почты).';
  s[0229] := 'Создать запрос на поиск';
  s[0230] := 'Стереть отобранные элементы';
  s[0231] := 'Del'; // Entfernen-Taste
  s[0232] := 'Показать результат';

  s[0233] := 'Конфигурация  ';
  s[0234] := 'Дозвон';

  s[0235] := ''; // wird nicht mehr benЖtigt
  s[0236] := ''; // wird nicht mehr benЖtigt
  s[0237] := ''; // wird nicht mehr benЖtigt
  s[0238] := ''; // wird nicht mehr benЖtigt
  s[0239] := ''; // wird nicht mehr benЖtigt

  s[0240] := '  Конфигурация                                    ';
  s[0241] := 'Прочее';

  s[0242] := 'Есть новая информация от Вашей ноды.' + Chr(13)
             + 'Чтобы её увидеть, нажми "Infos zu Fido, Hilfe ..."' + Chr(13)
             + ' и выберите "Информация о Вашей ноде".';

  s[0243] := 'Окно с IRC-чатом еще открыто.' + #13#10
             + 'Действительно закрыть?';
  s[0244] := 'Побеседовать в чате с другими фидошниками..';

  s[0245] := ''; // wird nicht mehr benЖtigt

  s[0246] := 'К файлу запроса (%s) не было доступа.';
  s[0247] := 'Пустые пароли недопустимы. Изменение пароля проигнорировано.';

  s[0248] := 'Здравствуйте!' + #13#10
             + #13#10
             + 'Добро пожаловать в Фидо. Благодаря автоматической регистрации '
             + 'Вы можете немедленно выписать эхи и читать почту. Для права на отправку '
             + 'сообщений Вам необходимо связаться с Вашей нодой ( тем человеком, '
             + 'у которого Вы только что зарегистрировались). Можете просто ответить '
             + 'на это письмо (нажмите клавишу "q" и два раза Enter, затем наберите текст '
             + 'письма, по окончанию нажмите ALT-S и ещё раз Enter для '
             + 'сохранения). Далее, в главном меню выберите пункт'
             + '"Почту принять/отправить (дозвон)". Письмо будет оптравлено.' + #13#10
             + #13#10
             + 'Вашей ноде можно позвонить голосом или отправить e-mail:' + #13#10
             + #13#10
             + 'Имя: %s' + #13#10
             + 'Телефон: %s' + #13#10
             + 'e-mail: %s' + #13#10
             + #13#10
             + #13#10
             + 'Документация к этому Фидо-пакету, а так же дополнительная информация находится '
             + 'в главном меню, пункт "Информация о Фидо, помощь, ...".' + #13#10
             + #13#10
             + 'Если Вы не сможете в течении долгого срока забирать почту (отпуск), '
             + 'пожалуйста, сообщите об этом Вашей ноде, иначе Вас автоматически '
             + 'удалят из пойнтов по истечении примерно 100 дней бездействия.' + #13#10
             + #13#10
             + 'Могу я узнать, откуда Вам стало известно об этом Фидо-пакете?' + #13#10
             + #13#10
             + 'Приятного времяпрепровождения..' + #13#10
             + #13#10
             + '(Это письмо составлено автоматически Фидо-пакетом '
             + 'делюкс %s.)' + #13#10;

  s[0249] := 'Вами не был установлен Acrobat Reader для чтения PDF документов. '
             + 'Его можно скачать по адресу:' + #13
             + 'www.adobe.com/products/acrobat/readstep2.html' + #13
             + '(если же у Вас есть диск с Фидо-пакетом, то он находится в каталоге'
             + '\sonst\andere-programme\acrobat-reader 5\)' + #13
             + #13
             + 'Документация доступна так же и в формате RTF. Её можно сразу же '
             + 'раскрыть. Расположена она по этому адресу:' + #13
             + 'www.fido-deluxe.de.vu';

  s[0250] := '(Realname, please, Fakes' + #13
             + 'become deleted immediately!)';

  s[0251] := 'Because of rude language and offenses towards new users,' + #13
             + 'rules contradicting against laws or Fido policies,' + #13
             + 'and the exclusion of gay people in the rules, this' + #13
             + 'area has restricted access! If you are really sure you' + #13
             + 'want to subscribe to this area, you should be an advanced' + #13
             + 'Fido user, so you should and have to know how to subscribe' + #13
             + 'manually for this area.' + #13
             + 'The rules just were created as a netmail, you can read them' + #13
             + 'within Golded.' + #13
             + '- NEC 2457, Michael Haase (2:2457/2)';

  s[0252] := 'Размер окна (число строк) GoldEd (редактора):';

  s[0253] := 'At the moment "other Provider" is configured for internet' + #13
             + 'connection. If you have a network (LAN) connection into' + #13
             + 'the internet, then no appropiate selection were available' + #13
             + 'during installation. With network (LAN) it will no longer' + #13
             + 'checked if an internet connection is available.' + #13
             + 'Do you want to change to network (LAN) connection?';
  s[0254] := 'local network (LAN) = no online check';

  s[0255] := 'Old installation found. Shall these data be used for' + #13
             + 'installation (so no new registration)?';

  s[0256] := 'subscribe again all subscribed areas';
  s[0257] := 'List created. With the next Poll ("Send and receive mails")' + #13
             + 'the subscription will be sent.';
  s[0258] := '(with Win 95/98/ME only 25, 43 or 50 lines are possible)';
  s[0259] := 'Node Name';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := 'The point number you entered is not valid!' + #13
             + 'It must be in the format z:nnnn/nnnn.ppppp,' + #13
             + 'e.g. "2:2457/280.13" or "2:2457/280.0".';
  s[0262] := 'Update List';
  s[0263] := 'List updated.';
  s[0264] := 'Connection failure. Internet connection active?';
  s[0265] := 'Transaction failure.';
  s[0266] := 'Invalid Host.';
  s[0267] := 'Update List';
  s[0268] := 'Update list from internet';
  s[0269] := 'Open list from hard disk';
  s[0270] := 'No new registration, I know my access data';
  s[0271] := 'Input of the access data';
  s[0272] := 'Point number:';
  s[0273] := 'Password:';
  s[0274] := 'Areafix password:';
  s[0275] := 'File Ticker password:';
  s[0276] := 'PKT password:';
  s[0277] := 'Areafix name:';
  s[0278] := 'File Ticker name:';
  s[0279] := 'E-Mail address of the node:';
  s[0280] := 'Telephone number of the node:';
  s[0281] := 'Please check the given data twice,' + #13
             + 'with wrong data it does not work!';
  s[0282] := 'Node number (_not_ complete AKA!) (optional):';
  s[0283] := 'Input not complete!';
  s[0284] := 'Selection list faulty, standard list will be used.';
  s[0285] := 'Enter proxy on previous page if necessary. Internet connection must already be active!';
  s[0286] := 'Name of the node:';
  s[0287] := 'Complete node address (e.g. 2:2432/280):';
  s[0288] := 'DNS/IP (e.g. fido.dyndns.org):';
  s[0289] := '### Other node (enter data yourself)'; // must begin with '#'! (because of sorting of the list)
  s[0290] := '    Problem-Check';
  s[0291] := 'Fido-Package manual';

  s[0292] := 'Error occured during reading of binkd.cfg.' + #13
             + 'Does it exist?';
  s[0293] := 'Error detected in the "node"-line in binkd.cfg.' + #13
             + 'DNS entry is missing or faulty.';

  sprache_Hinweis := 'Указание';
  sprache_Fehler := 'Ошибка';
  sprache_Info := 'Информация';
end;

procedure spanisch_strings_initialisieren;
begin
  s[0001] := 'Fido-Package deluxe';
  s[0002] := 'Instalaciуn de Fido-Package deluxe';
  s[0003] := 'Fido-Package deluxe - Instalaciуn';
  s[0004] := 'Bienvenido al programa de instalaciуn de Fido-Package deluxe' + Chr(13)
             + '%s, por Michael Haase (m.haase@gmx.net)';
  s[0005] := 'La pбgina con la ъltima versiуn es: http://www.fido-deluxe.de.vu';
  s[0006] := 'їQuieres instalar Fido-Package deluxe, ahora?';
  s[0007] := '&Actualizar';
  s[0008] := '&Si';
  s[0009] := '&Salir';

  s[0010] := 'Now, please make sure that the network connection is online, it';
  s[0011] := 'Now, please make sure that the internet connection is online, it';
  s[0012] := 'Now, please make sure that the internet connection is ready to use, it';
  s[0013] := 'Now, please turn on the modem / ISDN device, it';
  s[0014] := Chr(13) + 'se intentarб establecer conexiуn con el sysop de FidoNet' + Chr(13)
             + 'seleccionado.';

  s[0015] := 'No se ha reconocido ninguna conexiуn a internet.';

  s[0016] := 'Clave para %s:';
  s[0017] := 'Internet connection';

  s[0018] := 'Ocurriу un error estableciendo la conexiуn, la' + Chr(13)
             + 'conexiуn se cortу antes de enviar y recibir el correo.' + Chr(13)
             + 'Error en acciуn: Llamada' + Chr(13)
             + 'Mensaje: %s';

  s[0019] := 'Conexiуn establecida.';

  s[0020] := 'Estado:';
  s[0021] := 'El registro en Fido se estб realizando..';

  s[0022] := 'Instalaciуn terminada satisfactoriamente.' + Chr(13)
             + 'Un enlace ha sido creado en el menu inicio y' + Chr(13)
             + 'en el escritorio (Fido-Menu).';

  s[0023] := 'Ha habido un error.' + Chr(13)
             + 'Cуdigo de error: %s' + Chr(13)
             + 'Acciуn: Llamada';

  s[0024] := 'Conexiуn fallida. Quizбs se puede deber a' + Chr(13)
             + 'un error temporal. Intйntalo mбs tarde.' + Chr(13)
             + 'Para mбs informaciуn deberбs mirar' + Chr(13)
             + 'el fichero log (%s' + '\binkley\binkd.log).';

  s[0025] := 'Faulty data (CDN) received. Error code: %s';
  sprache_Fehlercode := 'Error code'; //  ^^^^^^^^^^ must be this!

  s[0026] := 'Los datos de registro han sido enviados conй xito.' + #13
             + 'Now, the first Fido area is connected, finally, and therefore '
             + 'tested if everything has been installed completely.' + #13
             + #13
             + 'After installation is completed you will find a manual for '
             + 'this Fido-Package and further interesting information under the '
             + ' menu point "Info about Fido, Help ..." in the main menu.' + #13
             + #13
             + 'Your first step probably will be that you subscribe to some '
             + 'areas (also called echo). This is done in the menu "Connect or '
             + 'Disconnect an echo". If you are interested in Star Trek Voyager, '
             + 'for example, you might like to subscribe to TREK_VOYAGER. Or '
             + 'the Simpsons (SIMPSONS)? PC hardware (HARDWARE)? There are '
             + 'quite a lot interesting areas, so have a look into the list '
             + 'and subscribe to the one or the other that you like.';

  s[0027] := 'Instalaciуn de Fido-Package deluxe';
  s[0028] := 'Nombre';
  s[0029] := 'Introduce tu nombre y apellidos';
  s[0030] := 'Localidad';
  s[0031] := 'Telйfono';
  s[0032] := 'Introduce prefijo y nъmero de telйfono separado por un guiуn';
  s[0033] := ''; // wird nicht mehr benцtigt
  s[0034] := ''; // wird nicht mehr benцtigt
  s[0035] := ''; // wird nicht mehr benцtigt
  s[0036] := '(Internet-) Connect via Dial-Up Network with:';
  s[0037] := ''; // wird nicht mehr benцtigt
  s[0038] := ''; // wird nicht mehr benцtigt
  s[0039] := 'Sistema operativo';
  s[0040] := 'Reconocido el sistema operativo: ';
  s[0041] := 'Escoge el directorio de instalaciуn';
  s[0042] := 'Directorio de instalaciуn: %s' + ':\FIDO';
  s[0043] := 'Registrarse como miembro de Fido (Punto) en el siguiente nodo:';
  s[0044] := 'Telf.            Localidad                                      Sysop';
  s[0045] := 'Empezar &instalaciуn';
  s[0046] := '&Abortar (Salir)';
  s[0047] := 'Llamada';
  s[0048] := 'La conexiуn se estб The connection is establishing...';
  s[0049] := 'Estado de la conexiуn:';
  s[0050] := 'Abortar';

  s[0051] := 'El fichero CDN no ha sido encontrado:' + Chr(13)
             + '%s';
  s[0052] := 'ЎIntroduce la ruta completa del fichero CDN!' + chr(13)
             + '(ej.: c:\ejemplo\ejemplo.cdn)';

  s[0053] := 'The Dial-Up Network is not installed, but an internet connection.' + Chr(13)
             + 'is detected. So, you may proceed installation, but you will' + Chr(13)
             + 'only be able to use internet connections.';

  s[0054] := 'The Dial-Up Network is not installed, but is required.' + Chr(13)
             + 'Please install it by selecting Software / Windows-Setup' + Chr(13)
             + 'found in My Computer / Control Panel, and start again' + Chr(13)
             + 'the installation of the Fido-Package deluxe, then.';
  s[0055] := 'Error durante la instalaciуn';

  s[0056] := 'internet connection';

  s[0057] := 'There is no modem or ISDN device installed in the Dial-Up Network.' + Chr(13)
             + 'Please do it and then start again the installation of' + Chr(13)
             + 'the Fido-Package deluxe.';

  s[0058] := 'It occurred an unknown error by creating a new' + Chr(13)
             + 'connection in the Dial-Up Network.' + Chr(13)
             + 'Installation is stopped.';

  s[0059] := 'Sistema operativo reconocido: %s';

  s[0060] := 'Error abriendo el fichero "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + 'Cуdigo de error: %s';

  s[0061] := 'No se ha introducido el prefijo internacional.';
  s[0062] := 'Error in input';
  s[0063] := 'No se ha introduce el nombre.';
  s[0064] := 'El nombre dado no estб completo.';
  s[0065] := 'No se ha introducido la localidad.';
  s[0066] := 'La localidad dada no es vбlida.';
  s[0067] := 'No se ha introducido el nъmero de telйfono.';
  s[0068] := 'Please separate area code from phone number with "-",' + Chr(13)
             + 'for example: 02732-12345';
  s[0069] := 'El nъmero de telйfono dado no es vбlido.';
  s[0070] := 'For the Call-By-Call number only figures are allowed.' + Chr(13)
             + '(Or leave the field empty.)';

  s[0071] := 'No hay espacio libre suficiente en el' + Chr(13)
             + 'disco duro (%s' + ':).' + Chr(13)
             + 'Se requieren al menos 20 MB.';

  s[0072] := 'Fido-Menu';
  s[0073] := 'Cancelar registro en FidoNet';
  s[0074] := 'Desinstalar Fido-Package deluxe';

  s[0075] := 'No reason given, probably a temporary error.' + Chr(13)
             + 'Perhaps try again later.' + Chr(13)
             + 'For further information you might want to have a look into' + Chr(13)
             + 'the log file (%s' + '\binkley\binkd.log).';
  s[0076] := 'El nodo seleccionado no acepta nuevos puntos '
             + Chr(13) + 'por el momento. La razуn dada:' + Chr(13);
  s[0077] := 'Por favor, detйn la instalaciуn de  Fido-Package deluxe, o'
             + Chr(13) + 'escoje otro nodo de Fido.';

  s[0078] := 'їDeberбn ser borrados los ficheros instalados?';
  s[0079] := 'Abortar la instalaciуn';
  s[0080] := 'Todos los ficheros instalados serбn borrados.';

  s[0081] := 'No debe haber ningъn espacio (" ") en la ruta.'
             + Chr(13) + 'Directorio: %s' + Chr(13)
             + Chr(13) + 'Por favor, escoge otro directorio.';
  s[0082] := 'El directorio seleccionado ya existe.'
             + Chr(13) + 'Directorio: %s' + Chr(13)
             + '*** ЎTodos los ficheros y subdirectorios serбn borrados! ***'
             + Chr(13) + Chr(13)
             + 'їSeguro?';
  s[0083] := 'Cuidado';

  s[0084] := 'Directorio de instalaciуn: %s';

  s[0085] := 'other internet provider';

  s[0086] := 'No se encontrу instalaciуn atigua.'
             + Chr(13) + 'Directorio: %s'
             + Chr(13) + 'Fichero buscado: point.cdn' + Chr(13)
             + Chr(13) + Chr(13)
             + 'Por favor, escoge otro directorio.';

  s[0087] := 'Actualizaciуn finalizada correctamente.';

  s[0088] := 'Fido-Package deluxe (10 MB) va a ser instalado.' + Chr(13)
             + 'Por favor, espera.';

  s[0089] := 'їRealmente quieres abortar la instalaciуn?';
  s[0090] := 'Abortar';
  s[0091] := 'їDeben ser borrados los ficheros instalados?';
  s[0092] := 'Todos los ficheros instalados han sido borrados.';

  s[0093] := 'network card = no dial-up connection';
  s[0094] := 'internet connection';
  s[0095] := 'An unexpected error occurred by gathering the connections' + Chr(13)
             + 'in the Dial-Up Network.' + Chr(13);
  s[0096] := 'Cуdigo de error: %s' + Chr(13)
             + 'Por favor, infуrma de ello al autor:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := 'An unexpected error occurred by allocating memory.' + Chr(13);
  s[0098] := 'no se encontrу modem o RDSI';

  s[0099] := 'rdsi'; // do not change!
  s[0100] := 'modem'; // do not change!
  s[0101] := 'Kommunikationskabel'; // do not change until you know what you do!

  s[0102] := 'The Dial-Up Network is not installed. Now, an active internet connection is searched..';
  s[0103] := 'Internet connection is active, don¦t search anymore';

  s[0104] := 'Fido-Package';

  s[0105] := 'CDN file no longer found.' + Chr(13)
             + 'Please do not copy it in the installation directory!';

  s[0106] := 'Fido-Package deluxe est desinstalado ahora.';
  s[0107] := 'Desinstalar';
  s[0108] := 'їRealmente quieres desinstalar Fido-Package deluxe?';

  s[0109] := '&Mostrar Menъ Fido';
  s[0110] := 'S&alir';

  s[0111] := ' Menъ principal (Fido-Package deluxe)';
  s[0112] := 'Fido-Package deluxe %s' + Chr(13)
             + '          por Michael Haase';
  s[0113] := '  Enviar y recibir correo (Llamar)      ';
  s[0114] := '  Leer y escribir correo (Editor)          ';
  s[0115] := '   Dar areas de alta o baja               ';
  s[0116] := '  Buscar ficheros en la lista de ficheros del servidor';
  s[0117] := '  Ver y cortar los ficheros de "log"                      ';
  s[0118] := '    Informaciуn sobre Fido, ayuda, ...  ';
  s[0119] := '  Salir    ';
  s[0120] := '  Reportar errores (Bug)';

  s[0121] := 'La conexiуn a internet no estб disponible.';
  s[0122] := 'Clave:';

  s[0123] := 'Tienes nuevo correo (personal).' + Chr(13)
             + 'Netmails: %s' + Chr(13)
             + 'Echomail: %s';

  s[0124] := ''; // wird nicht mehr benцtigt

  s[0125] := 'Ha ocurrido un error.' + Chr(13)
             + 'Cуdigo de error: %s' + Chr(13)
             + 'Acciуn: Editor';

  s[0126] := 'їQuieres abortar tu registro en FidoNet y' + Chr(13)
             + 'cancelar tu suscripciуn para todas las areas?';
  s[0127] := 'їCancelar tu registro en FidoNet?';

  s[0128] := 'Nъmero de areas que tienes conectadas: %s';

  s[0129] := 'Palabra clave de bъsqueda encontrada.';
  s[0130] := 'Buscar';
  s[0131] := 'No further hits for the given search keyword.';

  s[0132] := 'Really abort (all changes become lost)?';

  s[0133] := 'Nъmero de areas disponibles: %s';

  s[0134] := ' Administraciуn de areas';
  s[0135] := 'Para dar de baja un area pica dos veces sobre ella.';
  s[0136] := 'Selecciуn de areas:';
  s[0137] := '   principal';
  s[0138] := '    Norte-Amйrica';
  s[0139] := '   local';
  s[0140] := '    regional';
  s[0141] := 'Buscar por palabra';
  s[0142] := 'buscar';
  s[0143] := 'buscar siguiente';
  s[0144] := 'Aceptar';

  s[0145] := 'Nъmero de areas de Norte-Amйrica disponibles: %s';
  s[0146] := 'Nъmero de areas del BBS disponibles : %s';
  s[0147] := 'Nъmero de areas regionales disponibles: %s';

  s[0148] := 'Really abort (don¦t generate search request)?';
  s[0149] := 'The search request has been generated. The next time' + Chr(13)
             + 'you poll (Send and receive mails), the search' + Chr(13)
             + 'will be processed and you can get the results a short time' + Chr(13)
             + 'after (poll again).';

  s[0150] := 'El fichero log es menor de 300 KB, asi que' + Chr(13)
             + 'no es necesario cortarlo.';
  s[0151] := 'El fichero log no existe.';
  s[0152] := 'Tamaсo del fichero log: %s KB';
  s[0153] := 'Fichero log';
  s[0154] := 'Cortar fichero log';
  s[0155] := 'Volver';

  s[0156] := 'Please insert the Fido-Package deluxe CD and click again on "Other".';
  s[0157] := 'Pictures';

  s[0158] := ' Info de Fido';
  s[0159] := '    Info de Fido';
  s[0160] := '     Info de tu nodo';
  s[0161] := '     Manual del Golded';
  s[0162] := '    Otros';
  s[0163] := ''; // wird nicht mehr benцtigt
  s[0164] := 'volver';
  s[0165] := 'siguiente';
  s[0166] := 'Cerrar';

  s[0167] := 'AutoLlamada: Llamar cada %s'
             + ' minutos automaticamente cuando la ventana sea minimizada';
  s[0168] := 'Escala para AutoLlamada; unidades en minutos';
  s[0169] := 'Internet provider:';

  s[0170] := 'Not all RAS functions (Dial-Up network) have been found.' + Chr(13)
             + 'Anyway, it will be tried to continue.' + Chr(13)
             + 'If any error occurs, please report this to the author:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';

  s[0171] := 'AutoLlamada';
  s[0172] := 'Colores en el editor';
  s[0173] := 'Grupos';
  s[0174] := 'Address macros';
  s[0175] := 'Datos';
  s[0176] := 'History';
  s[0177] := 'Updates';

  s[0178] := 'Texto';
  s[0179] := 'Quote level';
  s[0180] := 'Fondo';
  s[0181] := 'Negro';
  s[0182] := 'Azul';
  s[0183] := 'Verde';
  s[0184] := 'Cyan';
  s[0185] := 'Rojo';
  s[0186] := 'Magenta';
  s[0187] := 'Marrуn';
  s[0188] := 'Gris';
  s[0189] := 'Gris claro';
  s[0190] := 'Azul claro';
  s[0191] := 'Verde claro';
  s[0192] := 'Cyan claro';
  s[0193] := 'Rojo claro';
  s[0194] := 'Magenta claro';
  s[0195] := 'Amarillo';
  s[0196] := 'Blanco';

  s[0197] := 'Puedes encontrar siempre la ъltima versiуn en la pбgina '
             + 'oficial.' + Chr(13)
             + 'Las direcciones (URLs) actuales son:';

  s[0198] := 'Negrita';
  s[0199] := 'Cursiva';
  s[0200] := 'Subrayado';

  s[0201] := 'In Golded (editor) you can use an address macro for writing '
             + 'a message to often used names. At "To:" simply enter the '
             + 'macro, e.g. mh for Michael Haase, 2:2432/280.';

  s[0202] := 'Cuidado: ЎEl nъmero de punto y claves solo deben de ser cambiados '
             + 'si sabes lo que haces. De otro modo el resultado puede ser que '
             + 'ya no puedas enviar ni recibir correo!';
  s[0203] := 'Direcciуn punto';
  s[0204] := '(Ўsi hay cambio la direcciуn antigua serб cancelada!)';
  s[0205] := 'Sesiуn';
  s[0206] := 'Clave';
  s[0207] := 'Areafix';
  s[0208] := 'Filemgr';
  s[0209] := 'Firma para cada mensaje:';

  s[0210] := 'ЎHubo un error leyendo %s' + Chr(13)
             + '(Fichero no existe o no estб completo)!' + Chr(13)
             + 'Because of this the data (address and passwords) is not' + Chr(13)
             + 'changeable.';

  s[0211] := 'Expert configurations';
  s[0212] := 'no proxy';
  s[0213] := 'IP address';

  s[0214] := 'El nъmero de punto antiguo serб cancelado ahora.';

  s[0215] := ''; // wird nicht mehr benцtigt

  s[0216] := 'Grupos en el editor (Golded):';
  s[0217] := 'aсadir nombre de grupo';
  s[0218] := 'quitar nombre de grupo';
  s[0219] := 'cambiar nombre de grupo';
  s[0220] := 'Areas existentes:';
  s[0221] := 'las araes seleccionadas pertenecen al grupo:';
  s[0222] := 'Nombre de grupo';
  s[0223] := 'Nuevo nombre de grupo:';

  s[0224] := 'no se ha encontrado el fichero "log"';

  s[0225] := 'Introduce el nombre del ficehros (o parte de el) que buscas '
             + 'y presiona ENTER (o pica en ACEPTAR). Puedes poner hasta 3 palabras '
             + 'clave de bъsqueda. Importante: No se permiten comodines '
             + '(asteriscos o exclamaciones)';
  s[0226] := 'Buscar palabra clave:';
  s[0227] := 'Se buscarбn los ficheros con la siguiente palabra clave:';
  s[0228] := 'Nota: La peticiуn de bъsqueda primero se generarб. La bъsqueda se '
             + 'realizarб cuando Llames (Enviar y recibir correo) la '
             + 'prуxima vez.';
  s[0229] := 'generar peticiones de bъsqueda';
  s[0230] := 'borrar entradas seleccionadas';
  s[0231] := 'Borrar'; // Entfernen-Taste
  s[0232] := 'mostrar resultados';

  s[0233] := 'Configuraciуn';
  s[0234] := 'Llamar';

  s[0235] := ''; // wird nicht mehr benцtigt
  s[0236] := ''; // wird nicht mehr benцtigt
  s[0237] := ''; // wird nicht mehr benцtigt
  s[0238] := ''; // wird nicht mehr benцtigt
  s[0239] := ''; // wird nicht mehr benцtigt

  s[0240] := '    Configuraciуn                                  ';
  s[0241] := 'Otro';

  s[0242] := 'Hay nueva informaciуn de tu nodo.' + Chr(13)
             + 'Para verla pica en "Informaciуn sobre Fido, ayuda, ..."' + Chr(13)
             + 'y luego en "Informaciуn de tu nodo".';

  s[0243] := 'La ventana con la conversaciуn IRC estб abierta.' + #13
             + 'їQuieres salir realmente?';
  s[0244] := 'Charlar con otros usuarios de FidoNet..';

  s[0245] := ''; // wird nicht mehr benцtigt

  s[0246] := 'El acceso a los fichero pedido (%s) no fue posible.';
  s[0247] := 'No se permiten claves vacias. Cambio de clave ignorado.';

  s[0248] := 'ЎHola!' + #13#10
             + #13#10
             + 'Bienvenido a la red de correo electrуnico FidoNet. Puedes '
             + 'suscribirte a las areas y leer el correo ya mismo. Para obtener '
             + 'permiso para escribir si realizaste el registro automбtica '
             + 'debes contactar con tu nodo (del que te acabas de registrar '
             + 'hace un minuto). Para ello puedes simplemente contestar este '
             + 'mensaje (presiona "q" y luego ENTER dos veces), escribe el texto'
             + 'y presiona ALT-S y ENTER para guardar el mensaje). Por ъltimo  '
             + 'enviar el mensaje a tu nodo con la opciуn "Enviar y recibir '
             + 'correo (Llamar)" en el menъ principal.' + #13#10
             + #13#10
             + 'Tambiйn puedes escribir o mandar un email: ' + #13#10
             + #13#10
             + 'Nombre: %s' + #13#10
             + 'Telйfono: %s' + #13#10
             + 'eMail: %s' + #13#10
             + #13#10
             + #13#10
             + 'Un manual de Fido-Package y mбs informaciуn la podrбs encontrar '
             + 'desde el menъ principal en la opciуn  "Informaciуn sobre FidoNet, '
             + 'ayuda, ...".' + #13#10
             + #13#10
             + 'Si no puedes enviar el correo (Llamar) durante un tiempo o tienes '
             + 'cualquier problema, por favor, informa a tu nodo o tu cuenta puede '
             + 'que sea borrada por inactividad.' + #13#10
             + #13#10
             + 'їPuedo preguntar donde oiste hablar de Fido-Package?' + #13#10
             + #13#10
             + 'Espero que lo pases bien.' + #13#10
             + #13#10
             + '(Este es un mensaje creado automaticamente por Fido-Package '
             + 'deluxe %s.)' + #13#10;

  s[0249] := 'Acrobat Reader para ver archivos PDF no estбinstalado. '
             + 'Lo puedes conseguir aquн:' + #13
             + 'www.adobe.com/products/acrobat/readstep2.html' + #13
             + '(o si tienes el cd-rom de Fido-Package, estб en'
             + '\sonst\andere-programme\acrobat-reader 5\)' + #13
             + #13
             + 'Por otra parte tienes el manual tambiйn en formato RTF, que '
             + 'puede ser vistro directamente. Lo puedes descargar aquн:' + #13
             + 'www.fido-deluxe.de.vu';

  s[0250] := '(ЎNombres reales, apodos o falsos' + #13
             + 'serбn borrados inmediatamente!)';

  s[0251] := 'Because of rude language and offenses towards new users,' + #13
             + 'rules contradicting against laws or Fido policies,' + #13
             + 'and the exclusion of gay people in the rules, this' + #13
             + 'area has restricted access! If you are really sure you' + #13
             + 'want to subscribe to this area, you should be an advanced' + #13
             + 'Fido user, so you should and have to know how to subscribe' + #13
             + 'manually for this area.' + #13
             + 'The rules just were created as a netmail, you can read them' + #13
             + 'within Golded.' + #13
             + '- NEC 2457, Michael Haase (2:2457/2)';

  s[0252] := 'Tamaсo de la ventana (numbero de lineas) de Golded (editor):';

  s[0253] := 'At the moment "other Provider" is configured for internet' + #13
             + 'connection. If you have a network (LAN) connection into' + #13
             + 'the internet, then no appropiate selection were available' + #13
             + 'during installation. With network (LAN) it will no longer' + #13
             + 'checked if an internet connection is available.' + #13
             + 'Do you want to change to network (LAN) connection?';
  s[0254] := 'local network (LAN) = no online check';

  s[0255] := 'Instalaciуn antigua encontrada. їDeberбn ser usados esos datos para' + #13
             + 'la instalaciуn (sin nuevo registro)?';

  s[0256] := 'suscribirse de nuevo a todas las areas ya suscritas';
  s[0257] := 'Lista creada. En la prуxima Llamada ("Enviar y recibir correo")' + #13
             + 'la suscripciуn serб enviada.';
  s[0258] := '(con Win 95/98/ME sуlo son posibles 25, 43 o 50 lineas)';
  s[0259] := 'Nombre del nodo';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := 'ЎNъmero de punto introducido no vбlido!' + #13
             + 'Debe estar en formato z:nnnn/nnnn.ppppp,' + #13
             + 'ej. "2:2457/280.13" o "2:2457/280.0".';
  s[0262] := 'Actualizar lista';
  s[0263] := 'Lista actualizada.';
  s[0264] := 'La conexiуn fallу. їEstб activa la conexiуn a internet?';
  s[0265] := 'Transaction failure.';
  s[0266] := 'Invalid Host.';
  s[0267] := 'Actualizar lista';
  s[0268] := 'Actualizar lista desde internet';
  s[0269] := 'Abrir lista desde el disco duro';
  s[0270] := 'No realizar nuevo registro, conozco mis datos';
  s[0271] := 'Introducir datos';
  s[0272] := 'Nъmero de punto:';
  s[0273] := 'Clave:';
  s[0274] := 'Clave para Areafix:';
  s[0275] := 'Clave para File Ticker:';
  s[0276] := 'Clave para PKT:';
  s[0277] := 'Nombre de Areafix:';
  s[0278] := 'Nombre de File Ticker:';
  s[0279] := 'E-Mail del nodo:';
  s[0280] := 'Num. de telйfono del nodo:';
  s[0281] := 'ЎPor favor, repasa los datos introducidos,' + #13
             + 'sin son erroneos no funcionarб!';
  s[0282] := 'Nъmero de nodo (_no_ direcciуn completa) (opcional):';
  s[0283] := 'Input not complete!';
  s[0284] := 'Selection list faulty, standard list will be used.';
  s[0285] := 'Enter proxy on previous page if necessary. Internet connection must already be active!';
  s[0286] := 'Nombre del nodo:';
  s[0287] := 'Direcciуn del nodo completa (ej. 2:2432/280):';
  s[0288] := 'DNS/IP (ej. fido.dyndns.org):';
  s[0289] := '### Otro nodo (introduce tъ los datos)'; // must begin with '#'! (because of sorting of the list)
  s[0290] := '    Problem-Check';
  s[0291] := 'Manual de Fido-Package';

  s[0292] := 'Error occured during reading of binkd.cfg.' + #13
             + 'Does it exist?';
  s[0293] := 'Error detected in the "node"-line in binkd.cfg.' + #13
             + 'DNS entry is missing or faulty.';

  sprache_Hinweis := 'Aviso';
  sprache_Fehler := 'Error';
  sprache_Info := 'Info';
end;

procedure deutsch_strings_initialisieren;
begin
  s[0001] := 'Fido-Paket deluxe';
  s[0002] := 'Fido-Paket deluxe Setup';
  s[0003] := 'Fido-Paket deluxe - Setup';
  s[0004] := 'Willkommen zum Fido-Paket deluxe - Installationsprogramm' + Chr(13)
           + '%s, von Michael Haase (m.haase@gmx.net)';
  s[0005] := 'Homepage mit der jeweils aktuellen Version: http://www.fido-deluxe.de.vu';
  s[0006] := 'Soll das Fido-Paket deluxe jetzt installiert werden?';
  s[0007] := '&Update';
  s[0008] := '&Ja';
  s[0009] := 'Setup &beenden';

  s[0010] := 'Jetzt bitte sicherstellen, daЯ die Netzwerkverbindung steht, es';
  s[0011] := 'Jetzt bitte sicherstellen, daЯ die Internetverbindung steht, es';
  s[0012] := 'Jetzt bitte sicherstellen, daЯ die Internetverbindung genutzt werden kann, es';
  s[0013] := 'Jetzt bitte das Modem / das ISDN Gerдt einschalten, es';
  s[0014] := Chr(13) + 'wird jetzt versucht, eine Verbindung zum ausgewдhlten' + Chr(13)
             + 'Fido-Sysop herzustellen.';

  s[0015] := 'Keine bestehende Internet-Verbindung erkannt.';

  s[0016] := 'Passwort fьr %s:';
  s[0017] := 'Internet-Verbindung';

  s[0018] := 'Es ist ein Fehler beim Verbindungsaufbau aufgetreten, die' + Chr(13)
             + 'Verbindung wurde vor dem Empfangen und Senden der Mails getrennt.' + Chr(13)
             + 'Fehler bei Aktion: Pollen' + Chr(13)
             + 'Meldung: %s';

  s[0019] := 'Verbindung hergestellt.';

  s[0020] := 'Status:';
  s[0021] := 'Fido-Anmeldung lдuft..';

  s[0022] := 'Die Installation ist erfolgreich abgeschlossen.' + Chr(13)
             + 'Es wurde eine Verknьpfung im Startmenь und auf' + Chr(13)
             + 'dem Desktop angelegt (Fido-Menь).';

  s[0023] := 'Es ist ein Fehler aufgetreten.' + Chr(13)
             + 'Fehlernummer: %s' + Chr(13)
             + 'Aktion: Pollen';

  s[0024] := 'Verbindung fehlgeschlagen. Mцglicherweise ist' + Chr(13)
             + 'dies durch einen vorьbergehenden Fehler bedingt.' + Chr(13)
             + 'Evtl. spдter nochmal versuchen.' + Chr(13)
             + 'Fьr weitere Informationen kannst Du in das Logfile gucken' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';

  s[0025] := 'Fehlerhafte Daten (CDN) empfangen. Fehlercode: %s';
  sprache_Fehlercode := 'Fehlercode'; // muЯ mit ^^^^^^^^^^ ьbereinstimmen!

  s[0026] := 'Die Anmelde-Daten wurden erfolgreich ьbermittelt.' + #13
             + 'Jetzt wird noch die erste Fido-Area anbestellt und damit '
             + 'gleichzeitig geprьft, ob alles vollstдndig installiert wurde.' + #13
             + #13
             + 'Nach der Installation findest Du im Hauptmenь unter dem '
             + 'Menьpunkt "Infos zu Fido, Hilfe ..." ein Handbuch '
             + 'zu diesem Fido-Paket und weitere interessante Informationen.' + #13
             + #13
             + 'Dein erster Schritt wird vermutlich sein, daЯ Du Dir ein paar '
             + 'Areas (auch Echo genannt) anbestellst, dies geht im Menь "Echo '
             + 'an- oder abbestellen". Wenn Du Dich z.B. fьr Star Trek '
             + 'interessierst, dann mцchtest Du vielleicht die Startrek.ger '
             + 'anbestellen (das ".ger" steht fьr German, also deutsch). Oder '
             + 'Witze (Jokes.Ger)? PC-Hardware (Hardware.ger)? Es '
             + 'gibt sehr viele interessante Areas, schau also gleich mal in '
             + 'die Liste und bestell Dir die eine oder andere an, die Du magst.';

  s[0027] := 'Installation des Fido-Paket deluxe';
  s[0028] := 'Name';
  s[0029] := 'Bitte Vor- und Nachnamen angeben';
  s[0030] := 'PLZ / Ort';
  s[0031] := 'Telefon';
  s[0032] := 'Bitte Vorwahl und Rufnummer mit einem Minuszeichen getrennt angeben';
  s[0033] := ''; // wird nicht mehr benцtigt
  s[0034] := ''; // wird nicht mehr benцtigt
  s[0035] := ''; // wird nicht mehr benцtigt
  s[0036] := '(Internet-) Verbindung ьber das DFЬ Netzwerk herstellen mit:';
  s[0037] := ''; // wird nicht mehr benцtigt
  s[0038] := ''; // wird nicht mehr benцtigt
  s[0039] := 'Betriebssystem';
  s[0040] := 'Erkanntes Betriebssystem: ';
  s[0041] := 'Installations-&Verzeichnis auswдhlen';
  s[0042] := 'Installations-Verzeichnis: %s' + ':\FIDO';
  s[0043] := 'Bei folgendem System als Fido-Teilnehmer (Point) eintragen:';
  s[0044] := 'Vorwahl      Ort                                                 Sysop-Name';
  s[0045] := '&Installation starten';
  s[0046] := '&Abbruch (Beenden)';

  s[0047] := 'Pollen';
  s[0048] := 'Die Verbindung wird hergestellt...';
  s[0049] := 'Status des Verbindungs-Aufbaus:';
  s[0050] := 'Abbrechen';

  s[0051] := 'Die angegebene CDN-Datei wurde nicht gefunden:' + Chr(13)
             + '%s';
  s[0052] := 'Bitte den kompletten Pfad zur CDN-Datei angeben!' + chr(13)
             + '(z.B.: c:\beispiel\beispiel.cdn)';

  s[0053] := 'Das DFЬ Netzwerk ist nicht installiert, es wurde jedoch' + Chr(13)
             + 'eine Internet-Verbindung erkannt. Daher kann mit der' + Chr(13)
             + 'Installation fortgefahren werden, allerdings wird es nur' + Chr(13)
             + 'mцglich sein, Internet-Verbindungen herzustellen.';

  s[0054] := 'Das DFЬ Netzwerk ist nicht installiert, wird jedoch' + Chr(13)
             + 'benцtigt. Bitte mit Hilfe von Software / Windows-Setup' + Chr(13)
             + 'unter Arbeitsplatz / Systemsteuerung installieren, und' + Chr(13)
             + 'dann die Installation des Fido-Paket deluxe neu starten.';
  s[0055] := 'Fehler bei der Installation';

  s[0056] := 'Internet-Verbindung';

  s[0057] := 'Es ist kein Modem oder ISDN-Karte fьr das DFЬ Netzwerk' + Chr(13)
             + 'installiert.' + Chr(13)
             + 'Bitte dies nachholen, und dann die Installation des' + Chr(13)
             + 'Fido-Paket deluxe neu starten.';

  s[0058] := 'Es ist ein unbekannter Fehler beim Erstellen einer neuen' + Chr(13)
             + 'Verbindung im DFЬ Netzwerk aufgetreten.' + Chr(13)
             + 'Die Installation wird abgebrochen.';

  s[0059] := 'Erkanntes Betriebssystem: %s';

  s[0060] := 'Fehler beim Цffnen der Datei "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + 'Fehlernummer: %s';

  s[0061] := 'Es wurde noch keine internationale Vorwahl eingegeben.';
  s[0062] := 'Fehler bei der Eingabe';
  s[0063] := 'Es wurde noch kein Name eingegeben.';
  s[0064] := 'Der eingegebene Name ist nicht vollstдndig.';
  s[0065] := 'Es wurde noch kein Ort eingegeben.';
  s[0066] := 'Es wurde ein ungьltiger Ort eingegeben.';
  s[0067] := 'Es wurde noch keine Telefonnummer eingegeben.';
  s[0068] := 'Bitte die Vorwahl von der Rufnummer mit "-" trennen,' + Chr(13)
             + 'zum Beispiel: 02732-12345';
  s[0069] := 'Es wurde eine ungьltige Telefonnummer eingegeben.';
  s[0070] := 'Bei der Call-By-Call Nummer sind nur Ziffern erlaubt.' + Chr(13)
             + 'Sie muЯ 010xx oder 010xxx lauten, z.B. 01030 (oder leer lassen).';

  s[0071] := 'Es ist nicht genug freier Speicherplatz auf dem gewдhlten' + Chr(13)
             + 'Laufwerk (%s' + ':) vorhanden.' + Chr(13)
             + 'Es werden mindestens 20 MB benцtigt.';

  s[0072] := 'Fido-Menь';
  s[0073] := 'Vom Fido abmelden';
  s[0074] := 'Deinstallieren von Fido-Paket deluxe';

  s[0075] := 'Kein Grund angegeben, vermutlich ein vorьbergehender' + Chr(13)
             + 'Fehler, evtl. spдter nochmal versuchen.' + Chr(13)
             + 'Fьr weitere Informationen kannst Du in das Logfile gucken' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';
  s[0076] := 'Das ausgewдhlte Fido-System akzeptiert im Moment keine neuen'
             + Chr(13) + 'Fido-Mitglieder (Points). Der angegebene Grund:' + Chr(13);
  s[0077] := 'Bitte die Installation des Fido-Paket deluxe abbrechen, oder ein'
             + Chr(13) + 'anderes Fido-System auswдhlen.';

  s[0078] := 'Sollen die bisher installierten Dateien gelцscht werden?';
  s[0079] := 'Abbruch der Installation';
  s[0080] := 'Alle bisher installierten Dateien gelцscht.';

  s[0081] := 'Es dьrfen keine Leerzeichen (" ") im Pfad enthalten sein.'
             + Chr(13) + 'Verzeichnis: %s' + Chr(13)
             + Chr(13) + 'Bitte ein anderes Verzeichnis wдhlen.';
  s[0082] := 'Das ausgewдhlte Installations-Verzeichnis existiert bereits.'
             + Chr(13) + 'Verzeichnis: %s' + Chr(13)
             + '*** Alle enthaltenen Dateien und Unterordner werden gelцscht! ***'
             + Chr(13) + Chr(13)
             + 'Sicher?';
  s[0083] := 'Warnung';

  s[0084] := 'Installations-Verzeichnis: %s';

  s[0085] := 'anderer Internet-Provider';

  s[0086] := 'Keine alte Installation gefunden.'
             + Chr(13) + 'Verzeichnis: %s'
             + Chr(13) + 'Gesuchte Datei: point.cdn'
             + Chr(13) + Chr(13)
             + 'Bitte ein anderes Verzeichnis wдhlen.';

  s[0087] := 'Update erfolgreich abgeschlossen.';

  s[0088] := 'Das Fido-Paket deluxe (10 MB) wird jetzt installiert.' + Chr(13)
             + 'Bitte warten.';

  s[0089] := 'Installation wirklich abbrechen?';
  s[0090] := 'Abbruch';
  s[0091] := 'Sollen die bisher installierten Dateien gelцscht werden?';
  s[0092] := 'Alle bisher installierten Dateien gelцscht.';

  s[0093] := 'Netzwerkkarte = keine Wдhlverbindung';
  s[0094] := 'Internet-Verbindung';
  s[0095] := 'Es ist ein unerwarteter Fehler beim Abfragen der Verbindungen' + Chr(13)
             + 'im DFЬ Netzwerk aufgetreten.' + Chr(13);
  s[0096] := 'Fehlernummer: %s' + Chr(13)
             + 'Bitte den Programmierer benachrichtigen:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := 'Es ist ein unerwarteter Fehler beim Allokieren von Speicher aufgetreten.' + Chr(13);
  s[0098] := 'kein Modem oder ISDN Capi gefunden';

  s[0099] := 'isdn'; // nicht дndern!
  s[0100] := 'modem'; // nicht дndern!
  s[0101] := 'Kommunikationskabel'; // nicht дndern!

  s[0102] := 'Das DFЬ Netzwerk ist nicht installiert. Es wird jetzt nach einer aktiven Internet-Verbindung gesucht..';
  s[0103] := 'Internet-Verbindung steht, nicht weiter suchen';

  s[0104] := 'Fido-Paket';

  s[0105] := 'CDN Datei nicht mehr gefunden.' + Chr(13)
             + 'Diese bitte nicht in das Installationsverzeichnis kopieren!';

  s[0106] := 'Das Fido-Paket deluxe ist nun deinstalliert.';
  s[0107] := 'Deinstallation';
  s[0108] := 'Soll das Fido-Paket deluxe wirklich deinstalliert werden?';

  s[0109] := '&Zeige Fido-Menь';
  s[0110] := 'B&eenden';

  s[0111] := ' Hauptmenь (Fido-Paket deluxe)';
  s[0112] := 'Fido-Paket deluxe %s' + Chr(13)
             + '         von Michael Haase';
  s[0113] := '  Mails senden und empfangen (Pollen)';
  s[0114] := '  Mails lesen und schreiben (Editor)       ';
  s[0115] := '   Echo an- oder abbestellen                ';
  s[0116] := '  Datei suchen beim File-List-Server    ';
  s[0117] := '  Logfiles ansehen und kьrzen            ';
  s[0118] := '  Infos zu Fido, Hilfe ...                       ';
  s[0119] := '  Beenden ';
  s[0120] := '  Bug melden';

  s[0121] := 'Die Internet-Verbindung ist nicht verfьgbar.';
  s[0122] := 'Passwort:';

  s[0123] := 'Du hast neue (persцnliche) Mail.' + Chr(13)
             + 'Netmails: %s' + Chr(13)
             + 'Echomail: %s';

  s[0124] := ''; // wird nicht mehr benцtigt

  s[0125] := 'Es ist ein Fehler aufgetreten.' + Chr(13)
             + 'Fehlernummer: %s' + Chr(13)
             + 'Aktion: Editor';

  s[0126] := 'Willst Du Dich wirklich vom Fido abmelden' + Chr(13)
             + 'und alle Areas abbestellen?';
  s[0127] := 'Abmelden?';

  s[0128] := 'Anzahl anbestellter Echos: %s';

  s[0129] := 'Der angegebene Suchbegriff wurde nicht gefunden.';
  s[0130] := 'Suchen';
  s[0131] := 'Keine weitere Fundstelle fьr den angegebenen Suchbegriff.';

  s[0132] := 'Wirklich abbrechen (alle gemachten Дnderungen gehen verloren)?';

  s[0133] := 'Anzahl verfьgbarer deutschsprachiger Fido-Echos: %s';

  s[0134] := ' Echo-Verwaltung';
  s[0135] := 'Zum An- oder Abbestellen eines Echos einen Doppelklick darauf machen.';
  s[0136] := 'Echo-Auswahl:';
  s[0137] := '   deutsche';
  s[0138] := '    amerikanische';
  s[0139] := '   lokale';
  s[0140] := '    regionale';
  s[0141] := 'Suchbegriff';
  s[0142] := 'suchen';
  s[0143] := 'weiter suchen';
  s[0144] := 'OK';

  s[0145] := 'Anzahl verfьgbarer amerikanischer Fido-Echos: %s';
  s[0146] := 'Anzahl verfьgbarer Box-Echos: %s';
  s[0147] := 'Anzahl verfьgbarer (regionaler) Netz-Echos: %s';

  s[0148] := 'Wirklich abbrechen (keine Suchanfrage generieren)?';
  s[0149] := 'Die Suchanfrage wurde generiert. Wenn Du das nдchste' + Chr(13)
             + 'mal pollst (Mails empfangen und senden), wird die' + Chr(13)
             + 'Suche bearbeitet und Du kannst kurz darauf das Ergebnis' + Chr(13)
             + 'abholen (erneut pollen).';

  s[0150] := 'Das Logfile ist kleiner als 300 KB, daher ist' + Chr(13)
             + 'es nicht nцtig, es zu kьrzen.';
  s[0151] := 'Logfile nicht vorhanden.';
  s[0152] := 'GrцЯe des Logfiles: %s KB';
  s[0153] := 'Logfile';
  s[0154] := 'Logfile kьrzen';
  s[0155] := 'Zurьck';

  s[0156] := 'Bitte die Fido-Paket deluxe CD einlegen und erneut auf "Sonstiges" klicken.';
  s[0157] := 'Bilder';

  s[0158] := ' Fido-Infos';
  s[0159] := '    Infos zu Fido';
  s[0160] := '     Infos Deines Nodes';
  s[0161] := '     Golded Handbuch';
  s[0162] := '    Sonstiges';
  s[0163] := ''; // wird nicht mehr benцtigt
  s[0164] := 'zurьck';
  s[0165] := 'vor';
  s[0166] := 'SchlieЯen';

  s[0167] := 'AutoPoll: Alle %s'
             + ' Minuten automatisch pollen, wenn Fenster minimiert';
  s[0168] := 'Anzeige fьr AutoPoll; Angaben in Minuten';
  s[0169] := 'Internet-Provider:';

  s[0170] := 'Es wurden nicht alle RAS-Funktionen (DFЬ Netzwerk) gefunden.' + Chr(13)
             + 'Es wird trotzdem versucht weiterzumachen.' + Chr(13)
             + 'Wenn Fehler auftreten, bitte den Programmierer benachrichtigen:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';

  s[0171] := 'AutoPoll';
  s[0172] := 'Farben im Editor';
  s[0173] := 'Gruppen';
  s[0174] := 'Adressmakros';
  s[0175] := 'Daten';
  s[0176] := 'History';
  s[0177] := 'Updates';

  s[0178] := 'Text';
  s[0179] := 'Quoteebene';
  s[0180] := 'Hintergrund';
  s[0181] := 'Schwarz';
  s[0182] := 'Blau';
  s[0183] := 'Grьn';
  s[0184] := 'Cyan';
  s[0185] := 'Rot';
  s[0186] := 'Magenta';
  s[0187] := 'Braun';
  s[0188] := 'Dunkelgrau';
  s[0189] := 'Hellgrau';
  s[0190] := 'Hellblau';
  s[0191] := 'Hellgrьn';
  s[0192] := 'Hellcyan';
  s[0193] := 'Hellrot';
  s[0194] := 'Hellmagenta';
  s[0195] := 'Gelb';
  s[0196] := 'Weiss';

  s[0197] := 'Die jeweils aktuelle Version und Updates gibt es auf der '
             + 'Homepage.' + Chr(13)
             + 'Die aktuellen Adressen (URLs) sind:';

  s[0198] := 'Fett';
  s[0199] := 'Kursiv';
  s[0200] := 'Unterstrichen';

  s[0201] := 'In Golded (Editor) kann man beim Schreiben einer Mail beim '
             + 'Adressaten ein Adressmakro fьr hдufig verwendete Namen '
             + 'benutzen. Bei "An:" einfach das Kьrzel eingeben, z.B. mh '
             + 'fьr Michael Haase, 2:2432/280.';

  s[0202] := 'Achtung: Die Дnderung der Pointnummer und der Passwцrter sollte '
             + 'nur erfolgen, wenn man weiЯ, was man macht. Ansonsten kann dies '
             + 'dazu fьhren, daЯ keine Mails mehr empfangen oder versendet '
             + 'werden kцnnen!';
  s[0203] := 'Pointadresse';
  s[0204] := '(Bei Дnderung wird die alte AKA abgemeldet!)';
  s[0205] := 'Session';
  s[0206] := 'Passwort';
  s[0207] := 'Areafix';
  s[0208] := 'Filemgr';
  s[0209] := 'Footer unter jeder Mail:';

  s[0210] := 'Fehler beim Lesen von %s aufgetreten' + Chr(13)
             + '(Datei nicht vorhanden oder nicht vollstдndig)!' + Chr(13)
             + 'Deswegen kцnnen die Daten (Adresse und Passwцrter) nicht' + Chr(13)
             + 'geдndert werden.';

  s[0211] := 'Experten-Einstellungen';
  s[0212] := 'kein Proxy';
  s[0213] := 'IP Adresse';

  s[0214] := 'Die alte Pointnummer wird jetzt abgemeldet.';

  s[0215] := ''; // wird nicht mehr benцtigt

  s[0216] := 'Gruppen im Editor (Golded):';
  s[0217] := 'Gruppenname hinzufьgen';
  s[0218] := 'Gruppenname lцschen';
  s[0219] := 'Gruppenname дndern';
  s[0220] := 'Vorhandene Areas:';
  s[0221] := 'selektierte Area gehцrt zu Gruppe:';
  s[0222] := 'Gruppenname';
  s[0223] := 'Neuer Gruppenname:';

  s[0224] := 'kein Logfile gefunden';

  s[0225] := 'Bitte den Dateinamen (oder einen Teil davon)  eingeben, '
             + 'nach dem gesucht werden soll, und Return drьcken (oder '
             + 'auf OK klicken). Es kцnnen bis zu 3 Suchbegriffe '
             + 'eingegeben werden. Wichtig: Keine Wildcards (Sternchen '
             + 'oder Fragezeichen) erlaubt!';
  s[0226] := 'Suchbegriff:';
  s[0227] := 'Es werden Dateien mit diesen Suchbegriffen gesucht:';
  s[0228] := 'Hinweis: Die Suchanfrage wird zunдchst generiert. Die '
             + 'eigentliche Suche wird erst ausgefьhrt, wenn Du das nдchste '
             + 'mal pollst (Mails senden/empfangen).';
  s[0229] := 'Suchanfrage generieren';
  s[0230] := 'markierte Eintrдge lцschen';
  s[0231] := 'Entf'; // Entfernen-Taste
  s[0232] := 'Ergebnisse anzeigen';

  s[0233] := 'Konfiguration';
  s[0234] := 'Pollen';

  s[0235] := ''; // wird nicht mehr benцtigt
  s[0236] := ''; // wird nicht mehr benцtigt
  s[0237] := ''; // wird nicht mehr benцtigt
  s[0238] := ''; // wird nicht mehr benцtigt
  s[0239] := ''; // wird nicht mehr benцtigt

  s[0240] := '  Konfiguration                                    ';
  s[0241] := 'Sonstiges';

  s[0242] := 'Es gibt neue Infos von Deinem Node.' + Chr(13)
             + 'Um sie anzusehen klicke auf "Infos zu Fido, Hilfe ..."' + Chr(13)
             + 'und dann auf "Infos Deines Nodes".';

  s[0243] := 'Das Fenster mit dem IRC-Chat ist noch offen.' + #13#10
             + 'Wirklich beenden?';
  s[0244] := 'Chatten mit anderen Fidoleuten..';

  s[0245] := ''; // wird nicht mehr benцtigt

  s[0246] := 'Auf die Request-Datei (%s) konnte nicht zugegriffen werden.';
  s[0247] := 'Leere Passwцrter sind nicht erlaubt. Passwort-Дnderung wird ignoriert.';

  s[0248] := 'Hallo!' + #13#10
             + #13#10
             + 'Willkommen im Fido. Durch die automatische Anmeldung kannst '
             + 'Du sofort Areas anbestellen und Mails lesen. Um Schreibzugriff '
             + 'zu erhalten, musst Du Deinen Node (bei dem Du Dich eben '
             + 'angemeldet hast) kontaktieren. Dazu kannst Du einfach auf diese '
             + 'Mail antworten (Taste "q" und zweimal Return/Enter druecken, '
             + 'Deinen Text schreiben und dann ALT-S und Return/Enter zum '
             + 'Speichern druecken) und die Antwort mittels des Menuepunktes '
             + '"Mails senden und empfangen (Pollen)" im Hauptmenue abschicken.' + #13#10
             + #13#10
             + 'Du kannst auch anrufen, oder eine eMail schreiben:' + #13#10
             + #13#10
             + 'Name: %s' + #13#10
             + 'Telefon: %s' + #13#10
             + 'eMail: %s' + #13#10
             + #13#10
             + #13#10
             + 'Ein Handbuch zu diesem Fido-Paket und weitere Infos findest Du '
             + 'im Hauptmenue unter dem Punkt "Infos zu Fido, Hilfe ...".' + #13#10
             + #13#10
             + 'Solltest Du mal laengere Zeit nicht pollen (Mails holen) koennen, '
             + 'dann informiere bitte Deinen Node, denn sonst wirst Du in der '
             + 'Regel nach 100 Tagen Inaktivitaet automatisch geloescht.' + #13#10
             + #13#10
             + 'Darf ich fragen, woher Du von diesem Fido-Paket erfahren hast?' + #13#10
             + #13#10
             + 'Viel Spass noch..' + #13#10
             + #13#10
             + '(Dies ist eine automatisch erstellte Mail vom Fido-Paket '
             + 'deluxe %s.)' + #13#10;

  s[0249] := 'Du hast den Acrobat Reader zum Anzeigen von PDF Dokumenten nicht '
             + 'installiert. Du kannst diesen hier bekommen:' + #13
             + 'www.adobe.com/products/acrobat/readstep2.html' + #13
             + '(oder falls Du die Fido-Paket CD-Rom hast ist er in '
             + '\sonst\andere-programme\acrobat-reader 5\)' + #13
             + #13
             + 'Alternativ gibt es das Handbuch auch im RTF Format, welches '
             + 'direkt angezeigt werden kann. Du kannst es hier runterladen:' + #13
             + 'www.fido-deluxe.de.vu';

  s[0250] := '(Bitte echter Namen, Fakes' + #13
             + 'werden sofort gelцscht!)';

  s[0251] := 'Wegen rьder Sprache und Beleidigungen gegenьber neuen Usern,' + #13
             + 'Rules, die dem Gesetz oder Fido Policies widersprechen' + #13
             + 'und dem Ausschluss von schwulen Leuten in den Rules, hat' + #13
             + 'diese Area einen eingeschrдnkten Zugriff! Wenn Du wirklich' + #13
             + 'sicher bist, daЯ Du diese Area anbestellen willst, dann solltest' + #13
             + 'Du bereits ein erfahrener Fido User sein, so dass Du wissen' + #13
             + 'solltest und musst, wie man diese Area manuell anbestellt.' + #13
             + 'Die Rules dieser Area wurden Dir gerade als Netmail erstellt,' + #13
             + 'Du kannst sie in Golded lesen.' + #13
             + '- NEC 2457, Michael Haase (2:2457/2)';

  s[0252] := 'FenstergrцЯe (Anzahl Zeilen) von Golded (Editor):';

  s[0253] := 'Momentan ist "anderer Provider" als Internetverbindung' + #13
             + 'eingestellt. Wenn Du eine Netzwerkverbindung (LAN) ins' + #13
             + 'Internet hast, dann gab es bei der Installation keine' + #13
             + 'Auswahl dafьr. Bei Netzwerk (LAN) erfolgt keine Prьfung' + #13
             + 'mehr, ob eine Internetverbindung besteht.' + #13
             + 'Soll auf Netzwerkverbindung (LAN) umgestellt werden?';
  s[0254] := 'lokales Netzwerk (LAN) = keine Onlineprьfung';

  s[0255] := 'Alte Installation gefunden. Sollen diese Daten fьr die' + #13
             + 'Installation benutzt werden (also keine Neuanmeldung)?';

  s[0256] := 'alle anbestellten Echos neu bestellen';
  s[0257] := 'Liste erstellt, beim nдchsten Pollen ("Mails senden' + #13
             + 'und empfangen") wird die Anbestellung gesendet.';
  s[0258] := '(bei Win 95/98/ME gehen nur 25, 43 oder 50 Zeilen)';
  s[0259] := 'Node Name';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := 'Die eingegebene Pointadresse ist ungьltig!' + #13
             + 'Sie muЯ im Format z:nnnn/nnnn.ppppp sein,' + #13
             + 'z.B. "2:2457/280.13" oder "2:2457/280.0".';
  s[0262] := 'Aktualisiere Liste';
  s[0263] := 'Liste aktualisiert.';
  s[0264] := 'Verbindung fehlgeschlagen. Internet-Verbindung aktiv?';
  s[0265] := 'Transaktion fehlgeschlagen.';
  s[0266] := 'Ungьltiger Host.';
  s[0267] := 'Aktualisieren der Liste';
  s[0268] := 'Aktuelle Liste aus Internet laden';
  s[0269] := 'Liste von Festplatte цffnen';
  s[0270] := 'Keine Neuanmeldung, ich kenne die Zugangsdaten';
  s[0271] := 'Eingabe der Zugangsdaten';
  s[0272] := 'Pointnummer:';
  s[0273] := 'Passwort:';
  s[0274] := 'Areafix Passwort:';
  s[0275] := 'File Ticker Passwort:';
  s[0276] := 'PKT Passwort:';
  s[0277] := 'Areafix Name:';
  s[0278] := 'File Ticker Name:';
  s[0279] := 'E-Mail-Adresse des Nodes:';
  s[0280] := 'Telefon-Nummer des Nodes:';
  s[0281] := 'Bitte prьfe die eingegebenen Daten doppelt,' + #13
             + 'bei falschen Daten funktioniert es nicht!';
  s[0282] := 'Node-Nummer (_nicht_ komplette AKA!) (optional):';
  s[0283] := 'Angaben nicht vollstдndig!';
  s[0284] := 'Auswahl-Liste fehlerhaft, Standard-Liste wird verwendet.';
  s[0285] := 'Proxy ggf. auf der vorigen Seite eintragen. Internet-Verbindung muss bereits bestehen!';
  s[0286] := 'Name des Nodes:';
  s[0287] := 'Komplette Node-Adresse (z.B. 2:2432/280):';
  s[0288] := 'DNS/IP (z.B. fido.dyndns.org):';
  s[0289] := '### Anderer Node (Daten selber eingeben)'; // muss mit '#' beginnen! (wegen Sortierung der Liste)
  s[0290] := '    Problem-Prьfung';
  s[0291] := 'Fido-Paket Handbuch';

  s[0292] := 'Fehler beim Lesen der binkd.cfg aufgetreten.' + #13
             + 'Ist diese vorhanden?';
  s[0293] := 'Fehler in der "node"-Zeile in der binkd.cfg entdeckt.' + #13
             + 'DNS-Eintrag fehlt oder ist fehlerhaft.';

  sprache_Hinweis := 'Hinweis';
  sprache_Fehler := 'Fehler';
  sprache_Info := 'Info';
end;

end.

