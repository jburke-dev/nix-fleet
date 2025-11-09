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

  vlanGateway = { id, ... }@vlan: (vlanIp vlan "0.1");

  getNetworkInterface =
    name: network: if network.interface != null then network.interface else getVlanInterfaceName name;

  getHostIpFromNetwork =
    networks:
    { networkName, ipFragment, ... }:
    let
      network = networks.${networkName};
    in
    "${vlanPrefix network}.${ipFragment}";

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

  # IPv6 ULA helpers
  # ULA format: fd00:0:0:<vlan-id>::/64
  vlanPrefixV6 = { id, ... }@vlan: "fd00:0:0:${lib.toLower (lib.toHexString id)}";
  vlanIpV6 = { id, ... }@vlan: fragment: "${vlanPrefixV6 vlan}::${fragment}";

  vlanSubnetV6 = { id, ... }@vlan: "${vlanPrefixV6 vlan}::/64";

  vlanGatewayV6 = { id, ... }@vlan: "${vlanPrefixV6 vlan}::1";

  # Get host IPv6 from networkName instead of vlanId
  getHostIpV6FromNetwork =
    networks:
    { networkName, ipFragment, ... }:
    let
      network = networks.${networkName};
      v6Fragment = lib.replaceStrings [ "." ] [ ":" ] ipFragment;
    in
    "${vlanPrefixV6 network}:${v6Fragment}";

  mkBridgeNetwork = name: bridgeInterfaceName: {
    matchConfig.Name = name;
    networkConfig = {
      Bridge = bridgeInterfaceName;
    };
    linkConfig.RequiredForOnline = "enslaved";
    bridgeConfig = {
      HairPin = false;
      FastLeave = true;
      Cost = 4;
    };
  };

  mkBondChildNetwork = name: bondInterfaceName: {
    matchConfig.Name = name;
    networkConfig.Bond = bondInterfaceName;
    linkConfig.RequiredForOnline = "enslaved";
  };
}
