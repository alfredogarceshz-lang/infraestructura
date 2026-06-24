locals {
  # ---------------------------------------------------------------------------
  # Configuración de particionado de tablas externas (Bronze)
  # - mode: AUTO | STRINGS | CUSTOM
  # - Para particionar por un campo específico, usar mode = "CUSTOM" y definir
  #   source_uri_prefix con el placeholder del campo, por ejemplo:
  #   gs://bucket/source/table/{event_date:DATE}
  # ---------------------------------------------------------------------------
  bronze_partitioning_default = {
    mode                    = "AUTO"
    require_partition_filter = true
  }

  # Override por tabla: llave "<source>.<table>"
  # Ejemplo:
  # bronze_partitioning_overrides = {
  #   "erp_com.sch_empleados" = {
  #     mode                    = "CUSTOM"
  #     source_uri_prefix       = "gs://${module.naming.bucket_bronze}/erp_com/sch_empleados/{fecha_proceso:DATE}"
  #     require_partition_filter = true
  #   }
  # }
  bronze_partitioning_overrides = {}

  # Registro de fuentes bronze: cada fuente puede tener una carpeta con N schemas.
  bronze_external_sources = {
    erp_com = {
      dataset_id = "gim_dataset_brz_dev"
    }
  }

  # Construye tablas externas leyendo todos los *.json en schemas/bronze/<source>/.
  # Soporta múltiples fuentes sin crecer el main.tf o usar archivos tfvars gigantes.
  external_tables = merge([
    for source, cfg in local.bronze_external_sources : {
      for schema_file in fileset("${path.module}/schemas/bronze/${source}", "*.json") :
      "${source}__${trimsuffix(schema_file, ".json")}" => {
        table_id          = trimsuffix(schema_file, ".json")
        dataset_id        = cfg.dataset_id
        source_uris       = ["gs://${module.naming.bucket_bronze}/${source}/${trimsuffix(schema_file, ".json")}/year=*/month=*/day=*/*.parquet"]
        source_uri_prefix = try(local.bronze_partitioning_overrides["${source}.${trimsuffix(schema_file, ".json")}"].source_uri_prefix, "gs://${module.naming.bucket_bronze}/${source}/${trimsuffix(schema_file, ".json")}")
        hive_partitioning_mode = try(local.bronze_partitioning_overrides["${source}.${trimsuffix(schema_file, ".json")}"].mode, local.bronze_partitioning_default.mode)
        require_partition_filter = try(local.bronze_partitioning_overrides["${source}.${trimsuffix(schema_file, ".json")}"].require_partition_filter, local.bronze_partitioning_default.require_partition_filter)
        schema            = jsondecode(file("${path.module}/schemas/bronze/${source}/${schema_file}"))
      }
    }
  ]...)

  # Registro de fuentes silver para tablas Apache Iceberg.
  silver_iceberg_sources = {
    erp_com = {
      dataset_id = "gim_dataset_slv_dev"
    }
  }

  # Construye tablas Iceberg leyendo schemas/silver/<source>/.
  # Se espera la metadata Iceberg en /metadata/v1.metadata.json por tabla.
  iceberg_tables = merge([
    for source, cfg in local.silver_iceberg_sources : {
      for schema_file in fileset("${path.module}/schemas/silver/${source}", "*.json") :
      "${source}__${trimsuffix(schema_file, ".json")}" => {
        table_id    = trimsuffix(schema_file, ".json")
        dataset_id  = cfg.dataset_id
        source_uris = ["gs://${module.naming.bucket_silver}/${source}/${trimsuffix(schema_file, ".json")}/metadata/v1.metadata.json"]
        # Referencial: el particionado real se define en la metadata Iceberg.
        partition_fields = []
        schema      = jsondecode(file("${path.module}/schemas/silver/${source}/${schema_file}"))
      }
    }
  ]...)
}
