#!/usr/bin/env bash

nixos-rebuild switch \
    --flake .#joshuabaker \
    --target-host joshuabaker.me \
    --elevate=sudo
