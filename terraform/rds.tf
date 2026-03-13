resource "aws_db_instance" "mysql" {
  identifier = var.db_name

  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"

  instance_class = "db.t3.micro"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true

  multi_az = false

  tags = {
    Name = "login-app-db"
  }
}




resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "login-app-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "login-app-db-subnet-group"
  }
}