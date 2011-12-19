
#################################
#	Security                #
#################################

function set_open_ports
{
	#set open ports using ufw, and 
	#install fail2ban too while we're at it... 
	#(fail2ban temporarily blocks IPs that make a bunch of failed login attempts via ssh)
	aptitude install -y  fail2ban ufw
	
	#up the max fail2ban attempts to 12, since I can be a bit dimwitted at times...
	cat /etc/fail2ban/jail.conf | sed 's/maxretry.*/maxretry = 12/g' > /etc/fail2ban/jail.conf.tmp
	mv /etc/fail2ban/jail.conf.tmp /etc/fail2ban/jail.conf 

	#reset, removing all old rules
	printf "y\ny\ny\n" | ufw reset

	#always allow ssh
	ufw default deny
	ufw allow ssh
	ufw logging on

	#set allowed ports
	while [ -n "$1" ] ; do
		ufw allow "$1"
		shift
	done
	
	#enable firewall
	printf "y\ny\ny\n" | ufw enable
}


