import os

from pydub import AudioSegment


FOLDER_NAME = "HUMANITY - Thomas Bergersen"
for i in list(os.walk(FOLDER_NAME))[0][2]:
    file_name = os.path.join("HUMANITY - Thomas Bergersen", i)
    audio = AudioSegment.from_file(file_name, format="m4a")
    audio.export(filename.replace(".m4a", ".mp3"), format="mp3")
    print(f"Finished: {filename}\n")
