resource "aws_glue_catalog_database" "obsidian_module_outputs" {
  name = "obsidian_module_outputs"

  tags = {
    Environment = "var.environment"
  }
}

resource "aws_glue_catalog_database" "obsidian_raw_tags" {
  name = "obsidian_raw_tags"

  tags = {
    Environment = "var.environment"
  }
}

resource "aws_glue_catalog_table" "all_module_outputs" {
  name          = "all_module_outputs"
  database_name = aws_glue_catalog_database.obsidian_module_outputs.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-all-module-outputs.id}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "module"
      type = "string"
    }

    columns {
      name = "groupid"
      type = "string"
    }

    columns {
      name = "groupname"
      type = "string"
    }

    columns {
      name = "subgroupid"
      type = "string"
    }

    columns {
      name = "subgroupname"
      type = "string"
    }

    columns {
      name = "dataarchiveserver"
      type = "string"
    }

    columns {
      name = "pointsource"
      type = "string"
    }

    columns {
      name = "instrumenttag"
      type = "string"
    }

    columns {
      name = "exdesc"
      type = "string"
    }

    columns {
      name = "location1"
      type = "string"
    }

    columns {
      name = "location4"
      type = "string"
    }

    columns {
      name = "scan"
      type = "boolean"
    }

    columns {
      name = "pipointid"
      type = "int"
    }

    columns {
      name = "outputtype"
      type = "string"
    }

    columns {
      name = "outputdate"
      type = "string"
    }

    columns {
      name = "pipointcreationdate"
      type = "string"
    }

    columns {
      name = "pipointcreator"
      type = "string"
    }

    columns {
      name = "pipointlastchangedate"
      type = "string"
    }

    columns {
      name = "pipointlastchanger"
      type = "string"
    }

    columns {
      name = "tagname"
      type = "string"
    }
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"   = "true"
    "projection.date.type" = "injected"
  }
}

resource "aws_glue_catalog_table" "dataquality_module_outputs" {
  name          = "dataquality_module_outputs"
  database_name = aws_glue_catalog_database.obsidian_module_outputs.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-module-outputs.id}/module=DATA_QUALITY/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "outputdetails"
      type = "struct<informationMessage:string,warningType:string,upperLimit:string,lowerLimit:string,tagValue:string>"
    }

    columns {
      name = "latestvalue"
      type = "struct<timestamp:string>"
    }

    columns {
      name = "module"
      type = "string"
    }

    columns {
      name = "groupname"
      type = "string"
    }

    columns {
      name = "subgroupname"
      type = "string"
    }

    columns {
      name = "dataarchiveserver"
      type = "string"
    }

    columns {
      name = "pointsource"
      type = "string"
    }

    columns {
      name = "instrumenttag"
      type = "string"
    }

    columns {
      name = "exdesc"
      type = "string"
    }

    columns {
      name = "location1"
      type = "string"
    }

    columns {
      name = "location4"
      type = "string"
    }

    columns {
      name = "scan"
      type = "boolean"
    }

    columns {
      name = "pipointid"
      type = "int"
    }

    columns {
      name = "outputtype"
      type = "string"
    }

    columns {
      name = "outputdate"
      type = "string"
    }

    columns {
      name = "pipointcreationdate"
      type = "string"
    }

    columns {
      name = "pipointcreator"
      type = "string"
    }

    columns {
      name = "pipointlastchangedate"
      type = "string"
    }

    columns {
      name = "pipointlastchanger"
      type = "string"
    }

    columns {
      name = "tagname"
      type = "string"
    }
  }

  partition_keys {
    name = "group_id"
    type = "string"
  }

  partition_keys {
    name = "subgroup_id"
    type = "string"
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"          = "true"
    "projection.group_id.type"    = "injected"
    "projection.subgroup_id.type" = "injected"
    "projection.date.type"        = "injected"
  }
}

