 #!/usr/bin/env bash
#
# Try `install_agnudp.sh --help` for usage.
#
# (c) 2023 Khaled AGN
#

set -e
source <(curl -sSL 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module')
hystban_me
###
# SCRIPT CONFIGURATION
###


# PROTOCOL
PROTOCOL="udp"

# UDP PORT
UDP_PORT=":36712"

# Domain Name
echo ""
print_center -ama "PLEASE ENTER YOUR SUB-DOMAIN: (e.g dns.teslaprojects.com) "

read -p "DOMAIN:" DOMAIN
echo ""
sleep 2
# OBFS
print_center -ama "Enter User name (OBFS) - Required"
read -p "Username:" OBFS
echo ""
sleep 2
# PASSWORDS
echo "Enter User Password"
read -p "Password:" PASSWORD
echo ""
sleep 2
print_center -ama "Saving the entries..."
sleep 4
clear
print_center -ama "${a103:-setting up, please wait...}"
echo "###################################################"
echo "# Tesla SSH is busy installing everything for you.#"
echo "# Leave Everything to Us...                       #"
echo "###################################################"
echo ""
sleep 3
# [change timezone to UTC +3]
echo ""
echo " ⇢ Changing City to Kampala"
echo " ⇢ for Africa/Kampala [UG] GMT +03:00"
sleep 3
ln -fs /usr/share/zoneinfo/Africa/Nairobi /etc/localtime &>/dev/null
echo -e "Time Zone Now: ⇝ Kampala +03 GMT"
sleep 4
# Basename of this script
SCRIPT_NAME="$(basename "$0")"

# Command line arguments of this script
SCRIPT_ARGS=("$@")

# Path for installing executable
EXECUTABLE_INSTALL_PATH="/usr/local/bin/hysteria"

# Paths to install systemd files
SYSTEMD_SERVICES_DIR="/etc/systemd/system"

# Directory to store hysteria config file
CONFIG_DIR="/etc/hysteria"

# URLs of GitHub
REPO_URL="https://github.com/apernet/hysteria"
API_BASE_URL="https://api.github.com/repos/apernet/hysteria"

# curl command line flags.
# To using a proxy, please specify ALL_PROXY in the environ variable, such like:
# export ALL_PROXY=socks5h://192.0.2.1:1080
CURL_FLAGS=(-L -f -q --retry 5 --retry-delay 10 --retry-max-time 60)


###
# AUTO DETECTED GLOBAL VARIABLE
###

# Package manager
PACKAGE_MANAGEMENT_INSTALL="${PACKAGE_MANAGEMENT_INSTALL:-}"

# Operating System of current machine, supported: linux
OPERATING_SYSTEM="${OPERATING_SYSTEM:-}"

# Architecture of current machine, supported: 386, amd64, arm, arm64, mipsle, s390x
ARCHITECTURE="${ARCHITECTURE:-}"

# User for running hysteria
HYSTERIA_USER="${HYSTERIA_USER:-}"

# Directory for ACME certificates storage
HYSTERIA_HOME_DIR="${HYSTERIA_HOME_DIR:-}"


###
# ARGUMENTS
###

# Supported operation: install, remove, check_update
OPERATION=

# User specified version to install
VERSION=

# Force install even if installed
FORCE=

# User specified binary to install
LOCAL_FILE=


###
# COMMAND REPLACEMENT & UTILITIES
###

has_command() {
	local _command=$1
	
	type -P "$_command" > /dev/null 2>&1
}

curl() {
	command curl "${CURL_FLAGS[@]}" "$@"
}

mktemp() {
	command mktemp "$@" "hyservinst.XXXXXXXXXX"
}

tput() {
	if has_command tput; then
		command tput "$@"
		fi
}

tred() {
	tput setaf 1
}

tgreen() {
	tput setaf 2
}

tyellow() {
	tput setaf 3
}

tblue() {
	tput setaf 4
}

taoi() {
	tput setaf 6
}

tbold() {
	tput bold
}

treset() {
	tput sgr0
}

note() {
	local _msg="$1"
	
	echo -e "$SCRIPT_NAME: $(tbold)note: $_msg$(treset)"
}

warning() {
	local _msg="$1"
	
	echo -e "$SCRIPT_NAME: $(tyellow)warning: $_msg$(treset)"
}

error() {
	local _msg="$1"
	
	echo -e "$SCRIPT_NAME: $(tred)error: $_msg$(treset)"
}

has_prefix() {
	local _s="$1"
	local _prefix="$2"
	
	if [[ -z "$_prefix" ]]; then
		return 0
		fi
		
		if [[ -z "$_s" ]]; then
			return 1
			fi
			
			[[ "x$_s" != "x${_s#"$_prefix"}" ]]
}

systemctl() {
	if [[ "x$FORCE_NO_SYSTEMD" == "x2" ]] || ! has_command systemctl; then
		return
		fi
		
		command systemctl "$@"
}

show_argument_error_and_exit() {
	local _error_msg="$1"
	
	error "$_error_msg"
	echo "Try \"$0 --help\" for the usage." >&2
	exit 22
}

install_content() {
	local _install_flags="$1"
	local _content="$2"
	local _destination="$3"
	
	local _tmpfile="$(mktemp)"
	
	echo -ne "Install $_destination ... "
	echo "$_content" > "$_tmpfile"
	if install "$_install_flags" "$_tmpfile" "$_destination"; then
		echo -e "ok"
		fi
		
		rm -f "$_tmpfile"
}

remove_file() {
	local _target="$1"
	
	echo -ne "Remove $_target ... "
	if rm "$_target"; then
		echo -e "ok"
		fi
}

exec_sudo() {
	# exec sudo with configurable environ preserved.
	local _saved_ifs="$IFS"
	IFS=$'\n'
	local _preserved_env=(
		$(env | grep "^PACKAGE_MANAGEMENT_INSTALL=" || true)
		$(env | grep "^OPERATING_SYSTEM=" || true)
		$(env | grep "^ARCHITECTURE=" || true)
		$(env | grep "^HYSTERIA_\w*=" || true)
		$(env | grep "^FORCE_\w*=" || true)
	)
	IFS="$_saved_ifs"
	
	exec sudo env \
	"${_preserved_env[@]}" \
	"$@"
}

detect_package_manager() {
	if [[ -n "$PACKAGE_MANAGEMENT_INSTALL" ]]; then
		return 0
		fi
		
		if has_command apt; then
			PACKAGE_MANAGEMENT_INSTALL='apt update; apt -y install'
			return 0
			fi
			
			if has_command dnf; then
				PACKAGE_MANAGEMENT_INSTALL='dnf check-update; dnf -y install'
				return 0
				fi
				
				if has_command yum; then
					PACKAGE_MANAGEMENT_INSTALL='yum update; yum -y install'
					return 0
					fi
					
					if has_command zypper; then
						PACKAGE_MANAGEMENT_INSTALL='zypper update; zypper install -y --no-recommends'
						return 0
						fi
						
						if has_command pacman; then
							PACKAGE_MANAGEMENT_INSTALL='pacman -Syu; pacman -Syu --noconfirm'
							return 0
							fi
							
							return 1
}

install_software() {
	local _package_name="$1"
	
	if ! detect_package_manager; then
		error "Supported package manager is not detected, please install the following package manually:"
		echo
		echo -e "\t* $_package_name"
		echo
		exit 65
		fi
		
		echo "Installing missing dependence '$_package_name' with '$PACKAGE_MANAGEMENT_INSTALL' ... "
		if $PACKAGE_MANAGEMENT_INSTALL "$_package_name"; then
			echo "ok"
			else
				error "Cannot install '$_package_name' with detected package manager, please install it manually."
				exit 65
				fi
}

is_user_exists() {
	local _user="$1"
	
	id "$_user" > /dev/null 2>&1
}

check_permission() {
	if [[ "$UID" -eq '0' ]]; then
		return
		fi
		
		note "The user currently executing this script is not root."
		
		case "$FORCE_NO_ROOT" in
		'1')
		warning "FORCE_NO_ROOT=1 is specified, we will process without root and you may encounter the insufficient privilege error."
		;;
	*)
	if has_command sudo; then
		note "Re-running this script with sudo, you can also specify FORCE_NO_ROOT=1 to force this script running with current user."
		exec_sudo "$0" "${SCRIPT_ARGS[@]}"
		else
			error "Please run this script with root or specify FORCE_NO_ROOT=1 to force this script running with current user."
			exit 13
			fi
			;;
		esac
}

