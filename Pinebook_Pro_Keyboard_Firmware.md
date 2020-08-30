# Pinebook Pro keyboard and trackpad firmware

The trackpad firmware binary can be flashed from userspace using the provided open source utility [pinebook pro keyboard updater](https://github.com/ayufan-rock64/pinebook-pro-keyboard-updater). 

Everyone with a Pinebook Pro produced in 2019 should update their keyboard and trackpad firmware.

## Before you start

Please refer to original documentation for details.

Your Pinebook Pro should be either fully charged or, preferably, running of mains. This utility will be writing chips on the keyboard and trackpad, so a loss of power during any stage of the update can result in irrecoverable damage to your trackpad or keyboard.

The scripts ought to work on all OSs available for the Pinebook Pro. Some OSs may, however, require installation of relevant dependencies.

There are two keyboard versions of the Pinebook Pro, ISO and ANSI. You need to know which model you have prior to running the updater. FW update steps for both models are listed below.

## What you will need

* Your Pinebook Pro fully charged or running off of mains power

* Connection to WiFi

* An external USB keyboard & mouse. Or access to the Pinebebook Pro via SSH

## ISO Model

### Step 0

From the terminal command line:

```bash
git clone https://github.com/ayufan-rock64/pinebook-pro-keyboard-updater
cd pinebook-pro-keyboard-updater
sudo apt-get install build-essential libusb-1.0-0-dev xxd
make
```

### Step 1

```bash
cd pinebook-pro-keyboard-updater
sudo ./updater step-1 iso
sudo reboot
```

### Step 2 (after reboot)

```bash
cd pinebook-pro-keyboard-updater
sudo ./updater step-2 iso
sudo reboot
```

## ANSI Model

* **NOTE**: Running step-1 on the ansi keyboard model will make the keyboard and trackpad inaccessible until step-2 is run, so an external keyboard must be connected to complete the update on this model!

### Step 0

From the terminal command line:

```bash
git clone https://github.com/ayufan-rock64/pinebook-pro-keyboard-updater
cd pinebook-pro-keyboard-updater
sudo apt-get install build-essential libusb-1.0-0-dev xxd
make
```

### Step 1

```bash
cd pinebook-pro-keyboard-updater
sudo ./updater step-1 ansi
sudo reboot
```

### Step 2 (after reboot)

```bash
cd pinebook-pro-keyboard-updater
sudo ./updater step-2 ansi
sudo reboot
```

## Finish

When done, if some of the keys produce in-correct characters, please check your OSes' language settings. For ANSI users, the default OS shipped with English UK as the default language. You can change it to English US if desired. 



