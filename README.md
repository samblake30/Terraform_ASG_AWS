# _Terraform_AWS_ASG_

## _Accomplishments in this task_
 * _VPC creation with Public and Private Subnet_.
 * _Public Subnet has Bastion Server and ELB_.
 * _Private Subnet has all the Backend Instances working in Auto-Scaling Group_.
 * _ASG uses latest AMI with secondary volume ![sdc](https://img.shields.io/badge/%2Fdev%2Fsdc-----%20%3E%20%2Fvar%2Flog-blue) and Apache webServer_.
 * _Application health Check from ELB_
 * _Cloudwatch Alarm mechanism to trigger UP scaling and down scaling ASG policy_.
 * _Auto-Scaling Group to add and remove nodes based on CPUUtilization_.


## _Description:-_
 * _Here we are going to provision our VPC(Public and Private Subnet), Internet Gateway & NAT gateway, weberver, Autoscaling, LaunchConfiguration and  ELB(Classic LoadBalancer) using the Terraform IAC. After this we would be creating Autoscaling Policies to scale up and down our backend instances based on Load metrices from ***![AWS](https://img.shields.io/badge/-AWS%2FEC2-orange) Namespace*** with cloudwatch alarm metrices. Below are contents with file details_.
 
 ### _Terraform Files:-_

Created Resources      |  Terraform files
-----------      | --------------------
_Terraform Settings Block_                           :point_right:  | ***![Terraform Block](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/terraform_block.tf)***
_VPC_                                                :point_right:  | ***![VPC](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/vpc.tf)***
_Public and Private Subnet_                          :point_right:  | ***![Pub_Pri_Subnet](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/pub_pri_subnet.tf)***
_Internet and NAT gateway_                           :point_right:  | ***![IG_NAT_Gateway](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/gateway_ig_nat.tf)***
_Route Table Creation for Public and Private Subnet_ :point_right:  | ***![Route Table](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/routerule.tf)***
_Route Rules Creation_                               :point_right:  | ***![Route Rules for RT](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/routerule.tf)***
_Route Table Association w.r.t Subnets_              :point_right:  | ***![RT Association](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/rtassociation.tf)***
_Key-Pair Creation_                                  :point_right:  | ***![Key-Pair](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/keypair.tf)***
_Compute Security Group_                             :point_right:  | ***![EC2 Security Group](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/sg.tf)***
_ELB Security Group_                                 :point_right:  | ***![ELB SG](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/elbsg.tf)***
_Auto-Scaling, LaunchConfig, ELB, ASG policy and Cloudwatch Alarm Creation_ :point_right: | ***![Main file](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/main.tf)***
_Variable file_                                      :point_right:  | ***![Variables](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/variables.tf)***
_Dynamic Values for Variables_                       :point_right:  | ***![Terraform.tfvars](https://github.com/samblake30/Terraform_ASG_AWS/blob/master/terraform.tfvars)***


## _Steps to Perform:-_
* _Here I am going to use Windows Machine so I have already set my ```AWS_ACCESS_KEY_ID```, ```AWS_SECRET_ACCESS_KEY```  and ```AWS_DEFAULT_REGION``` as Environment Variables in my machine. Incase you are using Linux below commands can be fired to set your env variables or in your ```/etc/profile.d``` or ```.bashrc``` file_.
   ```bash
   export AWS_ACCESS_KEY_ID = <YOUR ACCESS KEY>
   export AWS_SECRET_ACCESS_KEY = <YOUR SECRET KEY>
   export AWS_DEFAULT_REGION = <YOUR REGION>
   ``` 
***_NOTE_***: _I have still created a variable for region choices_

* _Initliatize the terraform to install the required Providers Plugins and specific version_.
   ```bash
   terraform init
   ```
* _Perform terraform plan to know what resources are created_
   ```bash
   terraform plan
   ```
* _Apply the configuration to start the provisioning of the resources in AWS Environment_.
   ```bash
   terraform apply -auto-approve
   ```
* _After the infrastructure is setup you can verify the same for instances being ready mostly our instance would take hardly ```50 sec``` to be ready after the cloud-init script runs to setup the webserver and secondary volume but we have put the Grace period of ```300 sec```_.
  * ***_Backend Instances and Bastion Server_***
  
   <p align="centre">
      <img width="950" height="200" src="https://github.com/samblake30/Terraform_ASG_AWS/blob/master/images/instances_bastion.PNG">
   </p>

  * ***_Autoscaling Group_***

   <p align="centre">
      <img width="950" height="200" src="https://github.com/samblake30/Terraform_ASG_AWS/blob/master/images/ASG.PNG">
   </p>

  * ***_Elastic Load Balancer_***
  
  * ***_Note_:-*** _Here we are using the ELB as our health check statistic to determine is application is facing any issue and terminte_ 
  
   <p align="centre">
      <img width="950" height="400" src="https://github.com/samblake30/Terraform_ASG_AWS/blob/master/images/ELB.PNG">
   </p>
   
  * ***_Health Check from ELB is to ping the application on Port 80 with a defined interval of 30 sec_.***
  
  * _Generate the load on one server using the builtin utility called ![stress](https://img.shields.io/badge/Utility-stress-brightgreen?style=plastic&logo=appveyor) or directly in ASG group we can select and execute for the created policies to scale up and down the nodes. Incase the stress utility is not installed we can go fire the below commands to install the utility on Linux Servers_.
  
  ```bash
  > wget  ftp://fr2.rpmfind.net/linux/dag/redhat/el7/en/x86_64/dag/RPMS/stress-1.0.2-1.el7.rf.x86_64.rpm
  > yum localinstall stress-1.0.2-1.el7.rf.x86_64.rpm
  > stress --cpu 10 --timeout 20
  ```
 * ***_ELB result_***
   <p align="centre">
     <img width="950" height="50" src="https://github.com/samblake30/Terraform_ASG_AWS/blob/master/images/elb_result.PNG">  
   </p>
