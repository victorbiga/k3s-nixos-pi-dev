#!/bin/sh

set -e

# Find the built image directly in the current directory (max depth 1 is key)
# Use 'find . -name' instead of relying on shell globbing, which can fail if no match exists.
IMAGE_FILE_PATH=$(find . -maxdepth 1 -type f -name '*.img.zst' | head -n 1)

# Check if the image file was found
if [ -z "${IMAGE_FILE_PATH}" ]; then
    echo "❌ Error: Could not find the built SD image file (*.img.zst) in the current directory."
    exit 1
fi

# Use the found path (e.g., './nixos-sd-image-....img.zst')
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
# Use basename to make the copy command cleaner
IMAGE_BASENAME=$(basename "${IMAGE_FILE_PATH}")
# Note: Use $HOSTNAME or the container ID/name when running this on the host.
echo ""
echo "docker cp \$(hostname):${IMAGE_FILE_PATH} ${IMAGE_BASENAME}"
echo ""
echo "Happy flashing! 🚀"
