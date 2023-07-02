sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz 
sudo nix-channel --update

sudo nix-env -iA cachix -f https://cachix.org/api/v1/install
sudo cachix authtoken 'eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJlZGU3OGYwZC0yOGExLTQ4YmMtOTVhZS1mMDk5OTA5ZjFkYzIiLCJzY29wZXMiOiJjYWNoZSJ9.J3De57Lrec7TU2MiQk24-Sg9mRELEI4J3d0IWPQm-tI'
sudo cachix use hypeitnow
sudo cachix watch-store hypeitnow
