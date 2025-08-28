#!/bin/sh

set -e

# Find the built image and save its path and size to files
IMAGE_FILE_PATH=$(find "$(readlink result)" -type f -name '*.img.zst')
IMAGE_SIZE=$(du -h "${IMAGE_FILE_PATH}" | awk '{print $1}')

# Print the output
echo '✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨'
echo '✨ Your NixOS SD image is ready!  ✨'
echo '✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨'
echo ""
echo "The image file is located at:"
echo "${IMAGE_FILE_PATH} inside this container."
echo ""
echo "The compressed image size is: ~${IMAGE_SIZE}"
echo ""
echo "To copy it to your host, run this command in your terminal:"
echo ""
echo "docker cp $HOSTNAME:${IMAGE_FILE_PATH} ."
echo ""
echo "Happy flashing! 🚀"
