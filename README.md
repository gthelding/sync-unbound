# sync-unbound
## What is this?
I wrote this script to keep the local configs synced between the two unbound recursive DNS servers. From the standpoint of the script, it is running on the local server and the remote server has the master config. The script every 15 minutes as a cron job, only updating the config if there is a change. If I want to add some local records, I edit the master config and wait (at most) 15 minutes for both machines to be in sync.

I'm storing the script here mostly so I can get it when I need it. Of course, anyone shoud feel free to borrow it or make changes. It's no great shakes, but some might find it useful. It could be used to sync any two instances of a service that is controlled by systemd and uses a single text file for a config.

## How do you use it?
Pull down the sync-unbound.sh script and edit it to change the values for the remote host (source of config file), remote user, and  SSH key. I run the script using a cron job, but you could also set it up using systemd timers or run it manually whenever you change the master config.

## Why did I write it?
I use two pi-hole servers on my local network to provide DNS services. On each of them, I run an unbound recursive DNS server. Unbound lets you specify local A records in its config. I use that feature to let me resolve local names (e.g., nextcloud resolves to 192.168.1.10) without getting too fancy and without putting RFC1918 IPs in my domain's public records. Like any good homelabber, I make plenty of changes and I was looking for a way to keep the configs synced between the two servers. As the name suggests, unbound isn't BIND and has no master/slave zone capabilties.

Cheers,
Greg
