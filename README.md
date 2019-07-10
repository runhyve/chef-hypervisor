## Provision bhyve hypervisor

Clone this repository and run installation script:
`sudo ./install.sh`
The script will install Chef and apply Cookbook on current host

After it's complete you can run tests:
`sudo ./test.sh`

## Configuration
Customization can be make in `hypervisor.json` file. Currently, there's only one option:

| Setting | Type | Default | Description |
|--- | --- | --- | --- |
| hypervisor.use_xip | bool | false | If enabled nginx will be configured to serve requests for hypervisor_ip.xip.io domain (eg. 192.168.2.122.xip.io). It can be helpful for testing or development in local networks. For production properly configured FQDN hostname and proper DNS records are required and use_xip. |

More information: https://gitlab.com/runhyve/vm-webhooks