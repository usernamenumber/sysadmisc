sysadmisc
=========

Miscellaneous sysadmin-y scripts and whatnot. See comments at the top of each script for descriptions.


Script | Description
-------|------------
`awslogs.sh` | View or tail slices of cloudwatch logs. See `-h` for details
`byobu-workspace` | Create or switch to a byobu session based on current repo+branch
`chkload.sh` | "What's using up resources on this machine?" 
`color_prompt.sh` | Give each machine a different color-coded prompt 
`custom_dmenu_run.py` | Add custom hooks to dmenu or rofi in i3
`gcal_remind` | Use [gcalcli](https://github.com/insanum/gcalcli) to emit libnotify reminders, but only once per event
`git-fcib` | Run `git fcib` to list all files ever changed in current branch
`git-history` | _(early draft)_ Walk through file history, including versions that have been squashed over
`git-s` | Run `git s` to see both uncommitted changes and unpushed commits
`git-safepush` | Run `git safepush` to check for squashing etc before pushing
`git-timemachine` | "When did the code on line X change from Y to Z?" *(save in your path, then you can invoke it as `git timemachine FILE [STARTLINE [ENDLINE]]`)* 
`git-wip` | Create one commit per modified file, then start an interactive rebase
`large_recent_files.sh` | "Why is my disk full again?" (simple one-liner that displays the 20 largest files in `~` that were modified in the last day)
`ppt2txt.py` | Quick and dirty script to extract the notes from a PowerPoint presentation 
`shorten_path.py` | convert long paths to short for custom prompts e.g. `/var/log/thingy/doodad` to `/v/l/t/doodad`.
`remind.sh` | quickly set a reminder for an absolute or relative time (requires system-notify)