check_environment_operating_system() {
	if [[ -n "$OPERATING_SYSTEM" ]]; then
		warning "OPERATING_SYSTEM=$OPERATING_SYSTEM is specified, opreating system detection will not be perform."
		return
		fi
		
		if [[ "x$(uname)" == "xLinux" ]]; then
			OPERATING_SYSTEM=linux
			return
			fi
			
			error "This script only supports Linux."
			note "Specify OPERATING_SYSTEM=[linux|darwin|freebsd|windows] to bypass this check and force this script running on this $(uname)."
			exit 95
}

check_environment_architecture() {
	if [[ -n "$ARCHITECTURE" ]]; then
		warning "ARCHITECTURE=$ARCHITECTURE is specified, architecture detection will not be performed."
		return
		fi
		
		case "$(uname -m)" in
		'i386' | 'i686')
		ARCHITECTURE='386'
		;;
	'amd64' | 'x86_64')
	ARCHITECTURE='amd64'
	;;
	'armv5tel' | 'armv6l' | 'armv7' | 'armv7l')
	ARCHITECTURE='arm'
	;;
	'armv8' | 'aarch64')
	ARCHITECTURE='arm64'
	;;
	'mips' | 'mipsle' | 'mips64' | 'mips64le')
	ARCHITECTURE='mipsle'
	;;
	's390x')
	ARCHITECTURE='s390x'
	;;
	*)
	error "The architecture '$(uname -a)' is not supported."
	note "Specify ARCHITECTURE=<architecture> to bypass this check and force this script running on this $(uname -m)."
	exit 8
	;;
	esac
}

