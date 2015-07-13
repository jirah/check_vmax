#!/bin/bash

# Configuration
# all values can be overwritten via command line options
symcfg="/opt/emc/SYMCLI/bin/symcfg"; # default path to symcfg
sid=917;                             # default sid

#***************************************************#
#  Function: print_usage                            #
#---------------------------------------------------#
#  print usage information                          #
#                                                   #
#***************************************************#

print_usage () {
  echo "Usage: [-s <symcfg>] [-S <sid>] [-v] [-p <pool>] [-w <warn>] [-c <critical>] [-V] -l <check>" 1>&2; exit 1;
}

function print_help(){
  echo "EMC Symmetrix VMAX checks for Icinga/Nagios version $version";
  echo "GPL license, (c)2015 - Ricardo Fuentes <ricardo.fuentes@hp.com>";
#  print_usage()
  echo "

Options:
 -h, --help
    Print detailed help screen
 -V, --version
    Print version information
 -s, --symcfg
    Path to symcfg binary (default: $symcfg)
 -S, --sid
    Unique Symmetrix ID (default: $sid)
 -l, --check
    Adapter/Power Supply Status/Thin Pool Usage Checks
    see $projecturl or README for details
    possible checks:
    adapter: get RF and RA adapter status
    psu: get power supply status
    thinpool: get thin pool usage
 -p, --pool
    Pool name for individual thin pool usage warning and
    critical values
 -w, --warning=DOUBLE
    Value to result in warning status
    Specify warning per pool and/or global
 -c, --critical=DOUBLE
    Value to result in critical status
    Specify critical per pool and/or global
 -v, --verbose
    Show details for command-line debugging
    (Icinga/Nagios may truncate output)

Send email to ricardo.fuentes@hp.com if you have questions regarding use
of this software. To submit patches of suggest improvements, send
email to ricardo.fuentes@hp.com
";
}

#exit $ERRORS{$status{'unknown'}};
#}

####print_help 

#***************************************************#
#  Function: print_version                          #
#---------------------------------------------------#
#  Display version of plugin and exit.              #
#                                                   #
#***************************************************#

#function print_version{
#  echo "$prog $version\n";
#  exit $ERRORS{$status{'unknown'}};
#}

function sid (){
	command $symcfg list | awk {'print $1'} | awk 'NR==1,NR==6 {next} {print}' | sed '$d'
}
#symcfg list | awk '{print $1}' | awk 'NR==1,NR==6 {next} {print}' | sed '$d'

while getopts "hsS:P:fuwc" opt; do
  case $opt in
    h)
        print_help
      ;;
    s)
#      echo "-s was triggered!" >&2
	echo ""
	echo "Pick one of the SID's on the following list to work with the -S variable."
	echo ""
	sid
	echo ""
	echo "Example: check_vmax -S 000000000001."
	echo ""
      ;;
    S)
	echo ""
	echo "Pass a SID from the -s output as a argument after this parameter."
	echo ""
      ;;
    P)
        echo ""
        echo "List Pools on SID. Example: check_vmax -S 000000000001 -P"
        echo ""
      ;;
    f)
        echo ""
        echo "List the Full percentage of a Poll. Example: check_vmax -S 000000000001 -P Pool_1 -f"
        echo ""
      ;;
    u)
        echo ""
        echo "List the Subscription percentage of a Poll. Example: check_vmax -S 000000000001 -P Pool_1 -f"
        echo ""
      ;;

    \?)
#      echo "Invalid option: -$OPTARG" >&2
	print_help
      ;;
  esac
done
