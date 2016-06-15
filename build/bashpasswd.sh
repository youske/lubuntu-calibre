#!/bin/bash -eu
bash_passwd()
{
  RANGE={$1:-8}; echo `cat /dev/urandom | tr -dc 'a-zA-Z0-9' fold -w ${RANGE} | head -n 1 `
}