check_environment_systemd() {
	if [[ -d "/run/systemd/system" ]] || grep -q systemd <(ls -l /sbin/init); then
		return
		fi
		
		case "$FORCE_NO_SYSTEMD" in
		'1')
		warning "FORCE_NO_SYSTEMD=1 is specified, we will process as normal even if systemd is not detected by us."
		;;
	'2')
	warning "FORCE_NO_SYSTEMD=2 is specified, we will process but all systemd related command will not be executed."
	;;
	*)
	error "This script only supports Linux distributions with systemd."
	note "Specify FORCE_NO_SYSTEMD=1 to disable this check and force this script running as systemd is detected."
	note "Specify FORCE_NO_SYSTEMD=2 to disable this check along with all systemd related commands."
	;;
	esac
}

check_environment_curl() {
	if has_command curl; then
		return
		fi
		apt update; apt -y install curl
}

check_environment_grep() {
	if has_command grep; then
		return
		fi
		apt update; apt -y install grep
}

check_environment() {
	check_environment_operating_system
	check_environment_architecture
	check_environment_systemd
	check_environment_curl
	check_environment_grep
}

vercmp_segment() {
	local _lhs="$1"
	local _rhs="$2"
	
	if [[ "x$_lhs" == "x$_rhs" ]]; then
		echo 0
		return
		fi
		if [[ -z "$_lhs" ]]; then
			echo -1
			return
			fi
			if [[ -z "$_rhs" ]]; then
				echo 1
				return
				fi
				
				local _lhs_num="${_lhs//[A-Za-z]*/}"
				local _rhs_num="${_rhs//[A-Za-z]*/}"
				
				if [[ "x$_lhs_num" == "x$_rhs_num" ]]; then
					echo 0
					return
					fi
					if [[ -z "$_lhs_num" ]]; then
						echo -1
						return
						fi
						if [[ -z "$_rhs_num" ]]; then
							echo 1
							return
							fi
							local _numcmp=$(($_lhs_num - $_rhs_num))
							if [[ "$_numcmp" -ne 0 ]]; then
								echo "$_numcmp"
								return
								fi
								
								local _lhs_suffix="${_lhs#"$_lhs_num"}"
								local _rhs_suffix="${_rhs#"$_rhs_num"}"
								
								if [[ "x$_lhs_suffix" == "x$_rhs_suffix" ]]; then
									echo 0
									return
									fi
									if [[ -z "$_lhs_suffix" ]]; then
										echo 1
										return
										fi
										if [[ -z "$_rhs_suffix" ]]; then
											echo -1
											return
											fi
											if [[ "$_lhs_suffix" < "$_rhs_suffix" ]]; then
												echo -1
												return
												fi
												echo 1
}

