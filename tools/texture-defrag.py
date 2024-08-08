#import pymeshlab
import os
import sys
import subprocess
import shutil

args = sys.argv[1:]
obj_to_merge = args[0]
name_of_model = args[1]

#pathname = os.path.dirname(obj_to_merge)
abspath = os.path.abspath(os.getcwd())
pathname = os.path.join(abspath, os.path.dirname(obj_to_merge))
output = os.path.join(pathname, name_of_model)
print(output)
subprocess.run(["/home/ubuntu/src/texture-defrag/build/texture-defrag", obj_to_merge, '-l', '2', '-o', output])
