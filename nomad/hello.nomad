job "hello" {
  datacenters = ["dc1"]
  type        = "service"

  group "hello-group" {
    count = 1

    task "hello-task" {
      driver = "docker"

      config {
        image = "devops-intern-final-hello:latest"
      }

      resources {
        cpu    = 100  # MHz
        memory = 128  # MB
      }
    }
  }
}
