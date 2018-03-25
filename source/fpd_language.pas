unit fpd_language;
// language file for Fido-Package deluxe (www.fido-deluxe.de.vu)
// last change: 04-NOV-2005

// VerzeichnisAuswahl.LabelCaptions und .NewFolderCaptions zus�tzlich anpassen
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
  s[0033] := ''; // wird nicht mehr ben�tigt
  s[0034] := ''; // wird nicht mehr ben�tigt
  s[0035] := ''; // wird nicht mehr ben�tigt
  s[0036] := '(Internet-) Connect via Dial-Up Network with:';
  s[0037] := ''; // wird nicht mehr ben�tigt
  s[0038] := ''; // wird nicht mehr ben�tigt
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

  s[0051] := 'The given CDN file wasn�t found:' + Chr(13)
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
  s[0076] := 'The selected Fido system doesn�t accept new Fido members (Points)'
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
  s[0103] := 'Internet connection is active, don�t search anymore';

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

  s[0124] := ''; // wird nicht mehr ben�tigt

  s[0125] := 'An error occurred.' + Chr(13)
             + 'Error code: %s' + Chr(13)
             + 'Action: Editor';

  s[0126] := 'Do you really want to cancel Fido membership' + Chr(13)
             + 'and cancel subscription for all areas?';
  s[0127] := 'Cancel Fido membership?';

  s[0128] := 'Number of connected areas: %s';

  s[0129] := 'The given search keyword wasn�t found.';
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

  s[0148] := 'Really abort (don�t generate search request)?';
  s[0149] := 'The search request has been generated. The next time' + Chr(13)
             + 'you poll (Send and receive mails), the search' + Chr(13)
             + 'will be processed and you can get the results a short time' + Chr(13)
             + 'after (poll again).';

  s[0150] := 'The logfile is smaller than 300 KB, so it' + Chr(13)
             + 'is not neccessary to cut it.';
  s[0151] := 'Logfile doesn�t exist.';
  s[0152] := 'Size of the logfile: %s KB';
  s[0153] := 'Logfile';
  s[0154] := 'Cut logfile';
  s[0155] := 'Back';

  s[0156] := 'Please insert the Fido-Package deluxe CD and click again on "Other".';
  s[0157] := 'Pictures';

  s[0158] := ' Fido Infos';
  s[0159] := '    Fido Infos';
  s[0160] := '     Your node�s infos';
  s[0161] := '     Golded manual';
  s[0162] := '    Other';
  s[0163] := ''; // wird nicht mehr ben�tigt
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

  s[0215] := ''; // wird nicht mehr ben�tigt

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

  s[0235] := ''; // wird nicht mehr ben�tigt
  s[0236] := ''; // wird nicht mehr ben�tigt
  s[0237] := ''; // wird nicht mehr ben�tigt
  s[0238] := ''; // wird nicht mehr ben�tigt
  s[0239] := ''; // wird nicht mehr ben�tigt

  s[0240] := '    Configuration                                  ';
  s[0241] := 'Other';

  s[0242] := 'There are new infos from your node.' + Chr(13)
             + 'To see them click on "Info about Fido, Help ..."' + Chr(13)
             + 'and then on "Your node�s infos".';

  s[0243] := 'The window with the IRC chat is still open.' + #13
             + 'Really quit?';
  s[0244] := 'Chat with other Fido users..';

  s[0245] := ''; // wird nicht mehr ben�tigt

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

  s[0016] := 'Passwort f�r %s:';
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
             + 'Nach der Installation findest Du im Hauptmen� unter dem '
             + 'Men�punkt "Infos zu Fido, Hilfe ..." ein Handbuch '
             + 'zu diesem Fido-Paket und weitere interessante Informationen.' + #13
             + #13
             + 'Dein erster Schritt wird vermutlich sein, da� Du Dir ein paar '
             + 'Areas (auch Echo genannt) anbestellst, dies geht im Men� "Echo '
             + 'an- oder abbestellen". Wenn Du Dich z.B. f�r Star Trek '
             + 'interessierst, dann m�chtest Du vielleicht die Startrek.ger '
             + 'anbestellen (das ".ger" steht f�r German, also deutsch). Oder '
             + 'Witze (Jokes.Ger)? PC-Hardware (Hardware.ger)? Es '
             + 'gibt sehr viele interessante Areas, schau also gleich mal in '
             + 'die Liste und bestell Dir die eine oder andere an, die Du magst.';

  s[0027] := 'Installatie van Fido-Pakket deluxe';
  s[0028] := 'Naam';
  s[0029] := 'Bitte Vornahme-Nahme ingeben';
  s[0030] := 'Gemeente';
  s[0031] := 'Telefoon';
  s[0032] := 'Please enter area code and phone number, seperated by a dash';
  s[0033] := ''; // wird nicht mehr ben�tigt
  s[0034] := ''; // wird nicht mehr ben�tigt
  s[0035] := ''; // wird nicht mehr ben�tigt
  s[0036] := '(Internet-) Verbinding over het telefoonnetwerk wordt aangemaakt met:';
  s[0037] := ''; // wird nicht mehr ben�tigt
  s[0038] := ''; // wird nicht mehr ben�tigt
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

  s[0053] := 'Das DF� Netzwerk ist nicht installiert, es wurde jedoch' + Chr(13)
             + 'eine Internet-Verbindung erkannt. Daher kann mit der' + Chr(13)
             + 'Installation fortgefahren werden, allerdings wird es nur' + Chr(13)
             + 'm�glich sein, Internet-Verbindungen herzustellen.';

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

  s[0081] := 'Es d�rfen keine Leerzeichen (spaces, " ") im Pfad enthalten sein.'
             + Chr(13) + 'Verzeichnis: %s' + Chr(13)
             + Chr(13) + 'Bitte ein anderes Verzeichnis w�hlen.';
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
             + 'Bitte ein anderes Verzeichnis w�hlen.';

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

  s[0102] := 'Das DF� Netzwerk ist nicht installiert. Es wird jetzt nach einer aktiven Internet-Verbindung gesucht..';
  s[0103] := 'Internet-Verbindung steht, nicht weiter suchen';

  s[0104] := 'Fido-Pakket';

  s[0105] := 'CDN Datei nicht mehr gefunden.' + Chr(13)
             + 'Diese bitte nicht in das Installationsverzeichnis kopieren!';

  s[0106] := 'Das Fido-Paket deluxe ist nun deinstalliert.';
  s[0107] := 'Verwijderen';
  s[0108] := 'Ben je zeker dat je Fido-Pakket Deluxe wilt verwijderen?';

  s[0109] := '&Zeige Fido-Men�';
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

  s[0121] := 'Die Internet-Verbindung ist nicht verf�gbar.';
  s[0122] := 'Passwort:';

  s[0123] := 'Du hast neue (pers�nliche) Mail.' + Chr(13)
             + 'Netmails: %s' + Chr(13)
             + 'Echomail: %s';

  s[0124] := ''; // wird nicht mehr ben�tigt

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
  s[0163] := ''; // wird nicht mehr ben�tigt
  s[0164] := 'terug';
  s[0165] := 'verder';
  s[0166] := 'Afsluiten';

  s[0167] := 'AutoPoll: Alle %s'
             + ' Minuten automatisch pollen, wenn Fenster minimiert';
  s[0168] := 'Anzeige f�r AutoPoll; Angaben in Minuten';
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
  s[0183] := 'Gr�n';
  s[0184] := 'Cyan';
  s[0185] := 'Rot';
  s[0186] := 'Magenta';
  s[0187] := 'Braun';
  s[0188] := 'Grau';
  s[0189] := 'Hellgrau';
  s[0190] := 'Hellblau';
  s[0191] := 'Hellgr�n';
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
             + 'Adressaten ein Adressmakro f�r h�ufig verwendete Namen '
             + 'benutzen. Bei "An:" einfach das K�rzel eingeben, z.B. mh '
             + 'f�r Michael Haase, 2:2432/280.';

  s[0202] := 'Achtung: Die �nderung der Pointnummer und der Passw�rter sollte '
             + 'nur erfolgen, wenn man wei�, was man macht. Ansonsten kann dies '
             + 'dazu f�hren, da� keine Mails mehr empfangen oder versendet '
             + 'werden k�nnen!';
  s[0203] := 'Pointadresse';
  s[0204] := '(Bei �nderung wird die alte AKA abgemeldet!)';
  s[0205] := 'Session';
  s[0206] := 'Passwort';
  s[0207] := 'Areafix';
  s[0208] := 'Filemgr';
  s[0209] := 'Footer unter jeder Mail:';

  s[0210] := 'Fehler beim Lesen von %s aufgetreten' + Chr(13)
             + '(Datei nicht vorhanden oder nicht vollst�ndig)!' + Chr(13)
             + 'Deswegen k�nnen die Daten (Adresse und Passw�rter) nicht' + Chr(13)
             + 'ge�ndert werden.';

  s[0211] := 'Experten-Einstellungen';
  s[0212] := 'kein Proxy';
  s[0213] := 'IP Adresse';

  s[0214] := 'Die alte Pointnummer wird jetzt abgemeldet.';

  s[0215] := ''; // wird nicht mehr ben�tigt

  s[0216] := 'Gruppen im Editor (Golded):';
  s[0217] := 'Gruppenname hinzuf�gen';
  s[0218] := 'Gruppenname l�schen';
  s[0219] := 'Gruppenname �ndern';
  s[0220] := 'Vorhandene Areas:';
  s[0221] := 'selektierte Area geh�rt zu Gruppe:';
  s[0222] := 'Gruppenname';
  s[0223] := 'Neuer Gruppenname:';

  s[0224] := 'kein Logfile gefunden';

  s[0225] := 'Bitte den Dateinamen (oder einen Teil davon)  eingeben, '
             + 'nach dem gesucht werden soll, und Return dr�cken (oder '
             + 'auf OK klicken). Es k�nnen bis zu 3 Suchbegriffe '
             + 'eingegeben werden. Wichtig: Keine Wildcards (Sternchen '
             + 'oder Fragezeichen) erlaubt!';
  s[0226] := 'Suchbegriff:';
  s[0227] := 'Es werden Dateien mit diesen Suchbegriffen gesucht:';
  s[0228] := 'Hinweis: Die Suchanfrage wird zun�chst generiert. Die '
             + 'eigentliche Suche wird erst ausgef�hrt, wenn Du das n�chste '
             + 'mal pollst (Mails senden/empfangen).';
  s[0229] := 'Suchanfrage generieren';
  s[0230] := 'markierte Eintr�ge l�schen';
  s[0231] := 'Entf'; // Entfernen-Taste
  s[0232] := 'Ergebnisse anzeigen';

  s[0233] := 'Konfiguration';
  s[0234] := 'Pollen';

  s[0235] := ''; // wird nicht mehr ben�tigt
  s[0236] := ''; // wird nicht mehr ben�tigt
  s[0237] := ''; // wird nicht mehr ben�tigt
  s[0238] := ''; // wird nicht mehr ben�tigt
  s[0239] := ''; // wird nicht mehr ben�tigt

  s[0240] := '  Konfiguration                                     ';
  s[0241] := 'Sonstiges';

  s[0242] := 'Es gibt neue Infos von Deinem Node.' + Chr(13)
             + 'Um sie anzusehen klicke auf "Info''s over Fido, Help ..."' + Chr(13)
             + 'und dann auf "Info over je Nodes".';

  s[0243] := 'Das Fenster mit dem IRC-Chat ist noch offen.' + #13
             + 'Wirklich beenden?';
  s[0244] := 'Chatten mit anderen Fidoleuten..';

  s[0245] := ''; // wird nicht mehr ben�tigt

  s[0246] := 'Auf die Request-Datei (%s) konnte nicht zugegriffen werden.';
  s[0247] := 'Leere Passw�rter sind nicht erlaubt. Passwort-�nderung wird ignoriert.';

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
             + 'werden sofort gel�scht!)';

  s[0251] := 'Wegen r�der Sprache und Beleidigungen gegen�ber neuen Usern,' + #13
             + 'Rules, die dem Gesetz oder Fido Policies widersprechen' + #13
             + 'und dem Ausschluss von schwulen Leuten in den Rules, hat' + #13
             + 'diese Area einen eingeschr�nkten Zugriff! Wenn Du wirklich' + #13
             + 'sicher bist, da� Du diese Area anbestellen willst, dann solltest' + #13
             + 'Du bereits ein erfahrener Fido User sein, so dass Du wissen' + #13
             + 'solltest und musst, wie man diese Area manuell anbestellt.' + #13
             + 'Die Rules dieser Area wurden Dir gerade als Netmail erstellt,' + #13
             + 'Du kannst sie in Golded lesen.' + #13
             + '- NEC 2457, Michael Haase (2:2457/2)';

  s[0252] := 'Fenstergr��e (Anzahl Zeilen) von Golded (Editor):';

  s[0253] := 'Momentan ist "anderer Provider" als Internetverbindung' + #13
             + 'eingestellt. Wenn Du eine Netzwerkverbindung (LAN) ins' + #13
             + 'Internet hast, dann gab es bei der Installation keine' + #13
             + 'Auswahl daf�r. Bei Netzwerk (LAN) erfolgt keine Pr�fung' + #13
             + 'mehr, ob eine Internetverbindung besteht.' + #13
             + 'Soll auf Netzwerkverbindung (LAN) umgestellt werden?';
  s[0254] := 'lokales Netzwerk (LAN) = keine Onlinepr�fung';

  s[0255] := 'Alte Installation gefunden. Sollen diese Daten f�r die' + #13
             + 'Installation benutzt werden (also keine Neuanmeldung)?';

  s[0256] := 'alle anbestellten Echos neu bestellen';
  s[0257] := 'Liste erstellt, beim n�chsten Pollen ("Mails senden' + #13
             + 'und empfangen") wird die Anbestellung gesendet.';
  s[0258] := '(bei Win 95/98/ME gehen nur 25, 43 oder 50 Zeilen)';
  s[0259] := 'Node Name';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := 'Die eingegebene Pointadresse ist ung�ltig!' + #13
             + 'Sie mu� im Format z:nnnn/nnnn.ppppp sein,' + #13
             + 'z.B. "2:2457/280.13" oder "2:2457/280.0".';
  s[0262] := 'Aktualisiere Liste';
  s[0263] := 'Liste aktualisiert.';
  s[0264] := 'Verbindung fehlgeschlagen. Internet-Verbindung aktiv?';
  s[0265] := 'Transaktion fehlgeschlagen.';
  s[0266] := 'Ung�ltiger Host.';
  s[0267] := 'Aktualisieren der Liste';
  s[0268] := 'Aktuelle Liste aus Internet laden';
  s[0269] := 'Liste von Festplatte �ffnen';
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
  s[0281] := 'Bitte pr�fe die eingegebenen Daten doppelt,' + #13
             + 'bei falschen Daten funktioniert es nicht!';
  s[0282] := 'Node-Nummer (_nicht_ komplette AKA!) (optional):';
  s[0283] := 'Angaben nicht vollst�ndig!';
  s[0284] := 'Auswahl-Liste fehlerhaft, Standard-Liste wird verwendet.';
  s[0285] := 'Proxy ggf. auf der vorigen Seite eintragen. Internet-Verbindung muss bereits bestehen!';
  s[0286] := 'Name des Nodes:';
  s[0287] := 'Komplette Node-Adresse (z.B. 2:2432/280):';
  s[0288] := 'DNS/IP (z.B. fido.dyndns.org):';
  s[0289] := '### Anderer Node (Daten selber eingeben)'; // muss mit '#' beginnen! (wegen Sortierung der Liste)
  s[0290] := '    Problem-Pr�fung';
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
  s[0001] := '����-����� ������';
  s[0002] := '��������� ����-������ ������';
  s[0003] := '����-����� ������, ���������';
  s[0004] := '����� ���������� � ����������� ����-������ ������' + Chr(13)
           + '%s, ����� Michael Haase (m.haase@gmx.net)';
  s[0005] := '�������� � ����� ������ �������: http://www.fido-deluxe.de.vu';
  s[0006] := '������ ���������� ����-����� ������ ����� ������?';
  s[0007] := '&��������';
  s[0008] := '&��';
  s[0009] := '&�������� ���������';

  s[0010] := '����������, ���������, ��� ���������� � ����� �������,';
  s[0011] := '����������, ���������, ��� �� ������������ � ���� ��������,';
  s[0012] := '����������, ���������, ��� ���������� � ���������� ������ � �������������,';
  s[0013] := '����������, �������� ����� / ���������� ISDN,';
  s[0014] := Chr(13) + '���������� ������� ���������� � ����� �� ����������' + Chr(13)
             + '����-�������.';

  s[0015] := '���������� � ����� �������� �� ���� �������.';

  s[0016] := '������ ��� %s:';
  s[0017] := '��������-c��������� ';

  s[0018] := '��� ������� ����������, ���������� ����' + Chr(13)
             + '��������� �� �����/������� �����.' + Chr(13)
             + '������ ��� �������: �������(poll)' + Chr(13)
             + '���������: %s';

  s[0019] := '���������� �����������.';

  s[0020] := '������:';
  s[0021] := '��� ����������� � ����..';

  s[0022] := '��������� ������������ ���������.' + Chr(13)
             + '� ���� ����� � �� ������� ����� ���' + Chr(13)
             + '������ ����� (Fido-menu).';

  s[0023] := '�������� ������.' + Chr(13)
             + '����� ������: %s' + Chr(13)
             + '��������: �������(poll)';

  s[0024] := '���������� ���������. ��������,' + Chr(13)
             + '��� ��������� ����.' + Chr(13)
             + '�������� � ���������� �����.' + Chr(13)
             + '��� ���������� ���������� ������ ���������� ���-����' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';

  s[0025] := '������� �������� ������(CDN). ��� ������: %s';
  sprache_Fehlercode := '��� ������'; // mu� mit ^^^^^^^^^^ �bereinstimmen!

  s[0026] := '������ ����������� ������������ ����������.' + #13
             + '������ �������� ������ �������� ���, ��� ���� '
             + '���������� �������� ����������� ���������.' + #13
             + #13
             + '�� ��������� ��������� ������������ �� ������ � ������� ����, '
             + '����� "���������� � ����, ������, ..." ���������� ���������� '
             + '��������� ��� ��.' + #13
             + #13
             + '��� ������ ��, ���������, ����������� �� ���� '
             + '�� (Echo/Area), ��� ����� ����������� � ���� "�����������, '
             + '���������� �� ��". ���� ��� ���������� Linux, �� '
             + '����� ����� �������� RU.LINUX; � RU.HUMOR.FILTERED ������ '
             + '���� ��� ��� ����������. ���������� �������� � RU.CHAINIK.';

  s[0027] := '��������� ����-������ ������';
  s[0028] := '���';
  s[0029] := '������� ��� � �������';
  s[0030] := '�����';
  s[0031] := '�������';
  s[0032] := '����������, ������� ��� ������ � ������ ��������, ��������� ������ �����';
  s[0033] := ''; // wird nicht mehr ben�tigt
  s[0034] := ''; // wird nicht mehr ben�tigt
  s[0035] := ''; // wird nicht mehr ben�tigt
  s[0036] := '(��������-)����������� �� ��������� ���������� �:';
  s[0037] := ''; // wird nicht mehr ben�tigt
  s[0038] := ''; // wird nicht mehr ben�tigt
  s[0039] := '������������ �������';
  s[0040] := '������������ ��: ';
  s[0041] := '�������� ������� ��� &���������';
  s[0042] := '������� ���������: %s' + ':\FIDO';
  s[0043] := '� �������� ������ ��������� �� ��������� ��������:';
  s[0044] := '�������      �����                                            ��� ������';
  s[0045] := '&������ ���������';
  s[0046] := '&�������� (���������)';

  s[0047] := '�����������(poll)';
  s[0048] := '������� ��������� ����������...';
  s[0049] := '������ ����������:';
  s[0050] := '��������';

  s[0051] := '��������� ���� CDN �� ��� ������:' + Chr(13)
             + '%s';
  s[0052] := '����������, ������� ������ ���� � ����� CDN!' + chr(13)
             + '(��������: c:\primer\primer.cdn)';

  s[0053] := '���� �������� ������ �� ����������, ���������� � �����' + Chr(13)
             + '�������� ���� ����������. �� ������ ���������� ���������,' + Chr(13)
             + '������ ��������, ��� ��� ������� ������������ �������' + Chr(13)
             + '����������� � ���� ��������.';

  s[0054] := '�������� ������ �� ����������, ������ �� ���������.' + Chr(13)
             + '�������� ��� ���������/������ ����������, �����' + Chr(13)
             + '��������� ��������/��������� Windows � �������� �������� ������.' + Chr(13)
             + '�� ��������� ��������� ��������� ��������� ����-������ ������.';
  s[0055] := '�� ����� ��������� �������� ������';

  s[0056] := '���������� � ����� ��������';

  s[0057] := '� �������� ������� �� ���������� �����,' + Chr(13)
             + '���� ISDN ����������.' + Chr(13)
             + '��������� ��� � �������������' + Chr(13)
             + '��������� ��������� ����-������ ������.';

  s[0058] := '��� ������� �������� ����� ���������� � �������� �������' + Chr(13)
             + '�������� ����������� ������.' + Chr(13)
             + '��������� ����� ����������';

  s[0059] := '������������ ��: %s';

  s[0060] := '������ ��� ������� ������� ���� "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + '����� ������: %s';

  s[0061] := '������������� ���������� ��� �� ��� ������.';
  s[0062] := '������ ��� �����';
  s[0063] := '�� ���� ������� ���.';
  s[0064] := '���, ���� ������� ������� �� ���������.';
  s[0065] := '�� ������ �����.';
  s[0066] := '������ �������������� �����.';
  s[0067] := '����� �������� �� ��� ������.';
  s[0068] := '��� ������, ���������� ��������� ������ "-",' + Chr(13)
             + '��������: 03452-249044';
  s[0069] := '������ �������� ����� ��������.';
  s[0070] := '� ���� ����� �������� ����������� ������ �����.' + Chr(13)
             + '�� ������ �������� ��� ������.';

  s[0071] := '�� ��������� ����' + Chr(13)
             + '����� (%s' + ':) ������������ �����.' + Chr(13)
             + '��� ��������� ��������� ������� 20 ��������.';

  s[0072] := 'Fido-menu';
  s[0073] := '���������� �� �������� � ����';
  s[0074] := '������� ����-����� ������.';

  s[0075] := '������� �� ��������, ��������, ��������� ����.' + Chr(13)
             + '����������� ��� ���.' + Chr(13)
             + '��� ���������� ���������� ����� ���������� ���-����' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';
  s[0076] := '����� ������� � ��������� ����-������� �������������'
             + Chr(13) + '�� �������:' + Chr(13);
  s[0077] := '�������� ������ ����-�������,'
             + Chr(13) + '���� �������� ������ ����-�������.';

  s[0078] := '������� ��� ������������� ����� ����������� ������?';
  s[0079] := '��������� ��������';
  s[0080] := '��� ��� ������������� ����� �������.';

  s[0081] := '� ����� ���� �� ����������� ����� �������(" ").'
             + Chr(13) + '�������: %s' + Chr(13)
             + Chr(13) + '�������, ����������, ������ �������.';
  s[0082] := '��������� ��� ��������� ������� ��� ����������.'
             + Chr(13) + '�������: %s' + Chr(13)
             + '*** ��� ����� � ����������� ����� �������! ***'
             + Chr(13) + Chr(13)
             + '�� �������?';
  s[0083] := '��������������';

  s[0084] := '������� ��� ���������: %s';

  s[0085] := '������ ��������-���������';

  s[0086] := '���������� ��������� ������ �� ����������.'
             + Chr(13) + '�������: %s'
             + Chr(13) + '������� ����: point.cdn'
             + Chr(13) + Chr(13)
             + '����������, �������� ������ �������.';

  s[0087] := '���������� ������������ ���������.';

  s[0088] := '����-����� ������ (10 ��) ���������������.' + Chr(13)
             + '����������, ���������.';

  s[0089] := '������������� �������� ���������?';
  s[0090] := '��������';
  s[0091] := '������� ��� ������������� �����?';
  s[0092] := '��� ��� ������������� ����� �������.';

  s[0093] := '������� ����� �� ��������� �������� ������';
  s[0094] := '��������-����������';
  s[0095] := '��� ����� ���������� � ����������� �� ������� �������' + Chr(13)
             + '�������� ����������� ������.' + Chr(13);
  s[0096] := '����� ������: %s' + Chr(13)
             + '����������, ��������������� ������:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := '��� ��������� ������ �������� ����������� ������.' + Chr(13);
  s[0098] := '����� ����� ��� ISDN capi �� �������';

  s[0099] := 'isdn'; // nicht �ndern!
  s[0100] := 'modem'; // nicht �ndern!
  s[0101] := 'Kommunikationskabel'; // nicht �ndern!

  s[0102] := '�������� ������ �� ����������. ����� ��������� ����� ��������� ���������� � ����� ��������..';
  s[0103] := '���������� � ����� �������� �������, ���������� ����� �� ���������';

  s[0104] := '����-�����';

  s[0105] := '� ���� ��� CDN ���� �� ������.' + Chr(13)
             + '����������, �� ��������� ��� � ������� ���������!';

  s[0106] := '����-����� �����.';
  s[0107] := '�������';
  s[0108] := '�� ����� ���� ������� ����-����� ������?';

  s[0109] := '&���������� ����';
  s[0110] := '&���������';

  s[0111] := ' ������� ���� (����-����� ������)';
  s[0112] := '����-����� ������ %s' + Chr(13)
             + '         �� Michael Haase';
  s[0113] := '  ����� �������/��������� (������)   ';
  s[0114] := ' ��������� ��������/�������� (��������) ';
  s[0115] := '   �����������/���������� �� ��       ';
  s[0116] := '  ����� ����� � ������ ����-�������         ';
  s[0117] := '  ���-����� ����������/�������              ';
  s[0118] := '  ���������� � ����, ������ ...             ';
  s[0119] := '  ���������';
  s[0120] := '  ������!';

  s[0121] := '��������-���������� ����������.';
  s[0122] := '������:';

  s[0123] := '���� ����� (������) �����.' + Chr(13)
             + '�����: %s' + Chr(13)
             + '���������: %s';

  s[0124] := ''; // wird nicht mehr ben�tigt

  s[0125] := '�������� ������.' + Chr(13)
             + '����� ������: %s' + Chr(13)
             + '��������: ��������';

  s[0126] := '�� ������������� ������ �������� ����' + Chr(13)
             + '� ���������� ��� ���� ��?';
  s[0127] := '����������?';

  s[0128] := '���������� ���������� ��: %s';

  s[0129] := '������� ����� �� �������.';
  s[0130] := '�����';
  s[0131] := '������� ����� ����� ������� �� ����.';

  s[0132] := '������������� �������� (��� ������������ ��������� ��������)?';

  s[0133] := '���������� ��������� �������� ��: %s';

  s[0134] := ' ������������ ��';
  s[0135] := '��� ����, ����� ��������� ��� �������� ���, ���������� �������� ������� ���� �� ���.';
  s[0136] := '����� ��:';
  s[0137] := '   ��������';
  s[0138] := '    ������������';
  s[0139] := '   ���������';
  s[0140] := '    ������������';
  s[0141] := '������� �����';
  s[0142] := '�����';
  s[0143] := '���������� �����';
  s[0144] := 'OK';

  s[0145] := '���������� ��������� ������������ �������� ��: %s';
  s[0146] := '���������� ��������� �� �� BBS: %s';
  s[0147] := '���������� ��������� (������������) ��: %s';

  s[0148] := '������������� �������� (������ �� ����� �� ����� ������)?';
  s[0149] := '������ �� ����� ��� ������. ��� ��������' + Chr(13)
             + '������� (����� � �������� �����), �����' + Chr(13)
             + '����� ��������� � ���� ������ ���������' + Chr(13)
             + '����� ����� �������� (��� ��� �������������).';

  s[0150] := '���-���� ����� 300 KB, ������� ���' + Chr(13)
             + '�� ���������.';
  s[0151] := '���-���� �����������.';
  s[0152] := '������ ���-�����: %s ��';
  s[0153] := '���-����';
  s[0154] := '������� ���-����';
  s[0155] := '�����';

  s[0156] := '����������, �������� ���� � ����-����� ������ � ������� ��� ��� �� "�������������".';
  s[0157] := '�����������';

  s[0158] := ' ����-����������';
  s[0159] := '    ���������� � ����';
  s[0160] := '     ������ ����� ����';
  s[0161] := '     ������������ �� GoldEd';
  s[0162] := '    �������������';
  s[0163] := ''; // wird nicht mehr ben�tigt
  s[0164] := '�����';
  s[0165] := '�����';
  s[0166] := '�������';

  s[0167] := '����������: ������ %s ����� ��� ��������� ���� ������������� �������������';

  s[0168] := '��������� �����������; ����������� � �������';
  s[0169] := '��������-���������:';

  s[0170] := '�� ��� ��� ������� RAS (�������� ������) ���� ����������.' + Chr(13)
             + '��-�� ��������� ����������.' + Chr(13)
             + '��� ��������� ������, �������� ������:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';

  s[0171] := '����������';
  s[0172] := '����� � ���������';
  s[0173] := '������';
  s[0174] := '������� ��������';
  s[0175] := '������';
  s[0176] := '�������';
  s[0177] := '����������';

  s[0178] := '�����';
  s[0179] := '������';
  s[0180] := '���';
  s[0181] := '׸����';
  s[0182] := '�����';
  s[0183] := '������';
  s[0184] := '����';
  s[0185] := '�������';
  s[0186] := '�������';
  s[0187] := '����������';
  s[0188] := 'Ҹ���-�����';
  s[0189] := '������-�����';
  s[0190] := '������-�����';
  s[0191] := '������-������';
  s[0192] := '������� ����';
  s[0193] := '������-�������';
  s[0194] := '������� �������';
  s[0195] := 'Ƹ����';
  s[0196] := '�����';

  s[0197] := '����� ������ ������ ��������� � � ���������� '
             + '��������� �� �������� ��������.' + Chr(13)
             + '�� ��� ������ ��� (URLs):';

  s[0198] := '������';
  s[0199] := '������';
  s[0200] := '�������������';

  s[0201] := '� GoldEd (��������) ��� ��������� ������ ����� '
             + '������������ ������� �������� ��� �������� ������ �����������. '
             + '� ���� "���:" ������ ������ ����������, ��������,  mh '
             + '��� Michael Haase, 2:2432/280.';

  s[0202] := '��������: ����� ������ ������ � ������ ������ ������������� '
             + '������ � ������, ���� �� ����� ������, ��� �������. '
             + '����� ����� ���������, ��� �� �� ������� �� ���������, '
             + '�� ������� �����!';
  s[0203] := '����� address';
  s[0204] := '(��� ��������� ������ AKA ����� ���� � �����!)';
  s[0205] := '������';
  s[0206] := '������';
  s[0207] := 'AreaFix';
  s[0208] := 'Filemgr';
  s[0209] := '������ ��� ������ �������:';

  s[0210] := '��� ������ %s �������� ������' + Chr(13)
             + '(���� �����������, ��� ��������)!' + Chr(13)
             + '� ����� � ���� ������ (������ � ������)' + Chr(13)
             + '�� ����� ���� ��������.';

  s[0211] := '��������� �� ��� ����������';
  s[0212] := '��� ������-�������';
  s[0213] := 'IP �����';

  s[0214] := '������ ����� ������ ����� ���� � �����.';

  s[0215] := ''; // wird nicht mehr ben�tigt

  s[0216] := '������ � ��������� (GoldEd):';
  s[0217] := '�������� ��� ������';
  s[0218] := '������� ��� ������';
  s[0219] := '�������� ��� ������';
  s[0220] := '��������� ���:';
  s[0221] := '��������� ��� ��������� � ������:';
  s[0222] := '��� ������';
  s[0223] := '����� ��� ������:';

  s[0224] := '���-���� �� ������';

  s[0225] := '����������, ������� ��� �������� ����� (��� ��� �����), '
             + '����� ������� Enter (����� '
             + '������ �� OK). ����������� �� ��� ������� ����.'
             + '�����: ����������� (������ "*" '
             + '� �������������� ����) �� �����������!';
  s[0226] := '������� �����:';
  s[0227] := '����� ������, ���������� ��������� �����:';
  s[0228] := '���������: ������ ����� �������� ������ �� �����. '
             + '������������� ����� ����� ���������� ���� ��� '
             + '���������� ������� (��������/����� �����).';
  s[0229] := '������� ������ �� �����';
  s[0230] := '������� ���������� ��������';
  s[0231] := 'Del'; // Entfernen-Taste
  s[0232] := '�������� ���������';

  s[0233] := '������������  ';
  s[0234] := '������';

  s[0235] := ''; // wird nicht mehr ben�tigt
  s[0236] := ''; // wird nicht mehr ben�tigt
  s[0237] := ''; // wird nicht mehr ben�tigt
  s[0238] := ''; // wird nicht mehr ben�tigt
  s[0239] := ''; // wird nicht mehr ben�tigt

  s[0240] := '  ������������                                    ';
  s[0241] := '������';

  s[0242] := '���� ����� ���������� �� ����� ����.' + Chr(13)
             + '����� � �������, ����� "Infos zu Fido, Hilfe ..."' + Chr(13)
             + ' � �������� "���������� � ����� ����".';

  s[0243] := '���� � IRC-����� ��� �������.' + #13#10
             + '������������� �������?';
  s[0244] := '������������ � ���� � ������� �����������..';

  s[0245] := ''; // wird nicht mehr ben�tigt

  s[0246] := '� ����� ������� (%s) �� ���� �������.';
  s[0247] := '������ ������ �����������. ��������� ������ ���������������.';

  s[0248] := '������������!' + #13#10
             + #13#10
             + '����� ���������� � ����. ��������� �������������� ����������� '
             + '�� ������ ���������� �������� ��� � ������ �����. ��� ����� �� �������� '
             + '��������� ��� ���������� ��������� � ����� ����� ( ��� ���������, '
             + '� �������� �� ������ ��� ������������������). ������ ������ �������� '
             + '�� ��� ������ (������� ������� "q" � ��� ���� Enter, ����� �������� ����� '
             + '������, �� ��������� ������� ALT-S � ��� ��� Enter ��� '
             + '����������). �����, � ������� ���� �������� �����'
             + '"����� �������/��������� (������)". ������ ����� ����������.' + #13#10
             + #13#10
             + '����� ���� ����� ��������� ������� ��� ��������� e-mail:' + #13#10
             + #13#10
             + '���: %s' + #13#10
             + '�������: %s' + #13#10
             + 'e-mail: %s' + #13#10
             + #13#10
             + #13#10
             + '������������ � ����� ����-������, � ��� �� �������������� ���������� ��������� '
             + '� ������� ����, ����� "���������� � ����, ������, ...".' + #13#10
             + #13#10
             + '���� �� �� ������� � ������� ������� ����� �������� ����� (������), '
             + '����������, �������� �� ���� ����� ����, ����� ��� ������������� '
             + '������ �� ������� �� ��������� �������� 100 ���� �����������.' + #13#10
             + #13#10
             + '���� � ������, ������ ��� ����� �������� �� ���� ����-������?' + #13#10
             + #13#10
             + '��������� �������������������..' + #13#10
             + #13#10
             + '(��� ������ ���������� ������������� ����-������� '
             + '������ %s.)' + #13#10;

  s[0249] := '���� �� ��� ���������� Acrobat Reader ��� ������ PDF ����������. '
             + '��� ����� ������� �� ������:' + #13
             + 'www.adobe.com/products/acrobat/readstep2.html' + #13
             + '(���� �� � ��� ���� ���� � ����-�������, �� �� ��������� � ��������'
             + '\sonst\andere-programme\acrobat-reader 5\)' + #13
             + #13
             + '������������ �������� ��� �� � � ������� RTF. Ÿ ����� ����� �� '
             + '��������. ����������� ��� �� ����� ������:' + #13
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

  s[0252] := '������ ���� (����� �����) GoldEd (���������):';

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

  sprache_Hinweis := '��������';
  sprache_Fehler := '������';
  sprache_Info := '����������';
