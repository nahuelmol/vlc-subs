import os
import shutil
import sys
from dotenv import load_dotenv

def start():
    load_dotenv()
    src = "main.lua"
    dest = os.getenv("DEST")
    dest_path = os.path.join(dest, os.path.basename(src))

    shutil.copy2(src, dest_path) 

if __name__ == "__main__":
    start()
