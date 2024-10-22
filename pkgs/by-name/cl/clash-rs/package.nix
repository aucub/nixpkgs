{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
}:
rustPlatform.buildRustPackage rec {
  pname = "clash-rs";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    rev = "v${version}";
    hash = "sha256-fDIy6FmsRF1Ak1odZ37nIHqV6PjoZVd33Ph1DFznScU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boringtun-0.6.0" = "sha256-HBNo53b+CpCGmTXZYH4NBBvNmekyaBKAk1pSRzZdavg=";
      "netstack-lwip-0.3.4" = "sha256-lcauDyaw5gAaECRcGNXQDHbWmnyxil18qWFkZ/p/C50=";
      "rustls-0.23.12" = "sha256-grt94JG44MljRQRooVZbXL4h4XLI1/KoIdwGv03MoIU=";
      "tokio-rustls-0.26.0" = "sha256-Bmi36j8hbR4kkY/xnHbluaInk+YH5/eTln0VYfHulGA=";
      "tracing-oslog-0.2.0" = "sha256-JYaCslbVOgsyBhjeBkplPWcjSgFccjr4s6OAGIUu5kg=";
      "tuic-1.3.1" = "sha256-WMd+O2UEu0AEI+gNeQtdBhEgIB8LPanoIpMcDAUUWrM=";
      "tun-0.6.1" = "sha256-j4yQSu4Mw7DBFak8vJGQomYq81+pfaeEDdN4NNBve+E=";
      "unix-udp-sock-0.7.0" = "sha256-TekBfaxecFPpOfq7PVjLHwc0uIp3yJGV/Cgav5VfKaA=";
    };
  };

  env.PROTOC = "${protobuf}/bin/protoc";

  meta = {
    description = "custom protocol network proxy";
    homepage = "https://github.com/Watfaq/clash-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aucub ];
  };
}
