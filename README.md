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
* _After the infrastructure is setup you can verify the same for instances being ready mostly our instance would take hardly ```50 sec``` to be ready after the cloud-init script runs to setup the webserver and secondary volume_

<p align="centre">
   <img width="950" height="350" src="https://github.com/samblake30/Terraform_ASG_AWS/blob/master/images/instances_bastion.PNG">
</p>
   
## _Steps to perform:-_
 * _First check if the attached disks are available_
<p align="centre">
  <img width="20" height="20" src="https://github.com/samblake30/Linux/blob/main/RAID%20Configuration/src/img1.png">  
</p>

### ***Note:*** _Here we can create partition using both inbuilt utilities ![fdisk](https://img.shields.io/badge/%2Fdev%2Fsdc-for%20%20%2Fvar%2Flog-green) and ![parted](https://img.shields.io/badge/Utility-Parted-orange?style=plastic&logo=appveyor) but, for demo I have already taken backup of the partition tables created manually using the above mentioned utilities and here with the help of the ![sfdisk](https://img.shields.io/badge/Utility-sfdisk-brightgreen?style=plastic&logo=appveyor) we will restore the partition table with correct label and sizes._

### _Partition Table files:-_

Device Name      |  Partition Table Info
-----------      | --------------------
:point_right: _/dev/nvme1n1_  | ***![nvme1n1.txt](https://github.com/samblake30/Linux/blob/main/RAID%20Configuration/src/Partition%20files/nvme1n1.txt)***
:point_right: _/dev/nvme2n1_  | ***![nvme2n1.txt](https://github.com/samblake30/Linux/blob/main/RAID%20Configuration/src/Partition%20files/nvme2n1.txt)***



 * _Create 3 partitions in /dev/nvme1n1 device_
   ```bash
   sfdisk /dev/nvme1n1 < nvme1n1.txt
   ```
   
   ```bash
   [root@b1e95f64d31c ~]# lsblk /dev/nvme1n1
   NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   nvme1n1     259:0    0    2G  0 disk
   ├─nvme1n1p1 259:4    0  200M  0 part
   ├─nvme1n1p2 259:5    0  200M  0 part
   └─nvme1n1p3 259:6    0  200M  0 part
   ```
* _Create 7 partitions in /dev/nvme2n1 with 3 as primary 1 as extended and 3 as logical_

   ```bash
   sfdisk /dev/nvme1n1 < nvme1n1.txt
   ```
   
   ```bash
   [root@b1e95f64d31c ~]# parted /dev/nvme2n1 print
   Model: NVMe Device (nvme)
   Disk /dev/nvme2n1: 2147MB
   Sector size (logical/physical): 512B/512B
   Partition Table: msdos
   Disk Flags: 

   Number  Start   End     Size    Type      File system  Flags
   1      1049kB  200MB   199MB   primary                raid
   2      201MB   400MB   198MB   primary                raid
   3      401MB   600MB   199MB   primary                raid
   4      601MB   2100MB  1499MB  extended               lba
   5      602MB   800MB   198MB   logical                raid
   6      801MB   1000MB  199MB   logical                raid
   7      1001MB  1200MB  198MB   logical                raid
  ```

 * _Check for the mdadm utility is installed_
    :+1:
    ```bash
    rpm -q mdadm
    ```
    * _If not installed then run below command_ :point_down:
    ```bash
    yum install -y mdadm
    ```
 * _Creating the Software RAID using mdadm._
 
    * _Here we create a new device of RAID level 5 with 3 active devices and 3 spare devices for fault tolerance and backup._
    ```bash
    mdadm -C /dev/md0 -l raid5 -n 3 /dev/nvme1n1p1 /dev/nvme1n1p2 /dev/nvme1n1p3 -x 3 /dev/nvme2n1p1 /dev/nvme2n1p2 /dev/nvme2n1p3
    ```
    * _Verify the creation of the new RAID device_
    ```bash
    [root@b1e95f64d31c ~]# ls /dev/md*
    /dev/md0
    ```
    * _Details of the device can also be obtained using ``-D`` flag or ``--detail``_
    ```bash
    [root@b1e95f64d31c ~]# mdadm -D /dev/md0
    /dev/md0:
           Version : 1.2
     Creation Time : Thu Dec 31 05:32:24 2020
        Raid Level : raid5
        Array Size : 382976 (374.00 MiB 392.17 MB)
     Used Dev Size : 191488 (187.00 MiB 196.08 MB)
      Raid Devices : 3
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Thu Dec 31 05:34:39 2020
             State : clean 
    Active Devices : 3
    Working Devices : 6
    Failed Devices : 0
    Spare Devices : 3

            Layout : left-symmetric
        Chunk Size : 512K

    Consistency Policy : resync

              Name : b1e95f64d31c.mylabserver.com:0  (local to host b1e95f64d31c.mylabserver.com)
              UUID : edc168fe:082e62d2:7183995d:7bd4e9ed
            Events : 18

    Number   Major   Minor   RaidDevice State
       0     259        2        0      active sync   /dev/nvme1n1p1
       1     259        3        1      active sync   /dev/nvme1n1p2
       6     259        4        2      active sync   /dev/nvme1n1p3

       3     259        5        -      spare   /dev/nvme2n1p1
       4     259        6        -      spare   /dev/nvme2n1p2
       5     259        7        -      spare   /dev/nvme2n1p3
    ```
    :yellow_circle:--------------------------------:yellow_circle:--------------------------------```OR```-----------------------------------:yellow_circle:------------------------------------:yellow_circle:
    ```bash
    [root@b1e95f64d31c ~]# cat /proc/mdstat
    Personalities : [raid6] [raid5] [raid4] 
    md0 : active raid5 nvme1n1p3[6] nvme2n1p3[5](S) nvme2n1p2[4](S) nvme2n1p1[3](S) nvme1n1p2[1] nvme1n1p1[0]
      382976 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      
    unused devices: <none>
    ```
    * _To make the configuration persisitent to reboot we will create the mdadm.conf file_
          * _So now we will scan our device with ``-s or --scan_`` with ``-v`` to get the output and redirect it into the configuration file_
    ```bash
    # mdadm -D -s -v > /etc/mdadm.conf
    ```
   * _Create Mount point for new created array_
   ```bash
   mkdir /mnt/data
   mkdir /mnt/data/backup
   ```
   * _Now we will create the filesystem on the array_
   ```bash
   mkfs -t ext4 /dev/md0
   ```
   * _Now we mount this array on /dev/md0 array and can check it using ```df -h``` also we will create a new directory inside this after mounting called backup and copy the etc contents inside of it_
   ```bash
   mount /dev/md0 /mnt/data
   mkdir /mnt/data/backup
   cp -rf /etc/* /mnt/data/backup
   ```
   * _To make it persist any reboot we need to add this entry to our ***/etc/fstab*** file so, for it we need to ``UUID`` of the array we created_
   ```bash
   # blkid 
   ```
   * _***/etc/fstab*** Contents_<p align="left"><img width="950" height="70" src="https://github.com/samblake30/Linux/blob/main/RAID%20Configuration/src/img2.PNG"></p>
   
   * _Umount and try to read and mount the device array from fstab file_
    ```bash
    # Umount /mnt/data
    # mount -a
    ```
 * _Managing Failover and Recovery of RAID Devices_
   * _Now here we will fail one device and observe the rebuild status of a spare device taking its place. Make sure we dont fail 2 devices at a time or we will lose the data_
   ```bash
   [root@b1e95f64d31c ~]# mdadm -f  /dev/md0 /dev/nvme1n1p1
   mdadm: set /dev/nvme1n1p1 faulty in /dev/md0
   ```
   * _Now the rebuild process will start and spare devices takes place of the faulty drive_
   ```bash
       1     259        3        1      active sync   /dev/nvme1n1p2 👈
       6     259        4        2      active sync   /dev/nvme1n1p3

       0     259        2        -      faulty   /dev/nvme1n1p1 👈
       3     259        5        -      spare   /dev/nvme2n1p1
       4     259        6        -      spare   /dev/nvme2n1p2
   ```
   * _Similarly we will replace all the active with the spare one's as above_
   ```bash
   /dev/md0:
           Version : 1.2
     Creation Time : Thu Dec 31 05:32:24 2020
        Raid Level : raid5
        Array Size : 382976 (374.00 MiB 392.17 MB)
     Used Dev Size : 191488 (187.00 MiB 196.08 MB)
      Raid Devices : 3
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Mon Jan  4 11:50:23 2021
             State : clean, degraded, recovering
    Active Devices : 2
   Working Devices : 3
    Failed Devices : 3
     Spare Devices : 1

            Layout : left-symmetric
        Chunk Size : 512K

    Consistency Policy : resync

    Rebuild Status : 20% complete

              Name : b1e95f64d31c.mylabserver.com:0  (local to host b1e95f64d31c.mylabserver.com)
              UUID : edc168fe:082e62d2:7183995d:7bd4e9ed
            Events : 63

    Number   Major   Minor   RaidDevice State
       5     259        7        0      active sync   /dev/nvme2n1p3
       3     259        5        1      active sync   /dev/nvme2n1p1
       4     259        6        2      spare rebuilding   /dev/nvme2n1p2
    ```
    * _Remove the failed devices one by one or together from the array_      
    ```bash
       [root@b1e95f64d31c ~]# mdadm -r /dev/md0 /dev/nvme1n1p1 /dev/nvme1n1p2 /dev/nvme1n1p3
       mdadm: hot removed /dev/nvme1n1p1 from /dev/md0
       mdadm: hot removed /dev/nvme1n1p2 from /dev/md0
       mdadm: hot removed /dev/nvme1n1p3 from /dev/md0
    ```
    * _Add the new spare devices one by one or together in the array and verify the same_
    ```bash
    [root@b1e95f64d31c ~]# mdadm -a /dev/md0 /dev/nvme2n1p5 /dev/nvme2n1p6 /dev/nvme2n1p7
    mdadm: added /dev/nvme2n1p5
    mdadm: added /dev/nvme2n1p6
    mdadm: added /dev/nvme2n1p7
   [root@b1e95f64d31c ~]# mdadm -D /dev/md0
   /dev/md0:
           Version : 1.2
     Creation Time : Thu Dec 31 05:32:24 2020
        Raid Level : raid5
        Array Size : 382976 (374.00 MiB 392.17 MB)
     Used Dev Size : 191488 (187.00 MiB 196.08 MB)
      Raid Devices : 3
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Mon Jan  4 12:00:34 2021
             State : clean 
    Active Devices : 3
    Working Devices : 6
    Failed Devices : 0
     Spare Devices : 3

            Layout : left-symmetric
        Chunk Size : 512K

    Consistency Policy : resync

              Name : b1e95f64d31c.mylabserver.com:0  (local to host b1e95f64d31c.mylabserver.com)
              UUID : edc168fe:082e62d2:7183995d:7bd4e9ed
            Events : 81

    Number   Major   Minor   RaidDevice State
       5     259        7        0      active sync   /dev/nvme2n1p3
       3     259        5        1      active sync   /dev/nvme2n1p1
       4     259        6        2      active sync   /dev/nvme2n1p2

       6     259        9        -      spare   /dev/nvme2n1p5 👈
       7     259       10        -      spare   /dev/nvme2n1p6 👈
       8     259       11        -      spare   /dev/nvme2n1p7 👈
    ```
    * _Add this new information back to the main configuration ***```/etc/mdadm.conf```*** to make it persistent_
    ```bash
    # mdadm -D -s -v >/etc/mdadm.conf
    ```
    
