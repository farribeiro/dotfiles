#!/usr/bin/env python

# SPDX-License-Identifier: GPL-2.0
# Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

import os


class Pyserver:
    def __init__(self):
        os.system("python -m http.server")


p = Pyserver()
