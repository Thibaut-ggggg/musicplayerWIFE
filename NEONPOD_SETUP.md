# NeonPod — Y2K Edition 💚💗

A lime-green / glossy Y2K theme for [MacPod](https://github.com/ymolodtsov/macpod), the macOS floating iPod music controller. This is **source code**, not a ready-to-run Mac application.

## What's customized

- New **Neon Green · Y2K** theme in **Settings → Color**, preselected on a fresh install.
- First-generation iPod Nano: neon-gradient enclosure, pearly wheel, pink center button, dark-green LCD, pink/lime-striped progress, candy-gloss highlights.
- Sixth-generation iPod Nano: neon-metallic frame, pink-tinted controls and progress, green/black empty-album screen.
- Custom neon-green/pink application icon, generated from a single 1024px PNG (`Resources/NeonPod-master.png`) during the build.
- App is branded **NeonPod.app** with a separate bundle identifier, so it does not overwrite the original MacPod app.
- Original **White**, **Black**, and **Follow System** color modes remain available.
- Music controls, album art, transport, panel movement and playback logic are preserved from upstream.

## Workflow: Acer Windows laptop → GitHub → MacBook Neo

### A. On your Acer (Windows)

1. Extract the supplied ZIP (`NeonPod-Y2K-Lite.zip`) using Windows Extract All.
2. Install **GitHub Desktop** from https://desktop.github.com/.
3. In GitHub Desktop, select **File → Add Local Repository → Choose...** and pick the extracted `NeonPod-Y2K-Lite` directory. If GitHub Desktop says it isn't a repository, choose **Create a repository here**.
4. Choose the repository name `NeonPod-Y2K-Lite`, and create the repository. If asked about a `.gitignore` file, keep the project's existing `.gitignore` (do not replace it).
5. Add all files, commit with a message like `Initial NeonPod Y2K theme`, then select **Publish repository**. If you're concerned about sharing your fork, make it **Private** (you can still clone it yourself on the Mac).
6. GitHub needs the extracted files, not just the ZIP as a single uploaded file. This project already includes the open-source MIT license and credits.

Alternatively, you can use Git in a terminal or drag the extracted files into GitHub's web Upload files screen, but GitHub Desktop is less confusing for beginners.

### B. On the MacBook Neo (macOS)

1. Open **Terminal** (Command + Space, search `Terminal`).
2. Install Xcode Command Line Tools if necessary:
   ```sh
   xcode-select --install
   ```
   Wait for installation to complete before proceeding.
3. On your GitHub repository page, click **Code → HTTPS** and copy the URL.
4. Download the source. Replace the placeholder URL with your actual repository URL:
   ```sh
   cd ~/Downloads
   git clone https://github.com/YOUR_USERNAME/NeonPod-Y2K-Lite.git
   cd NeonPod-Y2K-Lite
   ```
5. Compile and assemble your Mac app:
   ```sh
   bash Scripts/build-app.sh
   ```
   This uses Swift, then `iconutil`, and assembles/signs the app locally using the bundled media adapter.
6. Launch **your** version:
   ```sh
   open build/NeonPod.app
   ```
7. If it runs correctly, drag `build/NeonPod.app` into `/Applications` with Finder. macOS may ask for permission to open an app built locally. Review the app/source before approving.
8. Start music in Spotify or Apple Music. Click the play/pause menu-bar icon to access **Settings → Color → Neon Green · Y2K**. Choose **Settings → Shell** to switch between first and sixth generation designs.

### C. If GitHub Desktop causes symlink issues

This compact package includes only the required framework binary and Info.plist, without unnecessary symbolic links or upstream vendored build sources. The build script **recreates framework symlinks inside the built .app** before signing. This improves reliability when the source passes through Windows ZIP tools. Don't remove the adapter binary from `Resources/MediaRemoteAdapter.framework/Versions/A/`.

## Customize the colors later

Open `Sources/MacPod/NeonPalette.swift` in VS Code. The key colors are:

| Color | HEX |
|---|---|
| Lime casing | `#A7FF47` |
| Gloss reflection | `#D5FF80` |
| Deep green | `#172A14` |
| Dark display | `#070E08` |
| Bubblegum pink | `#FF79CA` |

After changing the colors, **commit/push** from Windows, **pull** on your Mac using `git pull`, and run `bash Scripts/build-app.sh` again.

## Notes and limitations

- **You cannot compile this macOS SwiftUI app on your Acer Windows laptop**; building requires macOS and Apple's SDKs.
- This source was syntax-parsed with a Swift compiler on Linux, but **not compiled or run using macOS SwiftUI**. The real app and Spotify integration must be tested on the MacBook Neo.
- Custom colors will not alter Spotify playback requirements or grant additional permissions.
- Original MacPod uses Apple's private MediaRemote integrations; compatibility can change with macOS updates.
- MIT-licensed MacPod project by its original creator. See `LICENSE` and the upstream README for credit.

## Troubleshooting

- **`xcode-select` errors**: wait for Command Line Tools installation; try `swift --version`.
- **`command not found: iconutil`**: the Apple developer tools installation may be incomplete. On recent macOS versions, iconutil is part of the platform tools.
- **`codesign` fails**: make sure the MediaRemoteAdapter framework's binary exists under `Resources/MediaRemoteAdapter.framework/Versions/A/` and that source files weren't omitted when publishing.
- **Mac app opens but no music**: play a song first, then allow media permissions if requested. MacPod relies on macOS Now Playing support.

## Why this GitHub-friendly Lite version has fewer files

This package trims documentation screenshots, duplicate icon sizes, the upstream vendored adapter *source*, and the old optional icon-generation script. It **retains** the complete Swift app, the prebuilt arm64/x86_64 MediaRemoteAdapter framework binary, its Info.plist, playback shim, license, and build script. The build script regenerates ten required icon sizes from one PNG on macOS using `sips` and `iconutil`. Do not remove the MediaRemoteAdapter binary.

This code has not been compiled/tested on macOS in this environment.
