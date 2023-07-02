# hypeit_nix
My home for my nixos experiments
## How to run it:

1. In fresh installation start with:
```bash
nix-shell -i git cachix
git clone --recurse-submodules https://github.com/hypeitnow/hypeit_nix.git
```
2. Run:
   
`hypeit_nix/nixos/scripts/disks.sh`

verify disk labels

then:

`hypeit_nix/nixos/scripts/hm.sh`

3. then do:

```bash
sudo rm -rf /etc/nixos
ln -svdf $PWD/hypeit_nix/nixos /etc/
```

4. You should ba able to run: 

```bash
nixos-rebuild switch
```
