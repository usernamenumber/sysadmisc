#!/usr/bin/python
import os, os.path

def shorten_path(path, max=50, sub_home=True):
	if sub_home:
		home = os.path.realpath(os.getenv('HOME'))
		if home not in (None, ''):
			path = path.replace(home, '~')

	chars = len(path)
	if chars <= max:
		return path
	reduction_goal = chars - max

	components = path.split(os.path.sep)
	for i in range(len(components) - 1):
		component = components[i]
		if len(component) == 0:
			continue
		reduction_goal -= (len(component) - 1)
		components[i] = component[0]
		if reduction_goal <= 0:
			break
	return os.path.sep.join(components)

if __name__ == '__main__':
    d = os.getcwd()
    try:
        rows, columns = os.popen('stty size', 'r').read().split()
        max = max(int(columns) - 40, 1)
    except:
        max=50
    print shorten_path(d, max=max)
