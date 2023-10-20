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
        hoprd_version: 2.0.0-rc.10
        hoprd_network: rotsee
        hoprd_password: SomePassword
        hoprd_api_token: SomeAPI
        hoprd_safe_address: 0xf40224307B63dd5b2Dd166630d76dfC37bb78EeA
        hoprd_module_address: 0x0224307B63dd5b2Dd166630d76dfC37bb7eA8Ef4
```


Dependencies
------------

None

License
-------

MIT