resource "aws_glue_catalog_table" "datacollectionfrequency_module_outputs" {
  name          = "datacollectionfrequency_module_outputs"
  database_name = aws_glue_catalog_database.obsidian_module_outputs.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-module-outputs.id}/module=DATA_COLLECTION_FREQUENCY"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "outputdetails"
      type = "struct<dataArchiveServer:string,pointSource:string,interfaceId:string,scanClass:string,scanFrequency:string,realFrequency:string,deviatedFrequencyPercent:string,warningType:string>"
    }

    columns {
      name = "module"
      type = "string"
    }

    columns {
      name = "groupname"
      type = "string"
    }

    columns {
      name = "subgroupname"
      type = "string"
    }

    columns {
      name = "dataarchiveserver"
      type = "string"
    }

    columns {
      name = "pointsource"
      type = "string"
    }

    columns {
      name = "instrumenttag"
      type = "string"
    }

    columns {
      name = "exdesc"
      type = "string"
    }

    columns {
      name = "location1"
      type = "string"
    }

    columns {
      name = "location4"
      type = "string"
    }

    columns {
      name = "scan"
      type = "boolean"
    }

    columns {
      name = "pipointid"
      type = "int"
    }

    columns {
      name = "outputtype"
      type = "string"
    }

    columns {
      name = "outputdate"
      type = "string"
    }

    columns {
      name = "pipointcreationdate"
      type = "string"
    }

    columns {
      name = "pipointcreator"
      type = "string"
    }

    columns {
      name = "pipointlastchangedate"
      type = "string"
    }

    columns {
      name = "pipointlastchanger"
      type = "string"
    }

    columns {
      name = "tagname"
      type = "string"
    }
  }

  partition_keys {
    name = "group_id"
    type = "string"
  }

  partition_keys {
    name = "subgroup_id"
    type = "string"
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"          = "true"
    "projection.group_id.type"    = "injected"
    "projection.subgroup_id.type" = "injected"
    "projection.date.type"        = "injected"
  }
}

resource "aws_glue_catalog_table" "picomponentsurveillance_module_outputs" {
  name          = "picomponentsurveillance_module_outputs"
  database_name = aws_glue_catalog_database.obsidian_module_outputs.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-module-outputs.id}/module=PI_COMPONENT_SURVEILLANCE"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "outputdetails"
      type = "struct<componentType:string,componentName:string,warningType:string>"
    }

    columns {
      name = "module"
      type = "string"
    }

    columns {
      name = "groupname"
      type = "string"
    }

    columns {
      name = "subgroupname"
      type = "string"
    }

    columns {
      name = "dataarchiveserver"
      type = "string"
    }

    columns {
      name = "pointsource"
      type = "string"
    }

    columns {
      name = "location1"
      type = "string"
    }

    columns {
      name = "pipointid"
      type = "int"
    }

    columns {
      name = "scan"
      type = "boolean"
    }

    columns {
      name = "outputtype"
      type = "string"
    }

    columns {
      name = "outputdate"
      type = "string"
    }

    columns {
      name = "pipointcreationdate"
      type = "string"
    }

    columns {
      name = "pipointcreator"
      type = "string"
    }

    columns {
      name = "pipointlastchangedate"
      type = "string"
    }

    columns {
      name = "pipointlastchanger"
      type = "string"
    }

    columns {
      name = "tagname"
      type = "string"
    }
  }

  partition_keys {
    name = "group_id"
    type = "string"
  }

  partition_keys {
    name = "subgroup_id"
    type = "string"
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"          = "true"
    "projection.group_id.type"    = "injected"
    "projection.subgroup_id.type" = "injected"
    "projection.date.type"        = "injected"
  }
}

resource "aws_glue_catalog_table" "raw_tags_pointsource" {
  name          = "raw_tags_pointsource"
  database_name = aws_glue_catalog_database.obsidian_raw_tags.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-raw-tags.id}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "instrumenttag"
      type = "string"
    }

    columns {
      name = "exdesc"
      type = "string"
    }

    columns {
      name = "location1"
      type = "string"
    }

    columns {
      name = "tagname"
      type = "string"
    }

    columns {
      name = "latestvalue"
      type = "struct<isGood:boolean,timestamp:string,value:string>"
    }
  }

  partition_keys {
    name = "data_archive_server"
    type = "string"
  }

  partition_keys {
    name = "point_source"
    type = "string"
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"                  = "true"
    "projection.data_archive_server.type" = "injected"
    "projection.point_source.type"        = "injected"
    "projection.date.type"                = "injected"
  }
}