vercmp() {
	local _lhs=${1#v}
	local _rhs=${2#v}
	
	while [[ -n "$_lhs" && -n "$_rhs" ]]; do
		local _clhs="${_lhs/.*/}"
		local _crhs="${_rhs/.*/}"
		
		local _segcmp="$(vercmp_segment "$_clhs" "$_crhs")"
		if [[ "$_segcmp" -ne 0 ]]; then
			echo "$_segcmp"
			return
			fi
			
			_lhs="${_lhs#"$_clhs"}"
			_lhs="${_lhs#.}"
			_rhs="${_rhs#"$_crhs"}"
			_rhs="${_rhs#.}"
			done
			
			if [[ "x$_lhs" == "x$_rhs" ]]; then
				echo 0
				return
				fi
				
				if [[ -z "$_lhs" ]]; then
					echo -1
					return
					fi
					
					if [[ -z "$_rhs" ]]; then
						echo 1
						return
						fi
						
						return
}

check_hysteria_user() {
	local _default_hysteria_user="$1"
	
	if [[ -n "$HYSTERIA_USER" ]]; then
		return
		fi
		
		if [[ ! -e "$SYSTEMD_SERVICES_DIR/hysteria-server.service" ]]; then
			HYSTERIA_USER="$_default_hysteria_user"
			return
			fi
			
			HYSTERIA_USER="$(grep -o '^User=\w*' "$SYSTEMD_SERVICES_DIR/hysteria-server.service" | tail -1 | cut -d '=' -f 2 || true)"
			
			if [[ -z "$HYSTERIA_USER" ]]; then
				HYSTERIA_USER="$_default_hysteria_user"
				fi
}

check_hysteria_homedir() {
	local _default_hysteria_homedir="$1"
	
	if [[ -n "$HYSTERIA_HOME_DIR" ]]; then
		return
		fi
		
		if ! is_user_exists "$HYSTERIA_USER"; then
			HYSTERIA_HOME_DIR="$_default_hysteria_homedir"
			return
			fi
			
			HYSTERIA_HOME_DIR="$(eval echo ~"$HYSTERIA_USER")"
}


###
# ARGUMENTS PARSER
###

show_usage_and_exit() {
	echo
	echo -e "\t$(tbold)$SCRIPT_NAME$(treset) - AGN-UDP server install script"
	echo
	echo -e "Usage:"
	echo
	echo -e "$(tbold)Install AGN-UDP$(treset)"
	echo -e "\t$0 [ -f | -l <file> | --version <version> ]"
	echo -e "Flags:"
	echo -e "\t-f, --force\tForce re-install latest or specified version even if it has been installed."
	echo -e "\t-l, --local <file>\tInstall specified AGN-UDP binary instead of download it."
	echo -e "\t--version <version>\tInstall specified version instead of the latest."
	echo
	echo -e "$(tbold)Remove AGN-UDP$(treset)"
	echo -e "\t$0 --remove"
	echo
	echo -e "$(tbold)Check for the update$(treset)"
	echo -e "\t$0 -c"
	echo -e "\t$0 --check"
	echo
	echo -e "$(tbold)Show this help$(treset)"
	echo -e "\t$0 -h"
	echo -e "\t$0 --help"
	exit 0
}

parse_arguments() {
	while [[ "$#" -gt '0' ]]; do
		case "$1" in
		'--remove')
		if [[ -n "$OPERATION" && "$OPERATION" != 'remove' ]]; then
			show_argument_error_and_exit "Option '--remove' is conflicted with other options."
			fi
			OPERATION='remove'
			;;
		'--version')
		VERSION="$2"
		if [[ -z "$VERSION" ]]; then
			show_argument_error_and_exit "Please specify the version for option '--version'."
			fi
			shift
			if ! has_prefix "$VERSION" 'v'; then
				show_argument_error_and_exit "Version numbers should begin with 'v' (such like 'v1.3.1'), got '$VERSION'"
				fi
				;;
			 
			'-h' | '--help')
			show_usage_and_exit
			;;
			'-l' | '--local')
			LOCAL_FILE="$2"
			if [[ -z "$LOCAL_FILE" ]]; then
				show_argument_error_and_exit "Please specify the local binary to install for option '-l' or '--local'."
				fi
				break
				;;
			*)
			show_argument_error_and_exit "Unknown option '$1'"
			;;
			esac
			shift
			done
			
			if [[ -z "$OPERATION" ]]; then
				OPERATION='install'
				fi
				
				# validate arguments
				case "$OPERATION" in
				'install')
				if [[ -n "$VERSION" && -n "$LOCAL_FILE" ]]; then
					show_argument_error_and_exit '--version and --local cannot be specified together.'
					fi
					;;
				*)
				if [[ -n "$VERSION" ]]; then
					show_argument_error_and_exit "--version is only avaiable when install."
					fi
					if [[ -n "$LOCAL_FILE" ]]; then
						show_argument_error_and_exit "--local is only avaiable when install."
						fi
						;;
					esac
}


