#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

s = "~/src/%s/"
a1 = arg[1]
os.execute((("mkdir -p %s;cd %s; toolbox run dnf download --source %s ; rpm2cpio *.rpm | cpio -idv"):format(s,s,a1):format(a1, a1)))
