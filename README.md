Continuous Delivery and Continuous Integration are considered one of the basic building blocks 
of any cloud application architecture be it SOA or MicroService architecture. Without CD/CI, it is very easy for a running service instance to misbehave, may it be behavioural or logical bugs in code or misconfiguration of running instance, etc . The easiest way to avoid bugs to affect production environment is to add more developer Unit tests so that these cases don’t get missed at any manual steps involved as part of testing. But, the best way to avoid configuration issues affecting performance or behaviour of a service instance is having a CD/CI pipeline which continuously delivers new build to the production without intervention of any manual step or be it downtime in SLA for the running service instances.



This project is a “vanilla” flavour implementation of CD/CI pipeline which uses Chef under the hood to continuously deliver new build of a service to production environment without any manual steps involved as part of building artifact or configuration. This project has been designed to keep single most important principle of Distributed Systems in mind that any part of pipeline can break unexpectedly or unforeseeable at any time. But, it should only limit the capability of CD/CI pipeline and not affect the quality of running service in production in any way or have any negative impact on the service quality in production environment.



DESIGN
This project consists of some shell scripts for bootstrapping Chef nodes and 2 Chef cookbooks as below

build_machine_cookbook : Any Chef node which has this cookbook assigned to it constantly keeps track of latest commits on a (github) repository and triggers a build/publish of latest artifacts for the repository whenever a new commit is made to the repository.

deploy_server_cookbook : Any Chef node which has this cookbook assigned to it acts as a production deployment server for the service instance and also periodically (24 Hrs) checks if a latest build of service is available. If so, it stops the service, deploys the new service build and restarts the service instance.

For simplicity of the implementation, some of the steps needed to get the node into desired state as part of chef-client run are added to shell script instead of ideally being configured in recipe. The cookbook’s recipes can be easily refactored to accomplish the same in recipe instead of executing through shell script executed as part of recipe run.
Besides these 2 cookbooks, 2 types of roles are also assigned to the respective nodes as part of bootstrap
build_machine_role
deploy_server_role
Role defines some of the custom cookbooks, available on Chef Supermarket and uploaded to chef server using BerkShelf as part of chef server account setup, that needs to be installed on the node as part of chef-client run and also some override attribute values needed by the cookbook(s). 



Each node which is configured for either of above 2 cookbooks also needs some other custom cookbooks available in Chef Supermarket including the ones needed for java, gradle, git, etc. The BerkShelf allows to upload these custom cookbooks to Chef server so that if a node needs it (assigned through Role), it can be downloaded by the node from chef server as part of chef-client run.

Also, one environment is also added to test the working of project. Multiple environment can be setup, each for various stages of deployment including test and pre-release environment(s).

Security related information including node’s ssh keys can be added to data bags. However, for this project, the ssh key for github is added to the cookbook for ease. But, ideally it should be accessed via data bag for security.



HOW TO USE
First thing to do is configure .chef at root so that chef server can be accessed. Then, data bag has to be added for providing credentials to node and also same have to be put into environment.properties at root for shell scripts to fully automate CD/CI pipeline setup and destroy. 
Two shell scripts are available at root of project as below
setuppipeline.sh : This reads a properties file to get system credentials for the node that needs to be bootstrapped for specific functionalities. The default value of properties file is “environment.properties” expected in the same directory as this shell file. However, it can also be provided as first (optional) argument while calling the script. The properties file is expected to include node’s IP address, system username and password with specific pattern in keys for properties so that chef-client can be configured on these nodes by this script. A sample properties file is also uploaded as part of project.
destroypipeline.sh : This shell script finds all nodes bootstrapped and removes the applied role/cookbook from the node(s) and invalidates the node’s secure key from Chef server for stopping future communication with Chef server.


NEXT STEPS OF DEVELOPMENT
This project can be forked or adopted to deliver needed architectural requirement of any application or service. Also, there are many logical features that can be added to this project to make it completely full-fledged pipeline. Some of them are as below
To support zero downtime for service along with continuous deployment, LB like HAProxy or AWS ALB or ELB has to be configured for the environment so that deployment step for service can be prefixed/postfixed with (un)registering the service instance from the LB to control traffic on the service node during (re)deployment.
Complete Rollback support in case of failed deployment of any new build for any service in production to protect SLA and quality of the service.
Integrate support for meta-services needed in the environment like configuration of Load balancer as part of CD/CI pipeline.
Also, in above “deploy_server_cookbook” cookbook, the application(/service) is not registered as a service to the underlying OS to support (re)start of application(/service) in case node restarts. For this, a symlink needs to be created in the node (as part of recipe) between startapp.sh script (which controls status of application(/service)) and the OS’s init sequence (for example in linux, it is /etc/init.d directory) so that as part of bootstrap of node’s OS, this application(/service) is also (re)started when the node (re)starts.
Support test cases for cookbook using Chef Kitchen.
Support encrypted data bags for security.
Design single cookbook to support Disaster Recovery.
Use handler available in Chef or Integration with services like OpsGenie or Twilio to deliver continuous updates via Tele messages to CD/CI monitoring team for latest deployment happening in production environment at any time and early detection of any failed deployment.