###
# FILE TEMPLATES
###

# /etc/systemd/system/hysteria-server.service
tpl_hysteria_server_service_base() {
  local _config_name="$1"

  cat << EOF
[Unit]
Description=AGN-UDP Service
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=/etc/hysteria
Environment="PATH=/usr/local/bin/hysteria"
ExecStart=/usr/local/bin/hysteria -config /etc/hysteria/config.json server

[Install]
WantedBy=multi-user.target
EOF
}

# /etc/systemd/system/hysteria-server.service
tpl_hysteria_server_service() {
  tpl_hysteria_server_service_base 'config'
}

# /etc/systemd/system/hysteria-server@.service
tpl_hysteria_server_x_service() {
  tpl_hysteria_server_service_base '%i'
}

# /etc/hysteria/config.json
tpl_etc_hysteria_config_json() {
  cat << EOF
{
  "server": "vpn.khaledagn.com",
   "listen": "$UDP_PORT",
  "protocol": "$PROTOCOL",
  "cert": "/etc/hysteria/hysteria.server.crt",
  "key": "/etc/hysteria/hysteria.server.key",
  "up": "100 Mbps",
  "up_mbps": 100,
  "down": "100 Mbps",
  "down_mbps": 100,
  "disable_udp": false,
  "obfs": "$OBFS",
  "auth": {
	"mode": "passwords",
	"config": ["$PASSWORD"]
         }
}
EOF
}


###
# SYSTEMD
###

get_running_services() {
	if [[ "x$FORCE_NO_SYSTEMD" == "x2" ]]; then
		return
		fi
		
		systemctl list-units --state=active --plain --no-legend \
		| grep -o "hysteria-server@*[^\s]*.service" || true
}

restart_running_services() {
	if [[ "x$FORCE_NO_SYSTEMD" == "x2" ]]; then
		return
		fi
		
		echo "Restarting running service ... "
		
		for service in $(get_running_services); do
			echo -ne "Restarting $service ... "
			systemctl restart "$service"
			echo "done"
			done
}

stop_running_services() {
	if [[ "x$FORCE_NO_SYSTEMD" == "x2" ]]; then
		return
		fi
		
		echo "Stopping running service ... "
		
		for service in $(get_running_services); do
			echo -ne "Stopping $service ... "
			systemctl stop "$service"
			echo "done"
			done
}


###
# HYSTERIA & GITHUB API
###

is_hysteria_installed() {
	# RETURN VALUE
	# 0: hysteria is installed
	# 1: hysteria is not installed
	
	if [[ -f "$EXECUTABLE_INSTALL_PATH" || -h "$EXECUTABLE_INSTALL_PATH" ]]; then
		return 0
		fi
		return 1
}

