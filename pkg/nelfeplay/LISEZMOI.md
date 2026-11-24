# RetroArch 1.22.2, build NelfePlay

Cette branche est la stable **RetroArch 1.22.2** (tag `v1.22.2`, commit `69a4f0e`) plus quelques correctifs de l'amont
(libretro/RetroArch), repris tels quels, un par problème constaté sur nos bornes. Rien d'autre n'est changé : même
version annoncée (`1.22.2`), même format de replay (BSV v2), mêmes DLL que la RetroArch 1.22.2 distribuée par
RetroBat. Seule la ligne « Git » de `--version` porte le suffixe (`69a4f0e-nelfeplay.N`).

Sources publiées pour respecter la GPLv3 de RetroArch (fichier `COPYING` à la racine).

## Correctifs

Lot 1 (`nelfeplay.1`, branche `nelfeplay/1.22.2-lot1`) :

| Commit amont | Objet | Problème chez nous |
|---|---|---|
| 8a8cc448b9 (#19136) | Fix replay seek while recording v2 | plantage de l'encodeur de points de contrôle du replay sur un gros état (`msvcrt.dll` 0xC0000005 +7b289) |
| 68e8274a31 (#18585) | null pointer on command_get_status | plantage au premier `GET_STATUS` d'un cœur sans `systemid` |
| 5fa3573d88 | trans_stream_pipe: rd, wn and err are optional | plantage de l'hôte netplay quand un pair négocie sans compression |

Lot 3 (`nelfeplay.2`, branche `nelfeplay/1.22.2-lot3`, au-dessus du lot 1) : rétroportage de 0afe7f41d1 (#19870,
« netplay: record confirmed multi-player input in BSV replays »), 4c5cb57668 et 235c50847b : en netplay, le replay
enregistre les entrées CONFIRMÉES de tous les joueurs (et non plus la seule manette locale, en avance de la latence).
Traduction pour la 1.22.2 décrite dans le message du commit.

## Compilation (Windows, MSYS2 MINGW64)

Chaîne : MSYS2, environnement `mingw64` (msvcrt, comme l'exe officiel), gcc 16.2, make. Sans Qt. libgcc et libstdc++
liées en statique. Les bibliothèques d'import sont tirées DES DLL de RetroArch 1.22.2 de RetroBat (l'éditeur de liens
refuse ainsi toute fonction absente des DLL que l'exe trouvera) :

- FFmpeg 4.2.3 (en-têtes de `ffmpeg-4.2.3.tar.xz`, sha256 `9df6c90a...`) ; DLL avcodec-58, avformat-58, avdevice-58,
  avutil-56, swresample-3, swscale-5 ;
- SDL2 2.0.14 (`SDL2-devel-2.0.14-mingw.tar.gz`, sha256 `405eaff3...`) ; DLL SDL2.dll 2.0.14 ;
- FreeType 2.10.4 (en-têtes de `freetype-2.10.4.tar.xz`, sha256 `86a854d8...`) ; DLL libfreetype-6.dll.

```
python -I pkg/nelfeplay/preparer_deps.py <deps> <dossier des DLL de RetroArch 1.22.2>
bash pkg/nelfeplay/configurer.sh          # ./configure --disable-qt --disable-ssa --enable-builtinzlib ...
# gcc 14+ fait des erreurs de trois avertissements que le gcc 10 du buildbot laissait passer (en-tetes FFmpeg 4)
make -j6 GIT_VERSION=69a4f0e-nelfeplay.1 C99_CFLAGS="-std=gnu99 -Wno-error=incompatible-pointer-types \
  -Wno-error=int-conversion -Wno-error=implicit-function-declaration" \
  LDFLAGS="-L<deps>/statique -static-libgcc -static-libstdc++ -limm32"
# <deps>/statique ne contient que libstdc++.a, libpthread.a et libwinpthread.a de MSYS2 : Makefile.common ajoute
# -lstdc++, que l'editeur de liens resoudrait sinon par libstdc++.dll.a (libstdc++-6.dll de gcc 16 chez le joueur)
strip --strip-unneeded retroarch.exe
```

Le binaire n'est pas reproductible à l'octet (horodatages) : l'exe livré est celui qui a été essayé, son sha256 est
publié avec lui.
