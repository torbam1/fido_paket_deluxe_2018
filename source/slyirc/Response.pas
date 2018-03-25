{
  Unit        SlyIrc.pas

  Description Constants for use in the response handler functions.

  Author      Steve Williams

  Copyright   (C) Copyright 1999 Steve Williams

  Objects     none

  History     Sometime back in 1997, my first IRC client component was released
              upon the masses.  It was actually the third version, but the first
              to be released.  TIRCClient was (and still is) used by many people
              around the world.  Since that initial release, I learnt a whole
              lot more about object-oriented programming in Delphi, and thus
              TSlyIrc was born.

  1.0   23/12/99
              - This file split from SlyIrc.pas.
}

unit Response;

interface

const
  RPL_WELCOME1          = '001';
  RPL_WELCOME2          = '002';
  RPL_WELCOME3          = '003';
  RPL_WELCOME4          = '004';
  { Numerics as defined in RFC1459. }
  RPL_TRACELINK	        = '200'; { Link <version & debug level> <destination> <next server> }
  RPL_TRACECONNECTING	  = '201'; { Try. <class> <server> }
  RPL_TRACEHANDSHAKE	  = '202'; { H.S. <class> <server> }
  RPL_TRACEUNKNOWN	    = '203'; { ???? <class> [<client IP address in dot form>] }
  RPL_TRACEOPERATOR	    = '204'; { Oper <class> <nick> }
  RPL_TRACEUSER	        = '205'; { User <class> <nick> }
  RPL_TRACESERVER	      = '206'; { Serv <class> <int>S <int>C <server> <nick!user|*!*>@<host|server> }
  RPL_TRACENEWTYPE	    = '208'; { <newtype> 0 <client name> }
  RPL_STATSLINKINFO	    = '211'; { <linkname> <sendq> <sent messages> <sent bytes> <received messages> <received bytes> <time open> }
  RPL_STATSCOMMANDS	    = '212'; { <command> <count> }
  RPL_STATSCLINE	      = '213'; { C <host> * <name> <port> <class> }
  RPL_STATSNLINE	      = '214'; { N <host> * <name> <port> <class> }
  RPL_STATSILINE	      = '215'; { I <host> * <host> <port> <class> }
  RPL_STATSKLINE	      = '216'; { K <host> * <username> <port> <class> }
  RPL_STATSYLINE	      = '218'; { Y <class> <ping frequency> <connect frequency> <max sendq> }
  RPL_ENDOFSTATS	      = '219'; { <stats letter> :End of /STATS report }
  RPL_UMODEIS	          = '221'; { <user mode string> }
  RPL_STATSLLINE	      = '241'; { L <hostmask> * <servername> <maxdepth> }
  RPL_STATSUPTIME	      = '242'; { :Server Up %d days %d:%02d:%02d }
  RPL_STATSOLINE	      = '243'; { O <hostmask> * <name> }
  RPL_STATSHLINE	      = '244'; { H <hostmask> * <servername> }
  RPL_LUSERCLIENT	      = '251'; { :There are <integer> users and <integer> invisible on <integer> servers }
  RPL_LUSEROP	          = '252'; { <integer> :operator(s) online }
  RPL_LUSERUNKNOWN	    = '253'; { <integer> :unknown connection(s) }
  RPL_LUSERCHANNELS	    = '254'; { <integer> :channels formed }
  RPL_LUSERME	          = '255'; { :I have <integer> clients and <integer> servers }
  RPL_ADMINME	          = '256'; { <server> :Administrative info }
  RPL_ADMINLOC1	        = '257'; { :<admin info> }
  RPL_ADMINLOC2	        = '258'; { :<admin info> }
  RPL_ADMINEMAIL	      = '259'; { :<admin info> }
  RPL_TRACELOG	        = '261'; { File <logfile> <debug level> }
  RPL_NONE	            = '300'; { Dummy reply number. Not used. }
  RPL_AWAY	            = '301'; { <nick> :<away message> }
  RPL_USERHOST	        = '302'; { :[<reply><space><reply>] }
  RPL_ISON	            = '303'; { :[<nick> <space><nick>] }
  RPL_UNAWAY	          = '305'; { :You are no longer marked as being away }
  RPL_NOWAWAY	          = '306'; { :You have been marked as being away }
  RPL_WHOISUSER	        = '311'; { <nick> <user> <host> * :<real name> }
  RPL_WHOISSERVER	      = '312'; { <nick> <server> :<server info> }
  RPL_WHOISOPERATOR	    = '313'; { <nick> :is an IRC operator }
  RPL_WHOWASUSER	      = '314'; { <nick> <user> <host> * :<real name> }
  RPL_ENDOFWHO	        = '315'; { <name> :End of /WHO list }
  RPL_WHOISIDLE	        = '317'; { <nick> <integer> :seconds idle }
  RPL_ENDOFWHOIS	      = '318'; { <nick> :End of /WHOIS list }
  RPL_WHOISCHANNELS	    = '319'; { <nick> :[@|+]<channel><space> }
  RPL_LISTSTART	        = '321'; { Channel :Users  Name }
  RPL_LIST	            = '322'; { <channel> <# visible> :<topic> }
  RPL_LISTEND	          = '323'; { :End of /LIST }
  RPL_CHANNELMODEIS	    = '324'; { <channel> <mode> <mode params> }
  RPL_NOTOPIC	          = '331'; { <channel> :No topic is set }
  RPL_TOPIC	            = '332'; { <channel> :<topic> }
  RPL_INVITING	        = '341'; { <channel> <nick> }
  RPL_SUMMONING	        = '342'; { <user> :Summoning user to IRC }
  RPL_VERSION	          = '351'; { <version>.<debuglevel> <server> :<comments> }
  RPL_WHOREPLY	        = '352'; { <channel> <user> <host> <server> <nick> <H|G>[*][@|+] :<hopcount> <real name> }
  RPL_NAMREPLY	        = '353'; { <channel> :[[@|+]<nick> [[@|+]<nick> [...]]] }
  RPL_LINKS	            = '364'; { <mask> <server> :<hopcount> <server info> }
  RPL_ENDOFLINKS	      = '365'; { <mask> :End of /LINKS list }
  RPL_ENDOFNAMES	      = '366'; { <channel> :End of /NAMES list }
  RPL_BANLIST	          = '367'; { <channel> <banid> }
  RPL_ENDOFBANLIST	    = '368'; { <channel> :End of channel ban list }
  RPL_ENDOFWHOWAS	      = '369'; { <nick> :End of WHOWAS }
  RPL_INFO	            = '371'; { :<string> }
  RPL_MOTD	            = '372'; { :- <text> }
  RPL_ENDOFINFO	        = '374'; { :End of /INFO list }
  RPL_MOTDSTART	        = '375'; { ":- <server> Message of the day -," }
  RPL_ENDOFMOTD	        = '376'; { :End of /MOTD command }
  RPL_YOUREOPER	        = '381'; { :You are now an IRC operator }
  RPL_REHASHING	        = '382'; { <config file> :Rehashing }
  RPL_TIME	            = '391'; { }
  RPL_USERSSTART	      = '392'; { :UserID   Terminal  Host }
  RPL_USERS	            = '393'; { :%-8s %-9s %-8s }
  RPL_ENDOFUSERS	      = '394'; { :End of users }
  RPL_NOUSERS	          = '395'; { :Nobody logged in }
  ERR_NOSUCHNICK	      = '401'; { <nickname> :No such nick/channel }
  ERR_NOSUCHSERVER	    = '402'; { <server name> :No such server }
  ERR_NOSUCHCHANNEL	    = '403'; { <channel name> :No such channel }
  ERR_CANNOTSENDTOCHAN	= '404'; { <channel name> :Cannot send to channel }
  ERR_TOOMANYCHANNELS	  = '405'; { <channel name> :You have joined too many channels }
  ERR_WASNOSUCHNICK	    = '406'; { <nickname> :There was no such nickname }
  ERR_TOOMANYTARGETS	  = '407'; { <target> :Duplicate recipients. No message delivered }
  ERR_NOORIGIN	        = '409'; { :No origin specified }
  ERR_NORECIPIENT	      = '411'; { :No recipient given (<command>) }
  ERR_NOTEXTTOSEND	    = '412'; { :No text to send }
  ERR_NOTOPLEVEL	      = '413'; { <mask> :No toplevel domain specified }
  ERR_WILDTOPLEVEL	    = '414'; { <mask> :Wildcard in toplevel domain }
  ERR_UNKNOWNCOMMAND	  = '421'; { <command> :Unknown command }
  ERR_NOMOTD	          = '422'; { :MOTD File is missing }
  ERR_NOADMININFO	      = '423'; { <server> :No administrative info available }
  ERR_FILEERROR	        = '424'; { :File error doing <file op> on <file> }
  ERR_NONICKNAMEGIVEN	  = '431'; { :No nickname given }
  ERR_ERRONEUSNICKNAME	= '432'; { <nick> :Erroneus nickname }
  ERR_NICKNAMEINUSE	    = '433'; { <nick> :Nickname is already in use }
  ERR_NICKCOLLISION	    = '436'; { <nick> :Nickname collision KILL }
  ERR_USERNOTINCHANNEL	= '441'; { <nick> <channel> :They aren't on that channel }
  ERR_NOTONCHANNEL	    = '442'; { <channel> :You're not on that channel }
  ERR_USERONCHANNEL	    = '443'; { <user> <channel> :is already on channel }
  ERR_NOLOGIN	          = '444'; { <user> :User not logged in }
  ERR_SUMMONDISABLED	  = '445'; { :SUMMON has been disabled }
  ERR_USERSDISABLED	    = '446'; { :USERS has been disabled }
  ERR_NOTREGISTERED	    = '451'; { :You have not registered }
  ERR_NEEDMOREPARAMS	  = '461'; { <command> :Not enough parameters }
  ERR_ALREADYREGISTRED	= '462'; { :You may not reregister }
  ERR_NOPERMFORHOST	    = '463'; { :Your host isn't among the privileged }
  ERR_PASSWDMISMATCH	  = '464'; { :Password incorrect }
  ERR_YOUREBANNEDCREEP	= '465'; { :You are banned from this server }
  ERR_KEYSET	          = '467'; { <channel> :Channel key already set }
  ERR_CHANNELISFULL	    = '471'; { <channel> :Cannot join channel (+l) }
  ERR_UNKNOWNMODE	      = '472'; { <char> :is unknown mode char to me }
  ERR_INVITEONLYCHAN	  = '473'; { <channel> :Cannot join channel (+i) }
  ERR_BANNEDFROMCHAN	  = '474'; { <channel> :Cannot join channel (+b) }
  ERR_BADCHANNELKEY	    = '475'; { <channel> :Cannot join channel (+k) }
  ERR_NOPRIVILEGES	    = '481'; { :Permission Denied- You're not an IRC operator }
  ERR_CHANOPRIVSNEEDED	= '482'; { <channel> :You're not channel operator }
  ERR_CANTKILLSERVER	  = '483'; { :You cant kill a server! }
  ERR_NOOPERHOST	      = '491'; { :No O-lines for your host }
  ERR_UMODEUNKNOWNFLAG	= '501'; { :Unknown MODE flag }
  ERR_USERSDONTMATCH	  = '502'; { :Cant change mode for other users }

implementation

end.
