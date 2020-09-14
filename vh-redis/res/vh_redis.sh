#!/bin/sh
################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################

set -e
CONTAINER_ID="$2"

# Run interpreter.py and see if output matches expected output
expect <<- DONE
  set timeout 45
  spawn vhc hub container -a "$CONTAINER_ID" "/bin/sh -i"
  expect {
    "/app \$ " { send "pwd\r" }
    timeout { exit 1 }
  }
  send "./interpreter.py\r"
  expect {
    ">*" { send "(+ 2 3)\r" }
    timeout { exit 1 }
  }
  expect {
    "5*>*" { send "(define square (lambda x (* x x)))\r" }
    timeout { exit 1 }
  }
  expect {
    "<__main__.Function object at 0x*>*" { send "(square 5)\r" }
    timeout { exit 1 }
  }
  expect {
    "25*>*" { send "quit\r" }
    timeout { exit 1 }
  }
  send "exit\r"
  expect eof
DONE

if [ "$?" -ne 0 ]; then
  exit 1
else
  exit 0
fi
