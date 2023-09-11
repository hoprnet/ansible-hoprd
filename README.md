# Ansible Role for Hoprd

Configures a server with a hoprd instance running in Docker compose

Requirements
------------

This role does not have any requirement

Role Variables
--------------

How to install Linux on Dedicated server
```
    - name: "Setup Hoprd"
      ansible.builtin.include_role:
        name: hopr.hoprd
      vars::
        hoprd_identity_file: /path/to/identity_file/.hoprd.id
        hoprd_env_file: /path/to/identity_file/.env
        hoprd_version: 2.0.0-rc.2
```


Dependencies
------------

None

License
-------

MIT