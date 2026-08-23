# NOTE: The original design ran this via the "docker" driver, pointing
# at the devops-intern-final-hello image from Step 3. On native Windows,
# Nomad's docker driver only supports Windows containers, while our
# image (python:3.12-slim) is a Linux container -- so the docker driver
# reports "unhealthy" on this host and cannot run it. This is a Windows
# platform limitation, not something fixable in the job file.
#
# As a working alternative, this job uses the "raw_exec" driver to run
# the same hello.py logic directly (inlined via a template, so no
# machine-specific file paths are needed).
#
# The script also loops with a short sleep instead of printing once and
# exiting. A `type = "service"` job expects a long-running process --
# a script that exits immediately (even with exit code 0) is treated
# as a crash and gets restarted repeatedly until Nomad marks it failed.
# Looping keeps it alive, matching what "service" actually means here.

job "hello" {
  datacenters = ["dc1"]
  type        = "service"

  group "hello-group" {
    count = 1

    task "hello-task" {
      driver = "raw_exec"

      template {
        data        = <<EOT
import time
while True:
    print("Hello, DevOps!")
    time.sleep(5)
EOT
        destination = "local/hello.py"
      }

      config {
        command = "python"
        args    = ["local/hello.py"]
      }

      resources {
        cpu    = 100  # MHz
        memory = 128  # MB
      }
    }
  }
}