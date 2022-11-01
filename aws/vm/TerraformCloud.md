# Integrating an AWS VM Deployment with Terraform Cloud
## Purpose
In the prevous sample, you executed a set of Terraform commands locally to create infrastructure with code.  While that was great for a tutorial, something more robust is needed for real world use and that's where Terraform Cloud comes in as the facilitator of a CI/CD toolchain.  In this sample, you will configure Terraform Cloud with the same sample code used previously, but experience what it is like to have that code centrally managed and executed in a repeatable, scalable way.

## Prerequisites
This sample builds on previous material and extends Terraform use beyond your local machine.  As such, there are a few things you need before you get started:

* Completion of the  [Deploy a VM in a network on AWS](./README.md) sample
* A GitHub account

## Create a Terraform Cloud account
Follow the steps to [Create a Terraform Cloud account](https://app.terraform.io/signup/account), including clicking on the confirmation email link, which is required for your new account to be activated.

When complete, you should see something like this:

![Fresh Terraform Cloud Account](../../media/Fresh_TFC_Account.png)

## Create a fresh GitHub repo with files
On your GitHub account, create a new repo called `my-tf-sample`, clone it on your local machine, copy the `variables.tf`, `output.tf`, and `main.tf` from the [Deploy a VM in a network on AWS](./README.md) sample into the cloned repo, add and commit the files to the local repo and then push them back to Github.

When complete, you should see something like this:

![GitHub](../../media/My_TF_Sample.png)

## Create a Workspace with Terraform Cloud
Back in Terraform Cloud, let's now add a workspace by clicking on `Create one now` at the bottom of the screen shown after you created an account.  For the type, select `Version Control Workflow` and then select GitHub.. Accept all the defaults when prompted to authorize Terraform Cloud to connect to your GitHub account.  In particular, be sure to allow the Terraform Cloud app to access all your repositories.  This will later enable Terraform Cloud to react to commits to your GitHub repo.

Once that is complete, select the newly created `my-tf-sample` repo.  When complete, you should see something similar to:

![Workspace Uploaded](../../media/Workspace_Uploaded.png)

## Queue the Plan, Expect an Error
Once the Terraform configuration has been uploaded from your GitHub repo to Terraform Cloud, press the `Queue Plan` button.  This has the effect of executing a `terraform plan` similar to when you did the same in the previous sample on your local computer.

This should initially fail with something similar to:

![Queue Error](../../media/Queue_Error.png)

Because you are now running the Terraform configuration in a space that does not have your AWS credentials, it fails.

## Configure AWS Credentials
Above the portion of the screen that reported the error, on the right hand side is a set of menu items.  Click on `Variables`, which takes you to a screen that lets you set both Terraform variables (like the ones used to set `region`, `ami`, etc.) and Environment Variables, which is what you will use to fix the encountered error.

Recall that in the `provider` block of `main.tf`, the `profile` attribute is set to `default`, which tells the AWS provider to use its precedence order to find your credentials, ultimately finding them in your local `~/.aws` folder, which is not present here in your Terraform Cloud workspace.  That is not the only place that the AWS provider can find credentials, however.  It uses the same precedence order as the AWS CLI, which [can use environment variables to find credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).  This is how you will solve the encountered error.

Under Environment Variables, click `+ Add variables`.  For the `key` enter `AWS_ACCESS_KEY_ID` and for the value, find the associated value in your local `~/.aws/credentials` file.  Mark the variable as sensitive to prevent Terraform Cloud from displaying it in any Terraform command output.  Save the variable.

Repeat the process for `AWS_SECRET_ACCESS_KEY`.

## Queue the Plan, Expect Success
To try again, click on the `Queue plan` dropdown, which is next to the same menu that took you to the Variables screen.  Optionally, you can enter a comment and press the `Queue plan` button.

This time, the `plan` step should execute successfully, the apply step should start and ask you for confirmation, which is similar to typing "yes" locally when performing a `terraform apply`.

![Plan Finished Apply Confirmation](../../media/Plan_Finished_Apply_Confirmation.png)

Confirm and leave a comment of your choosing.  You should now see the `terraform apply` step execute succesfully just like it did locally in the previous sample, which you can confirm in the AWS console.  When completed, Terraform Cloud should look something like this:

![Queue Success](../../media/Queue_Success.png)

Click around this screen a bit to see all the information that was recorded during the run.  In particular, notice that state is being kept on Terraform Cloud instead of local files.

# Change a variable
Return to the Variables screen and this time under Terraform Variables, click `+ Add variables`.  For the `key` enter `ami` and for the value, enter whatever value is currently commented out in the `variables.tf` file of your `my-tf-sample`. Save the variable.

Queue another plan as before.  During the Plan phase, this should show an output similar to the previous sample when the value of the `ami` variable was changed directly in the `variables.tf` file and force a replacement of the VM.  Confirm the Apply and allow that replacement to execute.  See the resulting change in the AWS console.

You can achieve scaling through similar means.  If you add a variable whose key is `instance_type` and whose value is `t2.small` and then manually queue a plan, it will scale the VM up to the larger size.  Take note that if you do this step and leave the size at `t2.small`, that is outside the AWS free tier and you may incur hourly costs.

# Triggering with GitHub
Because the Terraform Cloud app is installed on GitHub, it can detect changes in your repo and automaitcally kick off new processing.  To demonstrate this, in the local copy of your repo open the `main.tf` file in a text editor.  The last `resoure` block defines the VM instance and in the `tags` section is where the name of the instance is set.  Change the value of the name from "example" to your Github username and save the file.

At the command line locally, use git to add and commit the file and then push it back to GitHub.

Within a few seconds, the act of pushing a change from your local command line to GitHub should automatically kick off a new run on Terrraform Cloud, which will ask you for confirmation before applying.  Confirm the apply and, when complete, verify in the AWS console that the name of the instance has been changed.

# Destroy
To end this sample, you can optionally destroy everything that has been created.  In the Settings drop down, press the `Destruction and Deletion` button.  Here, you have the ability to destroy the infrastructure created with this workspace and also destroy the workspace itself.

Press the `Queue destroy plan` and follow the prompts to perform the equivalent of a local `terraform destroy`.  When done, confirm the destruction in the AWS console.

Finally, press the `Delete from Terraform Cloud` and follow the prompts to remove the workspace from Terraform Cloud.

## Wrapping up
This sample placed some of the basic Terraform steps and placed them in the CI/CD pipeline control provided by Terraform Cloud.  You were able to change deployed infrastructure by commiting code to source control and confirm with a manual check.  These simple steps demonstrate the structures that modern CI/CD approaches can have on infrastructure.