import dbus
import dbus.mainloop.glib
from gi.repository import GLib
import subprocess
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Constants for checking headset class
AUDIO_VIDEO_MAJOR_CLASS = 0x04
HEADSET_MINOR_CLASS = 0x18

def check_device_class(device_class):
    # Extract the major and minor classes from device_class
    major_class = (device_class >> 8) & 0x1F
    minor_class = device_class & 0x3F

    is_headset = major_class == AUDIO_VIDEO_MAJOR_CLASS and minor_class == HEADSET_MINOR_CLASS
    # logging.info(f"Device class check: major_class={major_class}, minor_class={minor_class}, is_headset={is_headset}")
    return is_headset

def handle_property_changed(interface, changed, invalidated, path):
    if "Connected" in changed:
        device_connected = changed["Connected"]
        # logging.info(f"Connection status changed. Device path: {path}, Connected: {device_connected}")
        
        # Get device properties
        bus = dbus.SystemBus()
        device = bus.get_object("org.bluez", path)
        properties = dbus.Interface(device, "org.freedesktop.DBus.Properties")
        
        # Get the device class
        device_class = properties.Get("org.bluez.Device1", "Class")
        
        if check_device_class(device_class):
            if not device_connected:
                # logging.info("Headset disconnected, pausing music...")
                subprocess.run(["playerctl", "pause"])
            # else:
                # logging.info("Headset connected.")

def main():
    # logging.info("Starting Bluetooth headset disconnect listener...")
    
    # Initialize the dbus loop
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    # Connect to Bluetooth events
    bus.add_signal_receiver(
        handle_property_changed,
        bus_name="org.bluez",
        signal_name="PropertiesChanged",
        path_keyword="path"
    )

    # Run the loop
    loop = GLib.MainLoop()
    loop.run()

if __name__ == "__main__":
    main()
