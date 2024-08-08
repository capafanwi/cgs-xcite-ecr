import json
import os
import sys

def create_symlinks(images_file, config_json):
    # Open the JSON file
    with open(images_file, 'r') as file:
        symlink_list = json.load(file)

    symlink_folder = os.path.dirname(images_file)

    if symlink_list:
        with open(config_json, 'r') as config_file:
            config_data = json.load(config_file)
            input_folder = config_data.get('imagesFolder')

        if input_folder:
            input_path = os.path.join(os.path.dirname(config_json), input_folder)
            symlink_folder = os.path.join(symlink_folder, input_folder)
            # Create the output folder if it doesn't exist
            os.makedirs(symlink_folder, exist_ok=True)

            # Iterate through each item in the list and create a symlink
            for item in symlink_list:
                item = os.path.join(input_path, item)
                # Check if the item exists before creating the symlink
                if os.path.exists(item):
                    symlink_name = os.path.basename(item)  # Extracts the file name for the symlink
                    symlink_path = os.path.join(symlink_folder, symlink_name)
                    # Create a symlink to the item in the specified output folder
                    if os.path.exists(symlink_path):
                        print(f"Warning: Symlink {os.path.abspath(symlink_path)} already exists")
                        os.unlink(symlink_path)
                    os.symlink(os.path.abspath(item), symlink_path)
                    print(f"Created symlink for {item} as {symlink_path}")
                else:
                    print(f"Warning: File {item} does not exist to create symlink.")
        else:
            print("'imagesFolder' not found in the config file")
    else:
        print("No images found in the JSON file")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 create-image-symlinks.py input_files.json config.json")
    else:
        input_json = sys.argv[1]
        config_json = sys.argv[2]
        create_symlinks(input_json, config_json)
