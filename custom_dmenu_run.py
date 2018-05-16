#!/usr/bin/python

# Add to .i3/config like this:
## win+space to launch normally
# bindsym $mod+space exec custom_dmenu_run.py
## win+o to send highlighted text through the script
# bindsym $mod+o exec xclip -o | custom_dmenu_run.py -s

from sys import argv, stdin
from subprocess import call
from re import match, sub
from argparse import ArgumentParser
from subprocess import Popen, PIPE

p = ArgumentParser()
p.add_argument("-s", dest="shell", action='store_true')
args = p.parse_args()

if args.shell:
    for cmd in stdin.readlines():
        cmd = cmd.strip()
        # URL
        if match(r'https?://.+', cmd.strip()):
            cmd = "firefox " + cmd
        # local file
        elif cmd.strip().startswith('/'):
            cmd = "open "+ cmd
        # ssh
        elif cmd.strip().startswith('ssh '):
            cmd = "gnome-terminal -e '{}'".format(cmd.strip())
        call(cmd, shell=True)

else:
    dmenu_path = Popen(["dmenu_path"], stdout=PIPE)
    # dmenu replacement, rofi
    # https://github.com/DaveDavenport/rofi
    dmenu = Popen(["rofi", "-dmenu"], stdin=dmenu_path.stdout, stdout=PIPE)
    #dmenu = Popen(["dmenu"], stdin=dmenu_path.stdout, stdout=PIPE)
    Popen([argv[0], "-s"], stdin=dmenu.stdout)

