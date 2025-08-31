# Meal Back 🥓

![alt text](/assets/images/image.png)

## Cloning Project

1. Clone this repo

   ```bash
   git clone git@github.com:LeonardoLopesHonda/meal-back.git
   ```

---

## Setting up your machine (Ubuntu - WSL)

1. First install the android-studio

   ```bash
   sudo apt install android-studio
   ```

> Follow the expo [docs](https://docs.expo.dev/workflow/android-studio-emulator)

2. Now set the PATH to `android-sdk`

   ```bash
   nano ~/.bashrc
   ```

3. Write on the end of `.bashrc`:

   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/emulator
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   ```

4. Now install these packages:

   ```bash
   sudo apt install -y automake build-essential libtool libssl-dev watchman
   ```

5. Open a device emulator on android studio

[Device Manager - Android Studio](/assets/images/device-manager.png)

> If you're facing permission problems follow [this](https://stackoverflow.com/a/45749003/19612959)

---

## Starting Project

1. Install dependencies

   ```bash
   npm install
   ```

2. Start the app

   ```bash
   npx expo start
   ```