end;

procedure spanisch_strings_initialisieren;
begin
  s[0001] := 'Fido-Package deluxe';
  s[0002] := 'Instalaci�n de Fido-Package deluxe';
  s[0003] := 'Fido-Package deluxe - Instalaci�n';
  s[0004] := 'Bienvenido al programa de instalaci�n de Fido-Package deluxe' + Chr(13)
             + '%s, por Michael Haase (m.haase@gmx.net)';
  s[0005] := 'La p�gina con la �ltima versi�n es: http://www.fido-deluxe.de.vu';
  s[0006] := '�Quieres instalar Fido-Package deluxe, ahora?';
  s[0007] := '&Actualizar';
  s[0008] := '&Si';
  s[0009] := '&Salir';

  s[0010] := 'Now, please make sure that the network connection is online, it';
  s[0011] := 'Now, please make sure that the internet connection is online, it';
  s[0012] := 'Now, please make sure that the internet connection is ready to use, it';
  s[0013] := 'Now, please turn on the modem / ISDN device, it';
  s[0014] := Chr(13) + 'se intentar� establecer conexi�n con el sysop de FidoNet' + Chr(13)
             + 'seleccionado.';

  s[0015] := 'No se ha reconocido ninguna conexi�n a internet.';

  s[0016] := 'Clave para %s:';
  s[0017] := 'Internet connection';

  s[0018] := 'Ocurri� un error estableciendo la conexi�n, la' + Chr(13)
             + 'conexi�n se cort� antes de enviar y recibir el correo.' + Chr(13)
             + 'Error en acci�n: Llamada' + Chr(13)
             + 'Mensaje: %s';

  s[0019] := 'Conexi�n establecida.';

  s[0020] := 'Estado:';
  s[0021] := 'El registro en Fido se est� realizando..';

  s[0022] := 'Instalaci�n terminada satisfactoriamente.' + Chr(13)
             + 'Un enlace ha sido creado en el menu inicio y' + Chr(13)
             + 'en el escritorio (Fido-Menu).';

  s[0023] := 'Ha habido un error.' + Chr(13)
             + 'C�digo de error: %s' + Chr(13)
             + 'Acci�n: Llamada';

  s[0024] := 'Conexi�n fallida. Quiz�s se puede deber a' + Chr(13)
             + 'un error temporal. Int�ntalo m�s tarde.' + Chr(13)
             + 'Para m�s informaci�n deber�s mirar' + Chr(13)
             + 'el fichero log (%s' + '\binkley\binkd.log).';

  s[0025] := 'Faulty data (CDN) received. Error code: %s';
  sprache_Fehlercode := 'Error code'; //  ^^^^^^^^^^ must be this!

  s[0026] := 'Los datos de registro han sido enviados con� xito.' + #13
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

  s[0027] := 'Instalaci�n de Fido-Package deluxe';
  s[0028] := 'Nombre';
  s[0029] := 'Introduce tu nombre y apellidos';
  s[0030] := 'Localidad';
  s[0031] := 'Tel�fono';
  s[0032] := 'Introduce prefijo y n�mero de tel�fono separado por un gui�n';
  s[0033] := ''; // wird nicht mehr ben�tigt
  s[0034] := ''; // wird nicht mehr ben�tigt
  s[0035] := ''; // wird nicht mehr ben�tigt
  s[0036] := '(Internet-) Connect via Dial-Up Network with:';
  s[0037] := ''; // wird nicht mehr ben�tigt
  s[0038] := ''; // wird nicht mehr ben�tigt
  s[0039] := 'Sistema operativo';
  s[0040] := 'Reconocido el sistema operativo: ';
  s[0041] := 'Escoge el directorio de instalaci�n';
  s[0042] := 'Directorio de instalaci�n: %s' + ':\FIDO';
  s[0043] := 'Registrarse como miembro de Fido (Punto) en el siguiente nodo:';
  s[0044] := 'Telf.            Localidad                                      Sysop';
  s[0045] := 'Empezar &instalaci�n';
  s[0046] := '&Abortar (Salir)';
  s[0047] := 'Llamada';
  s[0048] := 'La conexi�n se est� The connection is establishing...';
  s[0049] := 'Estado de la conexi�n:';
  s[0050] := 'Abortar';

  s[0051] := 'El fichero CDN no ha sido encontrado:' + Chr(13)
             + '%s';
  s[0052] := '�Introduce la ruta completa del fichero CDN!' + chr(13)
             + '(ej.: c:\ejemplo\ejemplo.cdn)';

  s[0053] := 'The Dial-Up Network is not installed, but an internet connection.' + Chr(13)
             + 'is detected. So, you may proceed installation, but you will' + Chr(13)
             + 'only be able to use internet connections.';

  s[0054] := 'The Dial-Up Network is not installed, but is required.' + Chr(13)
             + 'Please install it by selecting Software / Windows-Setup' + Chr(13)
             + 'found in My Computer / Control Panel, and start again' + Chr(13)
             + 'the installation of the Fido-Package deluxe, then.';
  s[0055] := 'Error durante la instalaci�n';

  s[0056] := 'internet connection';

  s[0057] := 'There is no modem or ISDN device installed in the Dial-Up Network.' + Chr(13)
             + 'Please do it and then start again the installation of' + Chr(13)
             + 'the Fido-Package deluxe.';

  s[0058] := 'It occurred an unknown error by creating a new' + Chr(13)
             + 'connection in the Dial-Up Network.' + Chr(13)
             + 'Installation is stopped.';

  s[0059] := 'Sistema operativo reconocido: %s';

  s[0060] := 'Error abriendo el fichero "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + 'C�digo de error: %s';

  s[0061] := 'No se ha introducido el prefijo internacional.';
  s[0062] := 'Error in input';
  s[0063] := 'No se ha introduce el nombre.';
  s[0064] := 'El nombre dado no est� completo.';
  s[0065] := 'No se ha introducido la localidad.';
  s[0066] := 'La localidad dada no es v�lida.';
  s[0067] := 'No se ha introducido el n�mero de tel�fono.';
  s[0068] := 'Please separate area code from phone number with "-",' + Chr(13)
             + 'for example: 02732-12345';
  s[0069] := 'El n�mero de tel�fono dado no es v�lido.';
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
             + Chr(13) + 'por el momento. La raz�n dada:' + Chr(13);
  s[0077] := 'Por favor, det�n la instalaci�n de  Fido-Package deluxe, o'
             + Chr(13) + 'escoje otro nodo de Fido.';

  s[0078] := '�Deber�n ser borrados los ficheros instalados?';
  s[0079] := 'Abortar la instalaci�n';
  s[0080] := 'Todos los ficheros instalados ser�n borrados.';

  s[0081] := 'No debe haber ning�n espacio (" ") en la ruta.'
             + Chr(13) + 'Directorio: %s' + Chr(13)
             + Chr(13) + 'Por favor, escoge otro directorio.';
  s[0082] := 'El directorio seleccionado ya existe.'
             + Chr(13) + 'Directorio: %s' + Chr(13)
             + '*** �Todos los ficheros y subdirectorios ser�n borrados! ***'
             + Chr(13) + Chr(13)
             + '�Seguro?';
  s[0083] := 'Cuidado';

  s[0084] := 'Directorio de instalaci�n: %s';

  s[0085] := 'other internet provider';

  s[0086] := 'No se encontr� instalaci�n atigua.'
             + Chr(13) + 'Directorio: %s'
             + Chr(13) + 'Fichero buscado: point.cdn' + Chr(13)
             + Chr(13) + Chr(13)
             + 'Por favor, escoge otro directorio.';

  s[0087] := 'Actualizaci�n finalizada correctamente.';

  s[0088] := 'Fido-Package deluxe (10 MB) va a ser instalado.' + Chr(13)
             + 'Por favor, espera.';

  s[0089] := '�Realmente quieres abortar la instalaci�n?';
  s[0090] := 'Abortar';
  s[0091] := '�Deben ser borrados los ficheros instalados?';
  s[0092] := 'Todos los ficheros instalados han sido borrados.';

  s[0093] := 'network card = no dial-up connection';
  s[0094] := 'internet connection';
  s[0095] := 'An unexpected error occurred by gathering the connections' + Chr(13)
             + 'in the Dial-Up Network.' + Chr(13);
  s[0096] := 'C�digo de error: %s' + Chr(13)
             + 'Por favor, inf�rma de ello al autor:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := 'An unexpected error occurred by allocating memory.' + Chr(13);
  s[0098] := 'no se encontr� modem o RDSI';

  s[0099] := 'rdsi'; // do not change!
  s[0100] := 'modem'; // do not change!
  s[0101] := 'Kommunikationskabel'; // do not change until you know what you do!

  s[0102] := 'The Dial-Up Network is not installed. Now, an active internet connection is searched..';
  s[0103] := 'Internet connection is active, don�t search anymore';

  s[0104] := 'Fido-Package';

  s[0105] := 'CDN file no longer found.' + Chr(13)
             + 'Please do not copy it in the installation directory!';

  s[0106] := 'Fido-Package deluxe est desinstalado ahora.';
  s[0107] := 'Desinstalar';
  s[0108] := '�Realmente quieres desinstalar Fido-Package deluxe?';

  s[0109] := '&Mostrar Men� Fido';
  s[0110] := 'S&alir';

  s[0111] := ' Men� principal (Fido-Package deluxe)';
  s[0112] := 'Fido-Package deluxe %s' + Chr(13)
             + '          por Michael Haase';
  s[0113] := '  Enviar y recibir correo (Llamar)      ';
  s[0114] := '  Leer y escribir correo (Editor)          ';
  s[0115] := '   Dar areas de alta o baja               ';
  s[0116] := '  Buscar ficheros en la lista de ficheros del servidor';
  s[0117] := '  Ver y cortar los ficheros de "log"                      ';
  s[0118] := '    Informaci�n sobre Fido, ayuda, ...  ';
  s[0119] := '  Salir    ';
  s[0120] := '  Reportar errores (Bug)';

  s[0121] := 'La conexi�n a internet no est� disponible.';
  s[0122] := 'Clave:';

  s[0123] := 'Tienes nuevo correo (personal).' + Chr(13)
             + 'Netmails: %s' + Chr(13)
             + 'Echomail: %s';

  s[0124] := ''; // wird nicht mehr ben�tigt

  s[0125] := 'Ha ocurrido un error.' + Chr(13)
             + 'C�digo de error: %s' + Chr(13)
             + 'Acci�n: Editor';

  s[0126] := '�Quieres abortar tu registro en FidoNet y' + Chr(13)
             + 'cancelar tu suscripci�n para todas las areas?';
  s[0127] := '�Cancelar tu registro en FidoNet?';

  s[0128] := 'N�mero de areas que tienes conectadas: %s';

  s[0129] := 'Palabra clave de b�squeda encontrada.';
  s[0130] := 'Buscar';
  s[0131] := 'No further hits for the given search keyword.';

  s[0132] := 'Really abort (all changes become lost)?';

  s[0133] := 'N�mero de areas disponibles: %s';

  s[0134] := ' Administraci�n de areas';
  s[0135] := 'Para dar de baja un area pica dos veces sobre ella.';
  s[0136] := 'Selecci�n de areas:';
  s[0137] := '   principal';
  s[0138] := '    Norte-Am�rica';
  s[0139] := '   local';
  s[0140] := '    regional';
  s[0141] := 'Buscar por palabra';
  s[0142] := 'buscar';
  s[0143] := 'buscar siguiente';
  s[0144] := 'Aceptar';

  s[0145] := 'N�mero de areas de Norte-Am�rica disponibles: %s';
  s[0146] := 'N�mero de areas del BBS disponibles : %s';
  s[0147] := 'N�mero de areas regionales disponibles: %s';

  s[0148] := 'Really abort (don�t generate search request)?';
  s[0149] := 'The search request has been generated. The next time' + Chr(13)
             + 'you poll (Send and receive mails), the search' + Chr(13)
             + 'will be processed and you can get the results a short time' + Chr(13)
             + 'after (poll again).';

  s[0150] := 'El fichero log es menor de 300 KB, asi que' + Chr(13)
             + 'no es necesario cortarlo.';
  s[0151] := 'El fichero log no existe.';
  s[0152] := 'Tama�o del fichero log: %s KB';
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
  s[0163] := ''; // wird nicht mehr ben�tigt
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
  s[0187] := 'Marr�n';
  s[0188] := 'Gris';
  s[0189] := 'Gris claro';
  s[0190] := 'Azul claro';
  s[0191] := 'Verde claro';
  s[0192] := 'Cyan claro';
  s[0193] := 'Rojo claro';
  s[0194] := 'Magenta claro';
  s[0195] := 'Amarillo';
  s[0196] := 'Blanco';

  s[0197] := 'Puedes encontrar siempre la �ltima versi�n en la p�gina '
             + 'oficial.' + Chr(13)
             + 'Las direcciones (URLs) actuales son:';

  s[0198] := 'Negrita';
  s[0199] := 'Cursiva';
  s[0200] := 'Subrayado';

  s[0201] := 'In Golded (editor) you can use an address macro for writing '
             + 'a message to often used names. At "To:" simply enter the '
             + 'macro, e.g. mh for Michael Haase, 2:2432/280.';

  s[0202] := 'Cuidado: �El n�mero de punto y claves solo deben de ser cambiados '
             + 'si sabes lo que haces. De otro modo el resultado puede ser que '
             + 'ya no puedas enviar ni recibir correo!';
  s[0203] := 'Direcci�n punto';
  s[0204] := '(�si hay cambio la direcci�n antigua ser� cancelada!)';
  s[0205] := 'Sesi�n';
  s[0206] := 'Clave';
  s[0207] := 'Areafix';
  s[0208] := 'Filemgr';
  s[0209] := 'Firma para cada mensaje:';

  s[0210] := '�Hubo un error leyendo %s' + Chr(13)
             + '(Fichero no existe o no est� completo)!' + Chr(13)
             + 'Because of this the data (address and passwords) is not' + Chr(13)
             + 'changeable.';

  s[0211] := 'Expert configurations';
  s[0212] := 'no proxy';
  s[0213] := 'IP address';

  s[0214] := 'El n�mero de punto antiguo ser� cancelado ahora.';

  s[0215] := ''; // wird nicht mehr ben�tigt

  s[0216] := 'Grupos en el editor (Golded):';
  s[0217] := 'a�adir nombre de grupo';
  s[0218] := 'quitar nombre de grupo';
  s[0219] := 'cambiar nombre de grupo';
  s[0220] := 'Areas existentes:';
  s[0221] := 'las araes seleccionadas pertenecen al grupo:';
  s[0222] := 'Nombre de grupo';
  s[0223] := 'Nuevo nombre de grupo:';

  s[0224] := 'no se ha encontrado el fichero "log"';

  s[0225] := 'Introduce el nombre del ficehros (o parte de el) que buscas '
             + 'y presiona ENTER (o pica en ACEPTAR). Puedes poner hasta 3 palabras '
             + 'clave de b�squeda. Importante: No se permiten comodines '
             + '(asteriscos o exclamaciones)';
  s[0226] := 'Buscar palabra clave:';
  s[0227] := 'Se buscar�n los ficheros con la siguiente palabra clave:';
  s[0228] := 'Nota: La petici�n de b�squeda primero se generar�. La b�squeda se '
             + 'realizar� cuando Llames (Enviar y recibir correo) la '
             + 'pr�xima vez.';
  s[0229] := 'generar peticiones de b�squeda';
  s[0230] := 'borrar entradas seleccionadas';
  s[0231] := 'Borrar'; // Entfernen-Taste
  s[0232] := 'mostrar resultados';

  s[0233] := 'Configuraci�n';
  s[0234] := 'Llamar';

  s[0235] := ''; // wird nicht mehr ben�tigt
  s[0236] := ''; // wird nicht mehr ben�tigt
  s[0237] := ''; // wird nicht mehr ben�tigt
  s[0238] := ''; // wird nicht mehr ben�tigt
  s[0239] := ''; // wird nicht mehr ben�tigt

  s[0240] := '    Configuraci�n                                  ';
  s[0241] := 'Otro';

  s[0242] := 'Hay nueva informaci�n de tu nodo.' + Chr(13)
             + 'Para verla pica en "Informaci�n sobre Fido, ayuda, ..."' + Chr(13)
             + 'y luego en "Informaci�n de tu nodo".';

  s[0243] := 'La ventana con la conversaci�n IRC est� abierta.' + #13
             + '�Quieres salir realmente?';
  s[0244] := 'Charlar con otros usuarios de FidoNet..';

  s[0245] := ''; // wird nicht mehr ben�tigt

  s[0246] := 'El acceso a los fichero pedido (%s) no fue posible.';
  s[0247] := 'No se permiten claves vacias. Cambio de clave ignorado.';

  s[0248] := '�Hola!' + #13#10
             + #13#10
             + 'Bienvenido a la red de correo electr�nico FidoNet. Puedes '
             + 'suscribirte a las areas y leer el correo ya mismo. Para obtener '
             + 'permiso para escribir si realizaste el registro autom�tica '
             + 'debes contactar con tu nodo (del que te acabas de registrar '
             + 'hace un minuto). Para ello puedes simplemente contestar este '
             + 'mensaje (presiona "q" y luego ENTER dos veces), escribe el texto'
             + 'y presiona ALT-S y ENTER para guardar el mensaje). Por �ltimo  '
             + 'enviar el mensaje a tu nodo con la opci�n "Enviar y recibir '
             + 'correo (Llamar)" en el men� principal.' + #13#10
             + #13#10
             + 'Tambi�n puedes escribir o mandar un email: ' + #13#10
             + #13#10
             + 'Nombre: %s' + #13#10
             + 'Tel�fono: %s' + #13#10
             + 'eMail: %s' + #13#10
             + #13#10
             + #13#10
             + 'Un manual de Fido-Package y m�s informaci�n la podr�s encontrar '
             + 'desde el men� principal en la opci�n  "Informaci�n sobre FidoNet, '
             + 'ayuda, ...".' + #13#10
             + #13#10
             + 'Si no puedes enviar el correo (Llamar) durante un tiempo o tienes '
             + 'cualquier problema, por favor, informa a tu nodo o tu cuenta puede '
             + 'que sea borrada por inactividad.' + #13#10
             + #13#10
             + '�Puedo preguntar donde oiste hablar de Fido-Package?' + #13#10
             + #13#10
             + 'Espero que lo pases bien.' + #13#10
             + #13#10
             + '(Este es un mensaje creado automaticamente por Fido-Package '
             + 'deluxe %s.)' + #13#10;

  s[0249] := 'Acrobat Reader para ver archivos PDF no est�instalado. '
             + 'Lo puedes conseguir aqu�:' + #13
             + 'www.adobe.com/products/acrobat/readstep2.html' + #13
             + '(o si tienes el cd-rom de Fido-Package, est� en'
             + '\sonst\andere-programme\acrobat-reader 5\)' + #13
             + #13
             + 'Por otra parte tienes el manual tambi�n en formato RTF, que '
             + 'puede ser vistro directamente. Lo puedes descargar aqu�:' + #13
             + 'www.fido-deluxe.de.vu';

  s[0250] := '(�Nombres reales, apodos o falsos' + #13
             + 'ser�n borrados inmediatamente!)';

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

  s[0252] := 'Tama�o de la ventana (numbero de lineas) de Golded (editor):';

  s[0253] := 'At the moment "other Provider" is configured for internet' + #13
             + 'connection. If you have a network (LAN) connection into' + #13
             + 'the internet, then no appropiate selection were available' + #13
             + 'during installation. With network (LAN) it will no longer' + #13
             + 'checked if an internet connection is available.' + #13
             + 'Do you want to change to network (LAN) connection?';
  s[0254] := 'local network (LAN) = no online check';

  s[0255] := 'Instalaci�n antigua encontrada. �Deber�n ser usados esos datos para' + #13
             + 'la instalaci�n (sin nuevo registro)?';

  s[0256] := 'suscribirse de nuevo a todas las areas ya suscritas';
  s[0257] := 'Lista creada. En la pr�xima Llamada ("Enviar y recibir correo")' + #13
             + 'la suscripci�n ser� enviada.';
  s[0258] := '(con Win 95/98/ME s�lo son posibles 25, 43 o 50 lineas)';
  s[0259] := 'Nombre del nodo';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := '�N�mero de punto introducido no v�lido!' + #13
             + 'Debe estar en formato z:nnnn/nnnn.ppppp,' + #13
             + 'ej. "2:2457/280.13" o "2:2457/280.0".';
  s[0262] := 'Actualizar lista';
  s[0263] := 'Lista actualizada.';
  s[0264] := 'La conexi�n fall�. �Est� activa la conexi�n a internet?';
  s[0265] := 'Transaction failure.';
  s[0266] := 'Invalid Host.';
  s[0267] := 'Actualizar lista';
  s[0268] := 'Actualizar lista desde internet';
  s[0269] := 'Abrir lista desde el disco duro';
  s[0270] := 'No realizar nuevo registro, conozco mis datos';
  s[0271] := 'Introducir datos';
  s[0272] := 'N�mero de punto:';
  s[0273] := 'Clave:';
  s[0274] := 'Clave para Areafix:';
  s[0275] := 'Clave para File Ticker:';
  s[0276] := 'Clave para PKT:';
  s[0277] := 'Nombre de Areafix:';
  s[0278] := 'Nombre de File Ticker:';
  s[0279] := 'E-Mail del nodo:';
  s[0280] := 'Num. de tel�fono del nodo:';
  s[0281] := '�Por favor, repasa los datos introducidos,' + #13
             + 'sin son erroneos no funcionar�!';
  s[0282] := 'N�mero de nodo (_no_ direcci�n completa) (opcional):';
  s[0283] := 'Input not complete!';
  s[0284] := 'Selection list faulty, standard list will be used.';
  s[0285] := 'Enter proxy on previous page if necessary. Internet connection must already be active!';
  s[0286] := 'Nombre del nodo:';
  s[0287] := 'Direcci�n del nodo completa (ej. 2:2432/280):';
  s[0288] := 'DNS/IP (ej. fido.dyndns.org):';
  s[0289] := '### Otro nodo (introduce t� los datos)'; // must begin with '#'! (because of sorting of the list)
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

  s[0010] := 'Jetzt bitte sicherstellen, da� die Netzwerkverbindung steht, es';
  s[0011] := 'Jetzt bitte sicherstellen, da� die Internetverbindung steht, es';
  s[0012] := 'Jetzt bitte sicherstellen, da� die Internetverbindung genutzt werden kann, es';
  s[0013] := 'Jetzt bitte das Modem / das ISDN Ger�t einschalten, es';
  s[0014] := Chr(13) + 'wird jetzt versucht, eine Verbindung zum ausgew�hlten' + Chr(13)
             + 'Fido-Sysop herzustellen.';

  s[0015] := 'Keine bestehende Internet-Verbindung erkannt.';

  s[0016] := 'Passwort f�r %s:';
  s[0017] := 'Internet-Verbindung';

  s[0018] := 'Es ist ein Fehler beim Verbindungsaufbau aufgetreten, die' + Chr(13)
             + 'Verbindung wurde vor dem Empfangen und Senden der Mails getrennt.' + Chr(13)
             + 'Fehler bei Aktion: Pollen' + Chr(13)
             + 'Meldung: %s';

  s[0019] := 'Verbindung hergestellt.';

  s[0020] := 'Status:';
  s[0021] := 'Fido-Anmeldung l�uft..';

  s[0022] := 'Die Installation ist erfolgreich abgeschlossen.' + Chr(13)
             + 'Es wurde eine Verkn�pfung im Startmen� und auf' + Chr(13)
             + 'dem Desktop angelegt (Fido-Men�).';

  s[0023] := 'Es ist ein Fehler aufgetreten.' + Chr(13)
             + 'Fehlernummer: %s' + Chr(13)
             + 'Aktion: Pollen';

  s[0024] := 'Verbindung fehlgeschlagen. M�glicherweise ist' + Chr(13)
             + 'dies durch einen vor�bergehenden Fehler bedingt.' + Chr(13)
             + 'Evtl. sp�ter nochmal versuchen.' + Chr(13)
             + 'F�r weitere Informationen kannst Du in das Logfile gucken' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';

  s[0025] := 'Fehlerhafte Daten (CDN) empfangen. Fehlercode: %s';
  sprache_Fehlercode := 'Fehlercode'; // mu� mit ^^^^^^^^^^ �bereinstimmen!

  s[0026] := 'Die Anmelde-Daten wurden erfolgreich �bermittelt.' + #13
             + 'Jetzt wird noch die erste Fido-Area anbestellt und damit '
             + 'gleichzeitig gepr�ft, ob alles vollst�ndig installiert wurde.' + #13
             + #13
             + 'Nach der Installation findest Du im Hauptmen� unter dem '
             + 'Men�punkt "Infos zu Fido, Hilfe ..." ein Handbuch '
             + 'zu diesem Fido-Paket und weitere interessante Informationen.' + #13
             + #13
             + 'Dein erster Schritt wird vermutlich sein, da� Du Dir ein paar '
             + 'Areas (auch Echo genannt) anbestellst, dies geht im Men� "Echo '
             + 'an- oder abbestellen". Wenn Du Dich z.B. f�r Star Trek '
             + 'interessierst, dann m�chtest Du vielleicht die Startrek.ger '
             + 'anbestellen (das ".ger" steht f�r German, also deutsch). Oder '
             + 'Witze (Jokes.Ger)? PC-Hardware (Hardware.ger)? Es '
             + 'gibt sehr viele interessante Areas, schau also gleich mal in '
             + 'die Liste und bestell Dir die eine oder andere an, die Du magst.';

  s[0027] := 'Installation des Fido-Paket deluxe';
  s[0028] := 'Name';
  s[0029] := 'Bitte Vor- und Nachnamen angeben';
  s[0030] := 'PLZ / Ort';
  s[0031] := 'Telefon';
  s[0032] := 'Bitte Vorwahl und Rufnummer mit einem Minuszeichen getrennt angeben';
  s[0033] := ''; // wird nicht mehr ben�tigt
  s[0034] := ''; // wird nicht mehr ben�tigt
  s[0035] := ''; // wird nicht mehr ben�tigt
  s[0036] := '(Internet-) Verbindung �ber das DF� Netzwerk herstellen mit:';
  s[0037] := ''; // wird nicht mehr ben�tigt
  s[0038] := ''; // wird nicht mehr ben�tigt
  s[0039] := 'Betriebssystem';
  s[0040] := 'Erkanntes Betriebssystem: ';
  s[0041] := 'Installations-&Verzeichnis ausw�hlen';
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

  s[0053] := 'Das DF� Netzwerk ist nicht installiert, es wurde jedoch' + Chr(13)
             + 'eine Internet-Verbindung erkannt. Daher kann mit der' + Chr(13)
             + 'Installation fortgefahren werden, allerdings wird es nur' + Chr(13)
             + 'm�glich sein, Internet-Verbindungen herzustellen.';

  s[0054] := 'Das DF� Netzwerk ist nicht installiert, wird jedoch' + Chr(13)
             + 'ben�tigt. Bitte mit Hilfe von Software / Windows-Setup' + Chr(13)
             + 'unter Arbeitsplatz / Systemsteuerung installieren, und' + Chr(13)
             + 'dann die Installation des Fido-Paket deluxe neu starten.';
  s[0055] := 'Fehler bei der Installation';

  s[0056] := 'Internet-Verbindung';

  s[0057] := 'Es ist kein Modem oder ISDN-Karte f�r das DF� Netzwerk' + Chr(13)
             + 'installiert.' + Chr(13)
             + 'Bitte dies nachholen, und dann die Installation des' + Chr(13)
             + 'Fido-Paket deluxe neu starten.';

  s[0058] := 'Es ist ein unbekannter Fehler beim Erstellen einer neuen' + Chr(13)
             + 'Verbindung im DF� Netzwerk aufgetreten.' + Chr(13)
             + 'Die Installation wird abgebrochen.';

  s[0059] := 'Erkanntes Betriebssystem: %s';

  s[0060] := 'Fehler beim �ffnen der Datei "%s'+'fido\sonst\cdpnodes.lst".' + Chr(13)
             + 'Fehlernummer: %s';

  s[0061] := 'Es wurde noch keine internationale Vorwahl eingegeben.';
  s[0062] := 'Fehler bei der Eingabe';
  s[0063] := 'Es wurde noch kein Name eingegeben.';
  s[0064] := 'Der eingegebene Name ist nicht vollst�ndig.';
  s[0065] := 'Es wurde noch kein Ort eingegeben.';
  s[0066] := 'Es wurde ein ung�ltiger Ort eingegeben.';
  s[0067] := 'Es wurde noch keine Telefonnummer eingegeben.';
  s[0068] := 'Bitte die Vorwahl von der Rufnummer mit "-" trennen,' + Chr(13)
             + 'zum Beispiel: 02732-12345';
  s[0069] := 'Es wurde eine ung�ltige Telefonnummer eingegeben.';
  s[0070] := 'Bei der Call-By-Call Nummer sind nur Ziffern erlaubt.' + Chr(13)
             + 'Sie mu� 010xx oder 010xxx lauten, z.B. 01030 (oder leer lassen).';

  s[0071] := 'Es ist nicht genug freier Speicherplatz auf dem gew�hlten' + Chr(13)
             + 'Laufwerk (%s' + ':) vorhanden.' + Chr(13)
             + 'Es werden mindestens 20 MB ben�tigt.';

  s[0072] := 'Fido-Men�';
  s[0073] := 'Vom Fido abmelden';
  s[0074] := 'Deinstallieren von Fido-Paket deluxe';

  s[0075] := 'Kein Grund angegeben, vermutlich ein vor�bergehender' + Chr(13)
             + 'Fehler, evtl. sp�ter nochmal versuchen.' + Chr(13)
             + 'F�r weitere Informationen kannst Du in das Logfile gucken' + Chr(13)
             + '(%s' + '\binkley\binkd.log).';
  s[0076] := 'Das ausgew�hlte Fido-System akzeptiert im Moment keine neuen'
             + Chr(13) + 'Fido-Mitglieder (Points). Der angegebene Grund:' + Chr(13);
  s[0077] := 'Bitte die Installation des Fido-Paket deluxe abbrechen, oder ein'
             + Chr(13) + 'anderes Fido-System ausw�hlen.';

  s[0078] := 'Sollen die bisher installierten Dateien gel�scht werden?';
  s[0079] := 'Abbruch der Installation';
  s[0080] := 'Alle bisher installierten Dateien gel�scht.';

  s[0081] := 'Es d�rfen keine Leerzeichen (" ") im Pfad enthalten sein.'
             + Chr(13) + 'Verzeichnis: %s' + Chr(13)
             + Chr(13) + 'Bitte ein anderes Verzeichnis w�hlen.';
  s[0082] := 'Das ausgew�hlte Installations-Verzeichnis existiert bereits.'
             + Chr(13) + 'Verzeichnis: %s' + Chr(13)
             + '*** Alle enthaltenen Dateien und Unterordner werden gel�scht! ***'
             + Chr(13) + Chr(13)
             + 'Sicher?';
  s[0083] := 'Warnung';

  s[0084] := 'Installations-Verzeichnis: %s';

  s[0085] := 'anderer Internet-Provider';

  s[0086] := 'Keine alte Installation gefunden.'
             + Chr(13) + 'Verzeichnis: %s'
             + Chr(13) + 'Gesuchte Datei: point.cdn'
             + Chr(13) + Chr(13)
             + 'Bitte ein anderes Verzeichnis w�hlen.';

  s[0087] := 'Update erfolgreich abgeschlossen.';

  s[0088] := 'Das Fido-Paket deluxe (10 MB) wird jetzt installiert.' + Chr(13)
             + 'Bitte warten.';

  s[0089] := 'Installation wirklich abbrechen?';
  s[0090] := 'Abbruch';
  s[0091] := 'Sollen die bisher installierten Dateien gel�scht werden?';
  s[0092] := 'Alle bisher installierten Dateien gel�scht.';

  s[0093] := 'Netzwerkkarte = keine W�hlverbindung';
  s[0094] := 'Internet-Verbindung';
  s[0095] := 'Es ist ein unerwarteter Fehler beim Abfragen der Verbindungen' + Chr(13)
             + 'im DF� Netzwerk aufgetreten.' + Chr(13);
  s[0096] := 'Fehlernummer: %s' + Chr(13)
             + 'Bitte den Programmierer benachrichtigen:' + Chr(13)
             + 'Michael Haase, m.haase@gmx.net, 2:2432/280';
  s[0097] := 'Es ist ein unerwarteter Fehler beim Allokieren von Speicher aufgetreten.' + Chr(13);
  s[0098] := 'kein Modem oder ISDN Capi gefunden';

  s[0099] := 'isdn'; // nicht �ndern!
  s[0100] := 'modem'; // nicht �ndern!
  s[0101] := 'Kommunikationskabel'; // nicht �ndern!

  s[0102] := 'Das DF� Netzwerk ist nicht installiert. Es wird jetzt nach einer aktiven Internet-Verbindung gesucht..';
  s[0103] := 'Internet-Verbindung steht, nicht weiter suchen';

  s[0104] := 'Fido-Paket';

  s[0105] := 'CDN Datei nicht mehr gefunden.' + Chr(13)
             + 'Diese bitte nicht in das Installationsverzeichnis kopieren!';

  s[0106] := 'Das Fido-Paket deluxe ist nun deinstalliert.';
  s[0107] := 'Deinstallation';
  s[0108] := 'Soll das Fido-Paket deluxe wirklich deinstalliert werden?';

  s[0109] := '&Zeige Fido-Men�';
  s[0110] := 'B&eenden';

  s[0111] := ' Hauptmen� (Fido-Paket deluxe)';
  s[0112] := 'Fido-Paket deluxe %s' + Chr(13)
             + '         von Michael Haase';
  s[0113] := '  Mails senden und empfangen (Pollen)';
  s[0114] := '  Mails lesen und schreiben (Editor)       ';
  s[0115] := '   Echo an- oder abbestellen                ';
  s[0116] := '  Datei suchen beim File-List-Server    ';
  s[0117] := '  Logfiles ansehen und k�rzen            ';
  s[0118] := '  Infos zu Fido, Hilfe ...                       ';
  s[0119] := '  Beenden ';
  s[0120] := '  Bug melden';

  s[0121] := 'Die Internet-Verbindung ist nicht verf�gbar.';
  s[0122] := 'Passwort:';

  s[0123] := 'Du hast neue (pers�nliche) Mail.' + Chr(13)
             + 'Netmails: %s' + Chr(13)
             + 'Echomail: %s';

  s[0124] := ''; // wird nicht mehr ben�tigt

  s[0125] := 'Es ist ein Fehler aufgetreten.' + Chr(13)
             + 'Fehlernummer: %s' + Chr(13)
             + 'Aktion: Editor';

  s[0126] := 'Willst Du Dich wirklich vom Fido abmelden' + Chr(13)
             + 'und alle Areas abbestellen?';
  s[0127] := 'Abmelden?';

  s[0128] := 'Anzahl anbestellter Echos: %s';

  s[0129] := 'Der angegebene Suchbegriff wurde nicht gefunden.';
  s[0130] := 'Suchen';
  s[0131] := 'Keine weitere Fundstelle f�r den angegebenen Suchbegriff.';

  s[0132] := 'Wirklich abbrechen (alle gemachten �nderungen gehen verloren)?';

  s[0133] := 'Anzahl verf�gbarer deutschsprachiger Fido-Echos: %s';

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

  s[0145] := 'Anzahl verf�gbarer amerikanischer Fido-Echos: %s';
  s[0146] := 'Anzahl verf�gbarer Box-Echos: %s';
  s[0147] := 'Anzahl verf�gbarer (regionaler) Netz-Echos: %s';

  s[0148] := 'Wirklich abbrechen (keine Suchanfrage generieren)?';
  s[0149] := 'Die Suchanfrage wurde generiert. Wenn Du das n�chste' + Chr(13)
             + 'mal pollst (Mails empfangen und senden), wird die' + Chr(13)
             + 'Suche bearbeitet und Du kannst kurz darauf das Ergebnis' + Chr(13)
             + 'abholen (erneut pollen).';

  s[0150] := 'Das Logfile ist kleiner als 300 KB, daher ist' + Chr(13)
             + 'es nicht n�tig, es zu k�rzen.';
  s[0151] := 'Logfile nicht vorhanden.';
  s[0152] := 'Gr��e des Logfiles: %s KB';
  s[0153] := 'Logfile';
  s[0154] := 'Logfile k�rzen';
  s[0155] := 'Zur�ck';

  s[0156] := 'Bitte die Fido-Paket deluxe CD einlegen und erneut auf "Sonstiges" klicken.';
  s[0157] := 'Bilder';

  s[0158] := ' Fido-Infos';
  s[0159] := '    Infos zu Fido';
  s[0160] := '     Infos Deines Nodes';
  s[0161] := '     Golded Handbuch';
  s[0162] := '    Sonstiges';
  s[0163] := ''; // wird nicht mehr ben�tigt
  s[0164] := 'zur�ck';
  s[0165] := 'vor';
  s[0166] := 'Schlie�en';

  s[0167] := 'AutoPoll: Alle %s'
             + ' Minuten automatisch pollen, wenn Fenster minimiert';
  s[0168] := 'Anzeige f�r AutoPoll; Angaben in Minuten';
  s[0169] := 'Internet-Provider:';

  s[0170] := 'Es wurden nicht alle RAS-Funktionen (DF� Netzwerk) gefunden.' + Chr(13)
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
  s[0183] := 'Gr�n';
  s[0184] := 'Cyan';
  s[0185] := 'Rot';
  s[0186] := 'Magenta';
  s[0187] := 'Braun';
  s[0188] := 'Dunkelgrau';
  s[0189] := 'Hellgrau';
  s[0190] := 'Hellblau';
  s[0191] := 'Hellgr�n';
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
             + 'Adressaten ein Adressmakro f�r h�ufig verwendete Namen '
             + 'benutzen. Bei "An:" einfach das K�rzel eingeben, z.B. mh '
             + 'f�r Michael Haase, 2:2432/280.';

  s[0202] := 'Achtung: Die �nderung der Pointnummer und der Passw�rter sollte '
             + 'nur erfolgen, wenn man wei�, was man macht. Ansonsten kann dies '
             + 'dazu f�hren, da� keine Mails mehr empfangen oder versendet '
             + 'werden k�nnen!';
  s[0203] := 'Pointadresse';
  s[0204] := '(Bei �nderung wird die alte AKA abgemeldet!)';
  s[0205] := 'Session';
  s[0206] := 'Passwort';
  s[0207] := 'Areafix';
  s[0208] := 'Filemgr';
  s[0209] := 'Footer unter jeder Mail:';

  s[0210] := 'Fehler beim Lesen von %s aufgetreten' + Chr(13)
             + '(Datei nicht vorhanden oder nicht vollst�ndig)!' + Chr(13)
             + 'Deswegen k�nnen die Daten (Adresse und Passw�rter) nicht' + Chr(13)
             + 'ge�ndert werden.';

  s[0211] := 'Experten-Einstellungen';
  s[0212] := 'kein Proxy';
  s[0213] := 'IP Adresse';

  s[0214] := 'Die alte Pointnummer wird jetzt abgemeldet.';

  s[0215] := ''; // wird nicht mehr ben�tigt

  s[0216] := 'Gruppen im Editor (Golded):';
  s[0217] := 'Gruppenname hinzuf�gen';
  s[0218] := 'Gruppenname l�schen';
  s[0219] := 'Gruppenname �ndern';
  s[0220] := 'Vorhandene Areas:';
  s[0221] := 'selektierte Area geh�rt zu Gruppe:';
  s[0222] := 'Gruppenname';
  s[0223] := 'Neuer Gruppenname:';

  s[0224] := 'kein Logfile gefunden';

  s[0225] := 'Bitte den Dateinamen (oder einen Teil davon)  eingeben, '
             + 'nach dem gesucht werden soll, und Return dr�cken (oder '
             + 'auf OK klicken). Es k�nnen bis zu 3 Suchbegriffe '
             + 'eingegeben werden. Wichtig: Keine Wildcards (Sternchen '
             + 'oder Fragezeichen) erlaubt!';
  s[0226] := 'Suchbegriff:';
  s[0227] := 'Es werden Dateien mit diesen Suchbegriffen gesucht:';
  s[0228] := 'Hinweis: Die Suchanfrage wird zun�chst generiert. Die '
             + 'eigentliche Suche wird erst ausgef�hrt, wenn Du das n�chste '
             + 'mal pollst (Mails senden/empfangen).';
  s[0229] := 'Suchanfrage generieren';
  s[0230] := 'markierte Eintr�ge l�schen';
  s[0231] := 'Entf'; // Entfernen-Taste
  s[0232] := 'Ergebnisse anzeigen';

  s[0233] := 'Konfiguration';
  s[0234] := 'Pollen';

  s[0235] := ''; // wird nicht mehr ben�tigt
  s[0236] := ''; // wird nicht mehr ben�tigt
  s[0237] := ''; // wird nicht mehr ben�tigt
  s[0238] := ''; // wird nicht mehr ben�tigt
  s[0239] := ''; // wird nicht mehr ben�tigt

  s[0240] := '  Konfiguration                                    ';
  s[0241] := 'Sonstiges';

  s[0242] := 'Es gibt neue Infos von Deinem Node.' + Chr(13)
             + 'Um sie anzusehen klicke auf "Infos zu Fido, Hilfe ..."' + Chr(13)
             + 'und dann auf "Infos Deines Nodes".';

  s[0243] := 'Das Fenster mit dem IRC-Chat ist noch offen.' + #13#10
             + 'Wirklich beenden?';
  s[0244] := 'Chatten mit anderen Fidoleuten..';

  s[0245] := ''; // wird nicht mehr ben�tigt

  s[0246] := 'Auf die Request-Datei (%s) konnte nicht zugegriffen werden.';
  s[0247] := 'Leere Passw�rter sind nicht erlaubt. Passwort-�nderung wird ignoriert.';

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
             + 'werden sofort gel�scht!)';

  s[0251] := 'Wegen r�der Sprache und Beleidigungen gegen�ber neuen Usern,' + #13
             + 'Rules, die dem Gesetz oder Fido Policies widersprechen' + #13
             + 'und dem Ausschluss von schwulen Leuten in den Rules, hat' + #13
             + 'diese Area einen eingeschr�nkten Zugriff! Wenn Du wirklich' + #13
             + 'sicher bist, da� Du diese Area anbestellen willst, dann solltest' + #13
             + 'Du bereits ein erfahrener Fido User sein, so dass Du wissen' + #13
             + 'solltest und musst, wie man diese Area manuell anbestellt.' + #13
             + 'Die Rules dieser Area wurden Dir gerade als Netmail erstellt,' + #13
             + 'Du kannst sie in Golded lesen.' + #13
             + '- NEC 2457, Michael Haase (2:2457/2)';

  s[0252] := 'Fenstergr��e (Anzahl Zeilen) von Golded (Editor):';

  s[0253] := 'Momentan ist "anderer Provider" als Internetverbindung' + #13
             + 'eingestellt. Wenn Du eine Netzwerkverbindung (LAN) ins' + #13
             + 'Internet hast, dann gab es bei der Installation keine' + #13
             + 'Auswahl daf�r. Bei Netzwerk (LAN) erfolgt keine Pr�fung' + #13
             + 'mehr, ob eine Internetverbindung besteht.' + #13
             + 'Soll auf Netzwerkverbindung (LAN) umgestellt werden?';
  s[0254] := 'lokales Netzwerk (LAN) = keine Onlinepr�fung';

  s[0255] := 'Alte Installation gefunden. Sollen diese Daten f�r die' + #13
             + 'Installation benutzt werden (also keine Neuanmeldung)?';

  s[0256] := 'alle anbestellten Echos neu bestellen';
  s[0257] := 'Liste erstellt, beim n�chsten Pollen ("Mails senden' + #13
             + 'und empfangen") wird die Anbestellung gesendet.';
  s[0258] := '(bei Win 95/98/ME gehen nur 25, 43 oder 50 Zeilen)';
  s[0259] := 'Node Name';
  s[0260] := 'IP / Dyn. DNS';
  s[0261] := 'Die eingegebene Pointadresse ist ung�ltig!' + #13
             + 'Sie mu� im Format z:nnnn/nnnn.ppppp sein,' + #13
             + 'z.B. "2:2457/280.13" oder "2:2457/280.0".';
  s[0262] := 'Aktualisiere Liste';
  s[0263] := 'Liste aktualisiert.';
  s[0264] := 'Verbindung fehlgeschlagen. Internet-Verbindung aktiv?';
  s[0265] := 'Transaktion fehlgeschlagen.';
  s[0266] := 'Ung�ltiger Host.';
  s[0267] := 'Aktualisieren der Liste';
  s[0268] := 'Aktuelle Liste aus Internet laden';
  s[0269] := 'Liste von Festplatte �ffnen';
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
  s[0281] := 'Bitte pr�fe die eingegebenen Daten doppelt,' + #13
             + 'bei falschen Daten funktioniert es nicht!';
  s[0282] := 'Node-Nummer (_nicht_ komplette AKA!) (optional):';
  s[0283] := 'Angaben nicht vollst�ndig!';
  s[0284] := 'Auswahl-Liste fehlerhaft, Standard-Liste wird verwendet.';
  s[0285] := 'Proxy ggf. auf der vorigen Seite eintragen. Internet-Verbindung muss bereits bestehen!';
  s[0286] := 'Name des Nodes:';
  s[0287] := 'Komplette Node-Adresse (z.B. 2:2432/280):';
  s[0288] := 'DNS/IP (z.B. fido.dyndns.org):';
  s[0289] := '### Anderer Node (Daten selber eingeben)'; // muss mit '#' beginnen! (wegen Sortierung der Liste)
  s[0290] := '    Problem-Pr�fung';
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

