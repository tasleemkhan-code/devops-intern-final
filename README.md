# DevOps Intern Final Assessment

**Name:** Tasleem
**Date:** August 17, 2026
**Description:** A small but complete DevOps pipeline built with open-source tools — from a simple Python script, through containerization, CI/CD automation, job orchestration with Nomad, and log monitoring with Grafana Loki. Each step's output feeds into the next, simulating a realistic (if scaled-down) DevOps workflow.

![CI](https://github.com/<your-username>/devops-intern-final/actions/workflows/ci.yml/badge.svg)

> Replace `<your-username>` above and throughout this README with your actual GitHub username once the repo is pushed, so the badge and links resolve correctly.

---

## Project Structure

```
devops-intern-final/
├── hello.py
├── Dockerfile
├── scripts/
│   └── sysinfo.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── nomad/
│   └── hello.nomad
├── monitoring/
│   └── loki_setup.txt
└── README.md
```

---

## Step 1 — Git & GitHub Setup

Repository initialized with this README and `hello.py`, which prints:

```
Hello, DevOps!
```

Run it directly with:

```bash
python hello.py
```

---

## Step 2 — Linux & Scripting Basics

`scripts/sysinfo.sh` prints basic system information: current user, current date, and disk usage.

Run it with:

```bash
chmod +x scripts/sysinfo.sh
./scripts/sysinfo.sh
```

Sample output:

```
===== SYSTEM INFO =====
Current User : tasleem
Current Date : Mon Aug 17 17:14:05 UTC 2026
Disk Usage   :
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda        252G  8.6G   10G  47% /
========================
```

---

## Step 3 — Docker Basics

`Dockerfile` containerizes `hello.py` using a slim Python base image.

**Build the image:**

```bash
docker build -t devops-intern-final-hello .
```

**Run the container:**

```bash
docker run --rm devops-intern-final-hello
```

**Expected output:**

```
Hello, DevOps!
```

---

## Step 4 — CI/CD with GitHub Actions

`.github/workflows/ci.yml` defines a workflow that automatically runs `python hello.py` on every push and pull request to `main`.

Check the **Actions** tab on GitHub after pushing to see it run. The badge at the top of this README reflects the latest run status.

---

## Step 5 — Job Deployment with Nomad

`nomad/hello.nomad` defines a `service`-type Nomad job that runs the Docker image built in Step 3, with minimal CPU (100 MHz) and memory (128 MB) allocated.

**Prerequisites:** a running Nomad agent (dev mode is enough for local testing):

```bash
nomad agent -dev
```

**Run the job:**

```bash
nomad job run nomad/hello.nomad
```

**Check status / logs:**

```bash
nomad job status hello
nomad alloc logs <alloc-id>
```

---

## Step 6 — Monitoring with Grafana Loki

Loki by itself only **stores** logs — it doesn't collect them. The
actual collection is done by **Promtail**, which discovers running
Docker containers and pushes their logs to Loki. `docker-compose.monitoring.yml`
runs all of it together: Loki, Promtail, Grafana, and the `hello`
container (looped, so it keeps producing log lines to watch).

**Start the whole monitoring stack:**

```bash
docker compose -f docker-compose.monitoring.yml up -d --build
```

**View logs in Grafana:**
1. Open `http://localhost:3000`
2. Add a Loki data source pointing at `http://loki:3100`
3. Go to Explore, query `{container="hello-app"}`
4. "Hello, DevOps!" lines should appear, refreshing every ~5s

**Or query directly with LogCLI:**

```bash
logcli query '{container="hello-app"}' --addr="http://localhost:3100"
```

Full details in `monitoring/loki_setup.txt` and the Promtail scrape
config in `monitoring/promtail-config.yaml`.

**Shut down:**

```bash
docker compose -f docker-compose.monitoring.yml down
```

*(Screenshot of Grafana Explore view showing live log lines goes in `monitoring/loki_screenshot.png`.)*

---

## Verification / Evidence

This section records proof that each step was actually run, not just
written. Screenshots referenced below live alongside this README or
in their step's folder.

| Step | Verified by running | Screenshot / evidence |
|------|---------------------|------------------------|
| 3 — Docker | `docker build` + `docker run`, output was `Hello, DevOps!` | `docker_run_output.png` |
| 4 — CI/CD | Pushed to `main`, checked Actions tab for a green run | `ci_run_success.png` |
| 5 — Nomad | `nomad job run nomad/hello.nomad` + `nomad job status hello` | `nomad_status.png` |
| 6 — Loki | `docker compose -f docker-compose.monitoring.yml up`, confirmed log lines in Grafana Explore | `monitoring/loki_screenshot.png` |

*(Fill in this table with actual filenames once each screenshot is taken and committed.)*

---

## Step 7 — Extra Credit (Optional)

Not attempted in this submission. Possible future additions:
- MLflow experiment tracking (`mlflow/` folder)
- Running the full pipeline inside a VirtualBox VM (`vm/` folder)

---

## Summary

| Step | Tool | Output |
|------|------|--------|
| 1 | Git & GitHub | Repo, README, `hello.py` |
| 2 | Linux/Bash | `scripts/sysinfo.sh` |
| 3 | Docker | `Dockerfile`, working container |
| 4 | GitHub Actions | `.github/workflows/ci.yml`, CI badge |
| 5 | Nomad | `nomad/hello.nomad` |
| 6 | Grafana Loki | `monitoring/loki_setup.txt` |