resource "aws_glue_catalog_table" "tagconfigconsistency_module_outputs" {
  name          = "tagconfigconsistency_module_outputs"
  database_name = aws_glue_catalog_database.obsidian_module_outputs.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-module-outputs.id}/module=TAG_CONFIG_CONSISTENCY/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "outputdetails"
      type = "struct<consistencyResults:array<struct<attributeValue:string,configRule:struct<attributeKey:string,ruleOperator:string,ruleValue:string>>>,warningType:string>"
    }

    columns {
      name = "module"
      type = "string"
    }

    columns {
      name = "groupname"
      type = "string"
    }

    columns {
      name = "subgroupname"
      type = "string"
    }

    columns {
      name = "dataarchiveserver"
      type = "string"
    }

    columns {
      name = "pointsource"
      type = "string"
    }

    columns {
      name = "instrumenttag"
      type = "string"
    }

    columns {
      name = "exdesc"
      type = "string"
    }

    columns {
      name = "location1"
      type = "string"
    }

    columns {
      name = "location4"
      type = "string"
    }

    columns {
      name = "scan"
      type = "boolean"
    }

    columns {
      name = "pipointid"
      type = "int"
    }

    columns {
      name = "outputtype"
      type = "string"
    }

    columns {
      name = "outputdate"
      type = "string"
    }

    columns {
      name = "pipointcreationdate"
      type = "string"
    }

    columns {
      name = "pipointcreator"
      type = "string"
    }

    columns {
      name = "pipointlastchangedate"
      type = "string"
    }

    columns {
      name = "pipointlastchanger"
      type = "string"
    }

    columns {
      name = "tagname"
      type = "string"
    }
  }

  partition_keys {
    name = "group_id"
    type = "string"
  }

  partition_keys {
    name = "subgroup_id"
    type = "string"
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"          = "true"
    "projection.group_id.type"    = "injected"
    "projection.subgroup_id.type" = "injected"
    "projection.date.type"        = "injected"
  }
}

resource "aws_glue_catalog_table" "tagstate_module_outputs" {
  name          = "tagstate_module_outputs"
  database_name = aws_glue_catalog_database.obsidian_module_outputs.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-module-outputs.id}/module=TAG_STATE/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "outputdetails"
      type = "struct<state:string,warningType:string>"
    }

    columns {
      name = "latestvalue"
      type = "struct<timestamp:string>"
    }

    columns {
      name = "module"
      type = "string"
    }

    columns {
      name = "groupname"
      type = "string"
    }

    columns {
      name = "subgroupname"
      type = "string"
    }

    columns {
      name = "dataarchiveserver"
      type = "string"
    }

    columns {
      name = "pointsource"
      type = "string"
    }

    columns {
      name = "instrumenttag"
      type = "string"
    }

    columns {
      name = "exdesc"
      type = "string"
    }

    columns {
      name = "location1"
      type = "string"
    }

    columns {
      name = "location4"
      type = "string"
    }

    columns {
      name = "scan"
      type = "boolean"
    }

    columns {
      name = "pipointid"
      type = "int"
    }

    columns {
      name = "outputtype"
      type = "string"
    }

    columns {
      name = "outputdate"
      type = "string"
    }

    columns {
      name = "pipointcreationdate"
      type = "string"
    }

    columns {
      name = "pipointcreator"
      type = "string"
    }

    columns {
      name = "pipointlastchangedate"
      type = "string"
    }

    columns {
      name = "pipointlastchanger"
      type = "string"
    }

    columns {
      name = "tagname"
      type = "string"
    }
  }

  partition_keys {
    name = "group_id"
    type = "string"
  }

  partition_keys {
    name = "subgroup_id"
    type = "string"
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"          = "true"
    "projection.group_id.type"    = "injected"
    "projection.subgroup_id.type" = "injected"
    "projection.date.type"        = "injected"
  }
}

resource "aws_glue_catalog_table" "raw_tags" {
  name          = "raw_tags"
  database_name = aws_glue_catalog_database.obsidian_raw_tags.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.obsidian-raw-tags.id}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "serialization.format" = "1"
      }
    }

    columns {
      name = "instrumentTag"
      type = "string"
    }

    columns {
      name = "exDesc"
      type = "string"
    }

    columns {
      name = "location1"
      type = "int"
    }

    columns {
      name = "pointSource"
      type = "string"
    }

    columns {
      name = "tagName"
      type = "string"
    }

    columns {
      name = "lastExtractionDate"
      type = "string"
    }

    columns {
      name = "scan"
      type = "boolean"
    }

    columns {
      name = "piPointId"
      type = "int"
    }

    columns {
      name = "latestValue"
      type = "struct<isGood:boolean,timestamp:string,value:string>"
    }
  }

  partition_keys {
    name = "data_archive_server"
    type = "string"
  }

  partition_keys {
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled"                  = "true"
    "projection.data_archive_server.type" = "injected"
    "projection.point_source.type"        = "injected"
    "projection.date.type"                = "injected"
  }
}
