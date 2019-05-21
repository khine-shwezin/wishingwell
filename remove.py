import os

ext = "json"
n = 0
for root, dir, files in os.walk("."):
  for cFile in files:
    if cFile.endswith(ext):
      print(cFile)
      os.remove(os.path.join(root, cFile))
      n += 1

print("Completed!"+str(n)+" files has been deleted.")