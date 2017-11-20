# om-env-kako

Provides a Chef environment cookbook for provisioning Kako nodes.

## Getting Started

### AWS Keys and SNS Topics

To begin, make sure that you have an SNS Topic and associated keys for an IAM user / role which is able to Publish to this topic. `cloud-config.yaml` and / or `deploy-local.sh` will need to be updated with these values - replacing the current `X`, `Y`, and `Z` values respectively - prior to launch!

See the Kako documentation - linked below - for more information.

### This Machine

If for some reason you want to install 41h on the machine that you have checked the repository out onto, perform the following:

1) Run `deploy-local.sh` from this directory.
2) Wait.

### Digital Ocean

To deploy a new Kako node into Digital Ocean (via the API), perform the following:

1) Run `pip install -r requirements.txt` from this directory.
2) Run `python2.7 deploy-digitalocean.py --api-token <DO_API_TOKEN>` from this directory.
3) Wait.

### Vagrant

To deploy a local virtual machine via Vagrant, perform the following:

1) First up, ensure the following dependencies are installed and configured:
  * Vagrant
    * https://www.vagrantup.com/
    * No configuration required (if using the VirtualBox driver).
  * VirtualBox
    * https://www.virtualbox.org/wiki/Downloads
    * Ensure Intel VT or AMD-V is configured on the system.
    * Change the virtual machine default directory (optional).
2) Run `vagrant up` from this directory.
3) Wait.
4) Login using `vagrant ssh`.
5) When done, run `vagrant destroy` to tear-down the machine once again.

**Tip!** If running under Windows, a command-line compatible SSH client is required to be in the user's path, or things will fail. 'Git Bash' from https://git-scm.com/downloads works well for this, just make sure that all commands are run inside of 'Git Bash' instead of PowerShell or CMD.

## Problems?

Raise a GitHub issue, or fix it and raise a PR :)

## Additional Reading

See the kako project documentation at the following URL:

* https://www.github.com/darkarnium/kako/