get_installed_version() {
	if is_hysteria_installed; then
		"$EXECUTABLE_INSTALL_PATH" -v | cut -d ' ' -f 3
		fi
}

get_latest_version() {
	if [[ -n "$VERSION" ]]; then
		echo "$VERSION"
		return
		fi
		
		local _tmpfile=$(mktemp)
		if ! curl -sS -H 'Accept: application/vnd.github.v3+json' "$API_BASE_URL/releases/latest" -o "$_tmpfile"; then
			error "Failed to get latest release, please check your network."
			exit 11
			fi
			
			local _latest_version=$(grep 'tag_name' "$_tmpfile" | head -1 | grep -o '"v.*"')
			_latest_version=${_latest_version#'"'}
			_latest_version=${_latest_version%'"'}
			
			if [[ -n "$_latest_version" ]]; then
				echo "$_latest_version"
				fi
				
				rm -f "$_tmpfile"
}

download_hysteria() {
	local _version="$1"
	local _destination="$2"
	
	local _download_url="$REPO_URL/releases/download/v1.3.5/hysteria-$OPERATING_SYSTEM-$ARCHITECTURE"
	echo "Downloading hysteria archive: $_download_url ..."
	if ! curl -R -H 'Cache-Control: no-cache' "$_download_url" -o "$_destination"; then
		error "Download failed! Please check your network and try again."
		return 11
		fi
		return 0
}

 

###
# ENTRY
###

perform_install_hysteria_binary() {
	if [[ -n "$LOCAL_FILE" ]]; then
		note "Performing local install: $LOCAL_FILE"
		
		echo -ne "Installing hysteria executable ... "
		
		if install -Dm755 "$LOCAL_FILE" "$EXECUTABLE_INSTALL_PATH"; then
			echo "ok"
			else
				exit 2
				fi
				
				return
				fi
				
				local _tmpfile=$(mktemp)
				
				if ! download_hysteria "$VERSION" "$_tmpfile"; then
					rm -f "$_tmpfile"
					exit 11
					fi
					
					echo -ne "Installing hysteria executable ... "
					
					if install -Dm755 "$_tmpfile" "$EXECUTABLE_INSTALL_PATH"; then
						echo "ok"
						else
							exit 13
							fi
							
							rm -f "$_tmpfile"
}

perform_remove_hysteria_binary() {
	remove_file "$EXECUTABLE_INSTALL_PATH"
}

perform_install_hysteria_example_config() {
install_content -Dm644 "$(tpl_etc_hysteria_config_json)" "$CONFIG_DIR/config.json" ""
 
}

perform_install_hysteria_systemd() {
	if [[ "x$FORCE_NO_SYSTEMD" == "x2" ]]; then
		return
		fi
		
		install_content -Dm644 "$(tpl_hysteria_server_service)" "$SYSTEMD_SERVICES_DIR/hysteria-server.service"
		install_content -Dm644 "$(tpl_hysteria_server_x_service)" "$SYSTEMD_SERVICES_DIR/hysteria-server@.service"
		
		systemctl daemon-reload
}

perform_remove_hysteria_systemd() {
	remove_file "$SYSTEMD_SERVICES_DIR/hysteria-server.service"
	remove_file "$SYSTEMD_SERVICES_DIR/hysteria-server@.service"
	
	systemctl daemon-reload
}

perform_install_hysteria_home_legacy() {
	if ! is_user_exists "$HYSTERIA_USER"; then
		echo -ne "Creating user $HYSTERIA_USER ... "
		useradd -r -d "$HYSTERIA_HOME_DIR" -m "$HYSTERIA_USER"
		echo "ok"
		fi
}

perform_install() {
	local _is_frash_install
	if ! is_hysteria_installed; then
		_is_frash_install=1
		fi
		
 						perform_install_hysteria_binary
						perform_install_hysteria_example_config
						perform_install_hysteria_home_legacy
						perform_install_hysteria_systemd
						setup_ssl
					    start_services
						if [[ -n "$_is_frash_install" ]]; then
						    clear
							hystban_me
							echo
							echo -e "$(tbold)Congratulation! Tesla UDP Hysteria has been successfully installed on your server.$(treset)"
							echo
							echo -e "$(tblue)https://play.google.com/store/apps/details?id=com.agn.injector$(treset)"
							echo
							echo -e "Follow me!"
							echo
							echo -e "\t+ Follow me on Telegram: $(tblue)https://t.me/teslassh$(treset)"
							echo -e "\t+ Follow me on Facebook: $(tblue)https://facebook.com/teslassh$(treset)"
							echo
							else
								restart_running_services
								start_services
								echo
								echo -e "$(tbold)Tesla UDP Hysteria has been successfully update to $VERSION.$(treset)"
								echo
								fi
}

perform_remove() {
	perform_remove_hysteria_binary
	stop_running_services
	perform_remove_hysteria_systemd
	
	echo
	clear
	hystban_me
	echo -e "$(tbold)Congratulation! Tesla UDP Hysteria has been successfully removed from your server.$(treset)"
	echo
	echo -e "You still need to remove configuration files and ACME certificates manually with the following commands:"
	echo
	echo -e "\t$(tred)rm -rf "$CONFIG_DIR"$(treset)"
	if [[ "x$HYSTERIA_USER" != "xroot" ]]; then
		echo -e "\t$(tred)userdel -r "$HYSTERIA_USER"$(treset)"
		fi
		if [[ "x$FORCE_NO_SYSTEMD" != "x2" ]]; then
		    clear
			hystban_me
			echo
			echo -e "You still might need to disable all related systemd services with the following commands:"
			echo
			echo -e "\t$(tred)rm -f /etc/systemd/system/multi-user.target.wants/hysteria-server.service$(treset)"
			echo -e "\t$(tred)rm -f /etc/systemd/system/multi-user.target.wants/hysteria-server@*.service$(treset)"
			echo -e "\t$(tred)systemctl daemon-reload$(treset)"
			fi
			echo
}

 


setup_ssl() {
	echo "Installing ssl"

	openssl genrsa -out /etc/hysteria/hysteria.ca.key 2048

	openssl req -new -x509 -days 3650 -key /etc/hysteria/hysteria.ca.key -subj "/C=CN/ST=GD/L=SZ/O=Hysteria, Inc./CN=Hysteria Root CA" -out /etc/hysteria/hysteria.ca.crt

	openssl req -newkey rsa:2048 -nodes -keyout /etc/hysteria/hysteria.server.key -subj "/C=CN/ST=GD/L=SZ/O=Hysteria, Inc./CN=$DOMAIN" -out /etc/hysteria/hysteria.server.csr

	openssl x509 -req -extfile <(printf "subjectAltName=DNS:$DOMAIN,DNS:$DOMAIN") -days 3650 -in /etc/hysteria/hysteria.server.csr -CA /etc/hysteria/hysteria.ca.crt -CAkey /etc/hysteria/hysteria.ca.key -CAcreateserial -out /etc/hysteria/hysteria.server.crt	
 }
start_services() {
	echo "Starting Hysteria Server"
	apt update
	sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v4 boolean true"
        sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v6 boolean true"
	apt -y install iptables-persistent
	iptables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 10000:65000 -j DNAT --to-destination $UDP_PORT
	ip6tables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 10000:65000 -j DNAT --to-destination $UDP_PORT
	sysctl net.ipv4.conf.all.rp_filter=0
	sysctl net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0 
	echo "net.ipv4.ip_forward = 1
	net.ipv4.conf.all.rp_filter=0
	net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0" > /etc/sysctl.conf  
	sysctl -p
        sudo iptables-save > /etc/iptables/rules.v4
        sudo ip6tables-save > /etc/iptables/rules.v6
	systemctl enable hysteria-server.service
	systemctl start hysteria-server.service	
}



main() {
parse_arguments "$@"
	check_permission
	check_environment
	check_hysteria_user "hysteria"
	check_hysteria_homedir "/var/lib/$HYSTERIA_USER"
	case "$OPERATION" in
	"install")
	perform_install
	;;
	"remove")
	perform_remove
	;;
	 
	*)
	error "Unknown operation '$OPERATION'."
	;;
	esac
}

main "$@"

# vim:set ft=bash ts=2 sw=2 sts=2 et:
