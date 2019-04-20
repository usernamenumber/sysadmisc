#!/usr/bin/python

from sys import argv, stdin
from subprocess import call, PIPE, Popen
from re import match, sub
from argparse import ArgumentParser
from subprocess import Popen, PIPE

DEBUG=False
def dbg(s):
    if not DEBUG:
        return
    with file("/tmp/dmenu.log", "a") as f:
        f.write(s + "\n")
    print "DBG: %s" % s

def handle_cmd(cmd, accept_raw=True):
    cmd = cmd.strip()
    dbg("Handling %s" % cmd)
    # URL
    if match(r'https?://.+', cmd.strip()):
        cmd = cmd.split().pop(0)
        cmd = "firefox " + cmd
    # local file
    elif cmd.strip().startswith('/'):
        cmd = "open {}".format(cmd)
    # ssh
    elif cmd.strip().startswith('ssh '):
        cmd = "gnome-terminal -e '{}'".format(cmd.strip())
    # Don't run things not recognized by the above if -n was passed
    elif not accept_raw:
        cmd = None
    return cmd

def main():
    p = ArgumentParser()
    p.add_argument("-s", dest="shell", action='store_true')
    p.add_argument("-n", "--no-raw", dest="accept_raw", action='store_false')
    args = p.parse_args()

    if args.shell:
        inputs = stdin.readlines()
        for i in inputs:
            try:
                cmd = handle_cmd(i, args.accept_raw)
            except Exception as e:
                dbg(e)
                raise
            if cmd:
                dbg("Executing %s" % cmd)
                c = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE)
                out, err = c.communicate()
                if c.returncode > 0:
                    call(["notify-send", "Error running: {}:\n{}".format(cmd,err)])
            else:
                dbg("Skipping unrecognized raw command '{}'".format(i))

    else:
        dmenu_path = Popen(["dmenu_path"], stdout=PIPE)
        # dmenu replacement, rofi
        # https://github.com/DaveDavenport/rofi
        dmenu = Popen(["rofi", "-dmenu"], stdin=dmenu_path.stdout, stdout=PIPE)
        #dmenu = Popen(["dmenu"], stdin=dmenu_path.stdout, stdout=PIPE)
        Popen([argv[0], "-s"], stdin=dmenu.stdout)

if __name__ == "__main__":
    main()
