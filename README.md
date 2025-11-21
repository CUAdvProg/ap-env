# Advanced Programming – Standard Docker Environment

This repository provides the **standard development environment** for Advanced Programming.

All students (macOS, Windows with WSL, and Linux) will:

- Use the **same Ubuntu-based Docker image**.
- Run with the **same resource limits**: 4 CPU cores, 4 GB RAM, 16 GB container disk.
- Build and test their C code **inside the container**, not on the host.

That way:

- If your code runs in this container on your machine, it will run the same way when we grade it.
- TAs use the *exact same* image and resource limits for the autograder.

---

## 🔽 TL;DR – Quick Start

### macOS (Intel or Apple Silicon)

1. Install [Homebrew](https://brew.sh) if you don’t have it.
2. In the assignment folder, run:

   ```bash
   chmod +x setup_docker.sh
   ./setup_docker.sh
   
3.	If Docker isn’t installed, the script will install Docker Desktop and then tell you to open it once. After Docker is running, run the script again.
4.	You’ll end up inside the course container at /work. Compile and run code there.

⸻

Windows (WSL required)
	1.	Install WSL with Ubuntu (only once – see detailed instructions below).
	2.	Open the Ubuntu app from the Start Menu.
	3.	Inside Ubuntu, clone your assignment repo and run:

```bash
cd <your-assignment-repo>
chmod +x setup_docker.sh
./setup_docker.sh
```

4.	If Docker isn’t installed in WSL, the script will install it, then tell you to close and reopen Ubuntu and run the script again.
5.	Once inside the container at /work, do all compilation and testing there.

⸻

Linux (optional section, if applicable)
	1.	Make sure you have git installed.
	2.	In the assignment folder, run:

```bash
chmod +x setup_docker.sh
./setup_docker.sh
```

3.	The script will install Docker Engine if needed, then pull the course image and start the container.

⸻

1. What This Environment Does
	•	Uses a Docker image (e.g. ghcr.io/columbia-advprog-2025/ap-course-env:latest) based on Ubuntu 24.04.
	•	Installs tools we use in the course:
	•	gcc, clang, make, gdb, valgrind, git, vim, etc.
	•	Enforces identical resource limits for everyone:

```docker
docker run --rm \
  --platform=linux/amd64 \
  --cpus="4" \
  --memory="4g" \
  --storage-opt size=16G \
  -v "$PWD":/work \
  -w /work \
  ghcr.io/columbia-advprog-2025/ap-course-env:latest \
  /bin/bash
```

•	Mounts your assignment folder into the container at /work.

You should think of the container as your course Linux server, running locally on your machine.

⸻

2. Prerequisites (General)

Regardless of OS, you’ll need:
•	An internet connection.
•	Basic command-line usage (we’ll guide you; you don’t need to be an expert).
•	The ability to install software on your machine (admin rights).

You do not need to install Ubuntu as a dual-boot or VM.
Windows users will use WSL; macOS users will use Docker Desktop; Linux users use Docker Engine.

⸻

3. macOS – Detailed Instructions

3.1. Confirm your macOS version and architecture
	•	macOS 12+ (Monterey or newer) is recommended.
	•	Works on both:
	•	Intel Macs
	•	Apple Silicon (M1/M2/M3) – Docker will emulate linux/amd64 for consistency.

To check your chip:
	•	Click  → “About This Mac” → look for “Intel” or “Apple M1/M2/M3”.

3.2. Install Homebrew (if you don’t have it)

Open Terminal and run:

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

Follow the on-screen instructions. After installation, make sure brew works:

brew --version

3.3. Clone the assignment repo

In Terminal:

```bash
cd ~/some/folder/for/course
git clone <your-assignment-repo-url>
cd <your-assignment-repo>
```

You should see setup_docker.sh in the repo.

3.4. Run the setup script

In the assignment directory:

```bash
chmod +x setup_docker.sh
./setup_docker.sh
```

The script will:
	1.	Check if docker is installed.
	2.	If not installed:
	•	Use Homebrew to install Docker Desktop.
	•	Tell you to:
	•	Open the “Docker” app from /Applications.
	•	Wait until it shows “Docker is running”.
	•	Then re-run ./setup_docker.sh.
	3.	Once Docker is running, it will:
	•	Pull the course image.
	•	Start the container with 4 CPUs / 4 GB RAM / 16 GB disk.
	•	Drop you into a shell at /work.

3.5. Using the environment (macOS)

Inside the container (you’ll see a bash prompt):

```bash
cd /work
ls             # should show your assignment files
make           # compile
./my_program   # run
valgrind ./my_program   # memory checks (for appropriate assignments)
```

All compilation and tests must be run inside this environment.
If it compiles and passes tests here, that’s what we will use for grading.

To exit:

`exit`

The container will stop; your files remain in your normal filesystem.

⸻

4. Windows (with WSL) – Detailed Instructions

We require Windows users to use WSL (Windows Subsystem for Linux) with Ubuntu.

4.1. Install WSL and Ubuntu (only once)
	1.	Open PowerShell as Administrator:
	•	Press Start, type “PowerShell”.
	•	Right-click “Windows PowerShell” → “Run as administrator”.
	2.	In PowerShell, run:
  

`wsl --install`


If you already have WSL, you might see a message saying it’s installed; that’s fine.

3.	Restart your computer if prompted.
4.	After reboot, Windows will automatically open an Ubuntu window the first time.
   
If not, open the “Ubuntu” app from the Start Menu manually.
	5.	In the Ubuntu window, set up:
	•	A username (this is your Linux/WSL username, not necessarily your UNI).
	•	A password (this is local to WSL).

You now have a full Linux environment available on your Windows machine.

4.2. Clone the assignment repo inside WSL

Open the Ubuntu app again (from Start Menu). In the Ubuntu terminal:

```bash
cd ~
mkdir -p courses/advprog
cd courses/advprog

git clone <your-assignment-repo-url>
cd <your-assignment-repo>
```

Important: Always work inside the WSL filesystem (paths like /home/yourname/...), not in /mnt/c/..., for best performance and fewer permission issues.

You should see setup_docker.sh in the repo.

4.3. Run the setup script (WSL)

In your assignment directory inside Ubuntu:

```bash
chmod +x setup_docker.sh
./setup_docker.sh
```

The script will:
	1.	Detect that it’s on Linux/WSL.
	2.	Check if docker is installed in WSL.
	3.	If Docker is not installed:
	•	Use the official Docker install script to install Docker Engine.
	•	Add your WSL user to the docker group.
	•	Tell you to:
	•	Close the Ubuntu window.
	•	Re-open Ubuntu.
	•	Navigate back to your assignment directory.
	•	Re-run ./setup_docker.sh.
	4.	Once Docker is installed and usable:
	•	Pull the course image.
	•	Start the container with 4 CPUs / 4 GB RAM / 16 GB disk.
	•	Drop you into a shell at /work.

4.4. Using the environment (Windows + WSL)

Once the container is running, your prompt is inside the container:

```bash
cd /work
ls             # should show your assignment files
make           # compile
./my_program   # run
valgrind ./my_program
```

As with macOS: all compilation and testing should be done inside this container.
We will grade using the same container and limits.

To exit:

`exit`

The container stops; your code remains in your repo.

⸻

5. Linux – Detailed Instructions (if relevant for your class)

If you’re on a native Linux machine (not WSL):

5.1. Install Git

On Ubuntu/Debian:

```bash
sudo apt-get update
sudo apt-get install -y git
```

5.2. Clone the assignment repo

```bash
cd ~
git clone <your-assignment-repo-url>
cd <your-assignment-repo>
```

5.3. Run the setup script

```bash
chmod +x setup_docker.sh
./setup_docker.sh
```

The script will:
	•	Install Docker Engine via the official convenience script if needed.
	•	Add your user to the docker group and ask you to log out and back in (if it just installed Docker).
	•	Pull the course image.
	•	Start the container in the same standard configuration.

Usage inside the container is identical to the macOS/WSL instructions above.

⸻

6. What You Do Inside the Container

Inside the container, you always work in /work:

```bash
cd /work
ls
```

Typical workflow:
	1.	Edit code (you can edit on the host using your editor/IDE; files are shared).
	2.	Enter the container with ./setup_docker.sh.
	3.	In the container:

```bash
cd /work
make
./your_program
```

4.	Run any provided test scripts, e.g.:


`./run_public_tests.sh`

5.	Fix issues, rerun tests until everything passes.

When you’re done:

`exit`

Then commit/push to GitHub from either:
	•	the host (macOS/WSL/Linux) or
	•	inside the container (since git is installed there too).

⸻

7. Troubleshooting

7.1. “Docker command not found”
	•	On macOS: you likely haven’t completed Docker Desktop installation:
	•	Install Homebrew.
	•	Run ./setup_docker.sh again; it will install Docker Desktop.
	•	Then open Docker from Applications and wait until it says “Docker is running”.
	•	Re-run ./setup_docker.sh.
	•	On Windows (WSL):
	•	Run ./setup_docker.sh inside Ubuntu.
	•	Follow its instructions if it installs Docker (close and reopen Ubuntu, then re-run).

7.2. “Permission denied” when running setup_docker.sh

Make sure it’s executable:

```bash
chmod +x setup_docker.sh
./setup_docker.sh
```

7.3. “Permission denied” when using Docker on Linux/WSL

Your user might not be in the docker group yet. Either:
	•	Log out and log back in (recommended), or
	•	Temporarily run with sudo:

`sudo docker run ...`


The script already tries to add you to the docker group; logging out/in is needed for it to take effect.

7.4. “Docker is running, but the script still fails”
	•	macOS: ensure Docker Desktop has finished starting (whale icon with no “starting…” indicator).
	•	Windows (WSL): make sure you’re running the script inside Ubuntu, not PowerShell or CMD.
	•	If you get specific error messages, copy them and ask in the course forum / office hours.

⸻

8. Fairness and Grading Policy
	•	All students are required to run their code inside this Docker environment.
	•	We will grade using:
	•	The same Docker image.
	•	The same resource limits:
	•	4 CPUs
	•	4 GB RAM
	•	16 GB container disk.
	•	If your code:
	•	Compiles and runs correctly inside this container, and
	•	Passes the public tests,
then it should behave the same way for us when we run the autograder.

If your program only works outside this container (e.g., using different compilers or flags) but fails inside, we grade based on its behavior inside the standard environment.


If you’d like, I can also add a short “For TAs” section at the bottom describing how you build/publish the image and how the autograder will call `docker run` with the same flags.
