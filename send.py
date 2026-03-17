import os
import shutil
import sys
from dotenv import load_dotenv

def start():
    load_dotenv()
    src = "main.lua"
    dest = os.getenv("DEST")
    dest_path = os.path.join(dest, os.path.basename(src))

    try:
        shutil.copy2(src, dest_path) 
        print("File copied!")
    except PermissionError:
        print("Access denied! Please copy the file opening the cmd with administrator privilegies.")
    except Exception as e:
        print("Other error: ", e)

if __name__ == "__main__":
    start()
