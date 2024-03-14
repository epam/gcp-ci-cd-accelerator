# Copyright 2023 EPAM Systems
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "kubernetes_namespace" "reportportal" {
  metadata {
    name = var.reportportal_namespace
  }
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami"
  namespace  = kubernetes_namespace.reportportal.metadata.0.name

  chart   = "postgresql"
  version = var.postgresql_version

  set {
    name  = "postgresqlUsername"
    value = var.pg_user
  }
  set {
    name  = "postgresqlPassword"
    value = var.pg_pass
  }
  set {
    name  = "postgresqlPostgresPassword"
    value = var.pg_pass
  }
  set {
    name  = "postgresqlDatabase"
    value = var.pg_db
  }

  values = [
    "${
      <<EOF
      initdbScripts:
        init_postgres.sh: |
          #!/bin/sh
          /opt/bitnami/postgresql/bin/psql -U postgres -d $${POSTGRES_DB} -c 'CREATE EXTENSION IF NOT EXISTS ltree; CREATE EXTENSION IF NOT EXISTS pgcrypto; CREATE EXTENSION IF NOT EXISTS pg_trgm;'
      EOF
    }"
  ]
}

resource "helm_release" "rabbit" {
  name       = "rabbitmq"
  repository = "https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami"
  namespace  = kubernetes_namespace.reportportal.metadata.0.name

  chart   = "rabbitmq"
  version = var.rabbit_version

  set {
    name  = "auth.username"
    value = var.rabbit_user
  }
  set {
    name  = "auth.password"
    value = var.rabbit_pass
  }
}

resource "helm_release" "elastic" {
  name       = "elastic"
  repository = "https://helm.elastic.co"
  namespace  = kubernetes_namespace.reportportal.metadata.0.name

  chart   = "elasticsearch"
  version = var.elastic_version

  set {
    name  = "replicas"
    value = var.elastic_replicas
  }

  values = var.elastic_replicas != "1" ? [] : [
    "${
      <<EOF
      extraEnvs:
        - name: discovery.type
          value: single-node
        - name: cluster.initial_master_nodes
          value: ""
      EOF
    }"
  ]
}

resource "helm_release" "minio" {
  name       = "minio"
  repository = "https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami"
  namespace  = kubernetes_namespace.reportportal.metadata.0.name

  chart   = "minio"
  version = var.minio_version

  set {
    name  = "accessKey.password"
    value = var.minio_user
  }
  set {
    name  = "secretKey.password"
    value = var.minio_pass
  }
  set {
    name  = "persistence.size"
    value = var.minio_persistence_size
  }
}

resource "helm_release" "reportportal" {
  name       = "reportportal"
  chart      = "reportportal"
  repository = "https://reportportal.github.io/kubernetes"
  namespace  = kubernetes_namespace.reportportal.metadata.0.name
  version    = var.reportportal_version

  dependency_update = true
  timeout           = 600

  set {
    name  = "postgresql.endpoint.address"
    value = "${helm_release.postgresql.name}.${kubernetes_namespace.reportportal.metadata.0.name}.svc.cluster.local"
  }
  set {
    name  = "postgresql.SecretName"
    value = helm_release.postgresql.name
  }
  set {
    name  = "elasticsearch.endpoint"
    value = "http://elasticsearch-master.${kubernetes_namespace.reportportal.metadata.0.name}.svc.cluster.local:9200"
  }
  set {
    name  = "rabbitmq.endpoint.address"
    value = "${helm_release.rabbit.name}.${kubernetes_namespace.reportportal.metadata.0.name}.svc.cluster.local"
  }
  set {
    name  = "rabbitmq.SecretName"
    value = helm_release.rabbit.name
  }
  set {
    name  = "minio.endpoint"
    value = "http://${helm_release.minio.name}.${kubernetes_namespace.reportportal.metadata.0.name}.svc.cluster.local:9000"
  }
  set {
    name  = "minio.endpointshort"
    value = "${helm_release.minio.name}.${kubernetes_namespace.reportportal.metadata.0.name}.svc.cluster.local:9000"
  }
  set {
    name  = "minio.secretName"
    value = helm_release.minio.name
  }

  set {
    name  = "ingress.enable"
    value = true
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx-reportportal"
    type  = "string"
  }

  values = [templatefile("${path.module}/reportportal_values.tpl", {
    SERVICEINDEX_REPOSITORY    = var.reportportal_serviceindex_image_repository,
    SERVICEINDEX_TAG           = var.reportportal_serviceindex_image_tag,
    UAT_REPOSITORY             = var.reportportal_uat_image_repository,
    UAT_TAG                    = var.reportportal_uat_image_tag,
    SERVICEUI_REPOSITORY       = var.reportportal_serviceui_image_repository,
    SERVICEUI_TAG              = var.reportportal_serviceui_image_tag,
    SERVICEAPI_REPOSITORY      = var.reportportal_serviceapi_image_repository,
    SERVICEAPI_TAG             = var.reportportal_serviceapi_image_tag,
    SERVICEJOBS_REPOSITORY     = var.reportportal_servicejobs_image_repository,
    SERVICEJOBS_TAG            = var.reportportal_servicejobs_image_tag,
    MIGRATIONS_REPOSITORY      = var.reportportal_migrations_image_repository,
    MIGRATIONS_TAGS            = var.reportportal_migrations_image_tag,
    SERVICEANALYZER_REPOSITORY = var.reportportal_serviceanalyzer_image_repository,
    SERVICEANALYZER_TAG        = var.reportportal_serviceanalyzer_image_tag,
    METRICSGATHERER_REPOSITORY = var.reportportal_metricsgatherer_image_repository,
    METRICSGATHERER_TAG        = var.reportportal_metricsgatherer_image_tag,
  })]
}

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx-reportportal"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.ingress_nginx_version

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "controller.ingressClass"
    value = "nginx-reportportal"
  }

  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx-reportportal"
  }

}
