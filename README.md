# Ansible Role for Hoprd

Configures a server with a hoprd instance running in Docker compose

Requirements
------------

This role does not have any requirement

Role Variables
--------------

How to install Linux
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
        hoprd_session_port_start: 10000
        hoprd_session_port_end: 11000
        hoprd_log_level: "info,libp2p_swarm=info,libp2p_mplex=info,multistream_select=info,isahc=error,sea_orm=warn,sqlx=warn,hyper_util=warn,libp2p_tcp=info,libp2p_dns=info,hickory_resolver=warn"
        hoprd_log_max_size: 1000M
        hoprd_resources_memory_requests: 1g
        hoprd_resources_memory_limits: 2g
```


Dependencies
------------

None

License
-------

MIT