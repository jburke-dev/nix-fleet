{ lib, ... }:
with lib;
rec {
  mkEthLink =
    name:
    (
      { mac, ... }@link:
      {
        matchConfig = {
          Type = "ether";
          MACAddress = mac;
        };
        linkConfig = {
          Name = name;
          # TODO: are RxBufferSize and TxBufferSize necessary?
        };
      }
    );
  vlanPrefix = { id, ... }@vlan: "10.${toString vlan.id}";
  vlanIp = { id, ... }@vlan: fragment: "${vlanPrefix vlan}.${fragment}";

  vlanSubnet = { id, cidr, ... }@vlan: "${vlanPrefix vlan}.0.0/${toString vlan.cidr}";

  vlanGateway = { id, ... }@vlan: (lanIp vlan "0.1");

  getHostIp = { vlanId, ipFragment, ... }: "${vlanPrefix { id = vlanId; }}.${ipFragment}";

  vlanDhcpPool =
    {
      id,
      dhcpMode,
      ...
    }@vlan:
    let
      prefix = vlanPrefix vlan;
      poolEnd = if dhcpMode == "static" then "${prefix}.0.254" else "${prefix}.255.254";
    in
    "${prefix}.0.2-${poolEnd}";
  getVlanInterfaceName = name: "vlan-${name}";
}
