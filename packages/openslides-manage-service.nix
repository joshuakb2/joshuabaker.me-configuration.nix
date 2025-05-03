{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "openslides-manage-service";
  src = fetchFromGitHub {
    owner = "OpenSlides";
    repo = name;
    rev = "a562a2be01429ad47cd6af9773c4b5d3a3764c58";
    hash = "sha256-pIiIpplZo+AcAVAqGVMeQyYHLDYMcjeimoter00ucYM=";
  };
  vendorHash = "sha256-8RJkq7htTgyyeRQQO4qhM/s4/kS1udoJowlWg+KsOT4=";
}
