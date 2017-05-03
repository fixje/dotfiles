#!/bin/bash
echo -ne "up: $(uptime | cut -f 4-5 -d ' ' | cut -f 1 -d ',') | load: $(uptime | sed 's/.*: \([0-9]\+[,\.][0-9]\+\),.*/\1/') | free: $(free -h | grep Mem | sed 's/Mem:\ *\([0-9,\.BKMBGTP]\+\)\ *\([0-9,\.BKMBGTP]\+\)\ *\([0-9,\.BKMBGTP]\+\).*/\3\/\1/') | cores: $(nproc)"
