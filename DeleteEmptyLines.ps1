﻿(gc file.txt) | ? {$_.trim() -ne "" } | set-content file.txt