import os, os.path

def shorten_path(path, max=50):
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
	print shorten_path(d)
	print shorten_path(d, 40)
	print shorten_path(d, 30)
	print shorten_path(d, 20)
	print shorten_path(d, 10)
