resource "aws_ecs_cluster" "ecs_cluster_a" {
  name = "ecs_cluster_a"
}

resource "aws_ecs_task_definition" "myterraformtestc_task" {
  family                   = "test_task_definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 256,
    "essential": true,
    "image": "dvriesman/myterraformtestc",
    "memory": 512,
    "name": "myterraformtestc",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

resource "aws_lb" "alb" {
    name = "fargate-test"
    load_balancer_type = "application"
    security_groups = ["${aws_default_security_group.default.id}"]
    subnets = ["${aws_subnet.mypublicsub.*.id}", "${aws_subnet.mypublicsub2.*.id}"]
}

resource "aws_lb_target_group" "target" {
    name = "target"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.VPC_Terraform.id}"
    target_type = "ip"
    deregistration_delay = 300

    health_check {
        healthy_threshold = 2
        interval = 11
        port = "80"
        protocol = "HTTP"
        path = "/"
        timeout = 10
        unhealthy_threshold = 2
        matcher = "200"
   }

}

resource "aws_lb_listener" "listener_80" {
    port = "80"
    protocol = "HTTP"
    load_balancer_arn = "${aws_lb.alb.arn}"
    default_action {
        target_group_arn = "${aws_lb_target_group.target.arn}"
        type = "forward"
    }
    depends_on = ["aws_lb.alb","aws_lb_target_group.target"]
}


resource "aws_ecs_service" "myterraformtestc_svc" {
  name            = "myterraformtestc_svc"
  cluster         = "${aws_ecs_cluster.ecs_cluster_a.id}"
  task_definition = "${aws_ecs_task_definition.myterraformtestc_task.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target.arn}"
    container_name = "myterraformtestc"
    container_port = 80
  }

  network_configuration {
    security_groups = ["${aws_default_security_group.default.id}"]
    subnets = ["${aws_subnet.mypublicsub.*.id}", "${aws_subnet.mypublicsub2.*.id}"]
 }


  
}
