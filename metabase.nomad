job "metabase" {
  region = "Almaty"
  datacenters = ["prod-roza", "prod-abay"]

  type = "service"

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    canary = 0
  }
  
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  
  group "metabase" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    ephemeral_disk {
      size = 300
    }

    task "metabase" {
      leader = true
      driver = "docker"

      config {
        image = "registry.query.consul:5000/platform/metabase:v0.33.0"
        // force_pull = true
        // hostname = "metabase.cloud.halykbank.nb"
        port_map {
          http = 3000
        }
      }

      env {
        MB_DB_CONNECTION_URI = "YOUR_DB_URI"
        http_proxy = "PROXY"
        https_proxy = "PROXY"
        JAVA_OPTS = "-Dhttp.proxyHost=proxy-host -Dhttp.proxyPort=8080 -Dhttps.proxyHost=proxy-host -Dhttps.proxyPort=proxy-host-Xms2048m -Xmx2048m"
      }

      resources {
        memory = 2048
        network {
          port "http" {}
        }
      }

      service {
        name = "metabase"
        tags = [
          "traefik.enable=true"
        ]
        port = "http"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
