resource "aws_db_subnet_group" "database-1" {
  name       = "database-1"
  subnet_ids = [aws_subnet.bd-a.id, aws_subnet.bd-b.id, aws_subnet.bd-c.id]
}

resource "aws_rds_cluster" "database-1" {
  cluster_identifier        = "database-1"
  availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_subnet_group_name      = aws_db_subnet_group.database-1.name
  engine                    = "mysql"
  engine_version            = "8.0.39"
  db_cluster_instance_class = "db.m5d.large"
  storage_type              = "io2"
  allocated_storage         = var.allocated_storage
  iops                      = var.iops
  master_username           = "admin"
  master_password           = "senhaAd@"
}