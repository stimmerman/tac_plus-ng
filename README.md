# Tacacs+ for containerlab

The purpose of this container is to have a working TACACS server running in my containerlabs with some default configuration that makes sense for networking equipment.

It's based on tac_plus-ng for which you can find the [documentation here](https://projects.pro-bono-publico.de/event-driven-servers/doc/tac_plus-ng.html)

## Default configuration
When you run the container as is you will get the following:
 - Tacacs+ server running on port tcp/49
 - Any device with an IP in `172.16.0.0/12` can use the server with key: `labKey`

### User accounts
#### Admin
 - Username: admin
 - Password: admin
 - Privilege level 15, no `enable` password needed

#### Engineer
 - Username: engineer
 - Password: engineer
 - Privilege level 1
   - Can use up to `enable 5` without password
   - Can use `enable 14` with password: en14pass
   - Can use `enable 15` with it's login password: engineer
 - Is blocked from using the command `switchport trunk allowed vlan {$vlan}` and is directed to use `switchport trunk allowed vlan add` instead

### Logging

Can be found in the container in `/var/log/tac_plus`, easy way of tailing is: `tail -f /var/log/tac_plus/*.log`

## Overwriting the default configuration
You can start the container with your own tac_plus-ng configuration file like this:
## Docker
```
docker run -d --name tac_plus-ng -v ./tac_plus-ng.cfg:/usr/local/etc/tac_plus-ng.cfg stimmerman/tac_plus-ng:latest
```
## Containerlab
```
topology:
  nodes:
    tac_plus-ng:
      kind: linux
      image: stimmerman/tac_plus-ng:latest
      binds:
        - tac_plus-ng.cfg:/usr/local/etc/tac_plus-ng.cfg
```

# Example of using it in containerlab
## Topology file
```
name: aaa

mgmt:
  network: aaa-mgmt
  ipv4-subnet: 172.21.21.0/24

topology:
  nodes:
    tac_plus-ng:
      kind: linux
      image: stimmerman/tac_plus-ng:latest
      mgmt-ipv4: 172.21.21.10
    rtr1:
      kind: ceos
      image: ceos:4.31.2F
      mgmt-ipv4: 172.21.21.11
```

## Example Arista configuration
```
!
tacacs-server host 172.21.21.10 key 0 labKey
!
aaa authentication login default group tacacs+ local
aaa authentication enable default group tacacs+ local
aaa authorization commands all default group tacacs+ local
!
```