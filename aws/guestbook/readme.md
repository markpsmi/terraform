# Bare Metal Provisioning ESXi Workflow

This workflow installs ESXi OS on a Intersight UCS standalone server. The workflow does not use Intersight OS Install feature. The workflow generates the ESXi image with Kickstart file. The workflow requires a Linux VM to store the images and kickstart files. The newly built images are then installed using vMedia on the UCS server. The linux image server requires access to the images with either Https, NFS or CIFS. Example workflow uses CIFS.    

The above workflow uses the following SSH tasks with execute scripts for the following:
 - Update Kickstart File (updateks.sh)
 - Create New ESXi ISO (makeesxi.sh)
 - Wait for OS Install (pingit.sh)  
 > **Note: Scripts are located in scripts folder in repo**


## Script Details

### updateks.sh
Update Kickstart file. Requires existing kickstart file on linux image server. Script can be modified to pass additional workflow parameters.

SSH Task Command  /tmp/updateks.sh {{.global.workflow.input.HosteName}} {{.global.workflow.input.IpAddress}}

![This is an image](images/updateks.PNG)


### makesesxi.sh
Create new ESXi ISO. Requires ESXi ISO on image server. Script builds new ISO with Kickstart for vmedia install.

SSH Task Commmand /tmp/makeESXi.sh {{.global.workflow.input.HostName}}

![This is an image](images/makeESXi.PNG)


### pingit.sh
Script runs and waits for OS to be installed by checking the reachablity of ESXI server IP address

SSH Task Command /tmp/pingit.sh {{.global.workflow.input.IpAddress}}

![This is an image](images/pingit.PNG)


## Workflow Image

![This is an image](images/workflow.PNG)

