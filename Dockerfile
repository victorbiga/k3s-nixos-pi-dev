FROM nixos/nix as builder

WORKDIR /sd-image

# Arguments
ARG NODE_NAME
ENV NODE_NAME=${NODE_NAME}

# Copy files
COPY flake.nix .
COPY flake.lock .
COPY shared/ ./shared/
COPY nodes/ ./nodes/

# Build the SD image
RUN nix --extra-experimental-features nix-command --extra-experimental-features flakes build ".#nixosConfigurations.${NODE_NAME}.config.system.build.sdImage"

# --- Final Stage ---
FROM nixos/nix

WORKDIR /sd-image

# Copy the built image and the entrypoint script from the builder stage
COPY --from=builder /sd-image/result ./
COPY entrypoint.sh .

# Set the entrypoint
ENTRYPOINT ["./entrypoint.sh"]
