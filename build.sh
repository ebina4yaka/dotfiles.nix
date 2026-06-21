#!/bin/bash

nix fmt
home-manager switch --flake ~/dotfiles
