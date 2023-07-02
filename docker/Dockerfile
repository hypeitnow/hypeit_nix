# Start from the base Nix image
FROM nixos/nix:master

# Install packages
RUN nix-env -iA nixpkgs.coreutils-full  nixpkgs.which  nixpkgs.curl nixpkgs.python3 nixpkgs.git nixpkgs.nano nixpkgs.direnv nixpkgs.gnused nixpkgs.direnv nixpkgs.nix-direnv nixpkgs.zsh nixpkgs.oh-my-zsh nixpkgs.zsh-powerlevel10k nixpkgs.meslo-lgs-nf nixpkgs.zsh-syntax-highlighting nixpkgs.zsh-autocomplete nixpkgs.zsh-nix-shell
RUN nix-env -iA cachix -f https://cachix.org/api/v1/install

# Enable sandboxing
RUN echo 'sandbox = true' > /etc/nix/nix.conf
#Setup ohmyzsh
RUN cp -v /root/.nix-profile/share/oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc

RUN echo 'source /root/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /root/.zshrc
RUN echo 'source /root/.nix-profile/share/zsh-nix-shell/nix-shell.plugin.zsh' >> /root/.zshrc

# Set Build  Zsh path
ENV NIX_BUILD_SHELL="zsh"

# Set the entrypoint with ZSH_PATH
ENTRYPOINT ["zsh"]
