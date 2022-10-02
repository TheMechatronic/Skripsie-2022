#!/usr/bin/env python3

"""
Zwift enabled smart trainer source code
"""

__author__ = "DC Eksteen"
__contact__ = "22623906@sun.ac.za"
__credits__ = ["Dr G. Venter", "PunchThrough (Github)"]
__date__ = "2022/04/16"
__email__ =  "gventer@sun.ac.za"
__version__ = "0.0.1"

####################################################
# Includes
####################################################
import logging
import uuids
import trainerProperties

import dbus
import dbus.exceptions
import dbus.mainloop.glib
import dbus.service

##### Custom Libraries:
from ble import (
    Advertisement,
    Characteristic,
    Service,
    Application,
    find_adapter,
    Descriptor,
    Agent,
)
import uuids

##### Standard Libraries
import struct
import requests
import array
from enum import Enum
import sys
import threading

##### Initialize GLib
MainLoop = None
try:
    from gi.repository import GLib

    MainLoop = GLib.MainLoop
except ImportError:
    import gobject as GObject

    MainLoop = GObject.MainLoop

##### Logger setup and initialization
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
logHandler = logging.StreamHandler()
filelogHandler = logging.FileHandler("logs.log")
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logHandler.setFormatter(formatter)
filelogHandler.setFormatter(formatter)
logger.addHandler(filelogHandler)
logger.addHandler(logHandler)

mainloop = None

#### Constant Definitions
BLUEZ_SERVICE_NAME = "org.bluez"
GATT_MANAGER_IFACE = "org.bluez.GattManager1"
LE_ADVERTISEMENT_IFACE = "org.bluez.LEAdvertisement1"
LE_ADVERTISING_MANAGER_IFACE = "org.bluez.LEAdvertisingManager1"
GATT_CHRC_IFACE = "org.bluez.GattCharacteristic1"

####################################################
# Exception and Error Handlers
####################################################

class InvalidArgsException(dbus.exceptions.DBusException):
    _dbus_error_name = "org.freedesktop.DBus.Error.InvalidArgs"


class NotSupportedException(dbus.exceptions.DBusException):
    _dbus_error_name = "org.bluez.Error.NotSupported"


class NotPermittedException(dbus.exceptions.DBusException):
    _dbus_error_name = "org.bluez.Error.NotPermitted"


class InvalidValueLengthException(dbus.exceptions.DBusException):
    _dbus_error_name = "org.bluez.Error.InvalidValueLength"


class FailedException(dbus.exceptions.DBusException):
    _dbus_error_name = "org.bluez.Error.Failed"

##### Application Registration Callbacks
def register_app_cb():
    logger.info("GATT application registered successfully")

def register_app_error_cb(error):
    logger.critical("Failed to register application: " + str(error))
    mainloop.quit()

####################################################
# FTMS Service and Charactaristic Initialization
####################################################
class ftms_Service(Service):
    """
    FTMS service for controlable fitness machine

    see Fitness Machine Service Specofocation
    https://www.bluetooth.org/DocMan/handlers/DownloadDoc.ashx?doc_id=423422
    """

    UUID = uuids.SERVICES.FTMS

    def __init__(self, bus, index):
        Service.__init__(self, bus, index, self.UUID, True)
        ######
        # Add charactaristics here ...
        # Fitness Machine Feature
        # Power Data
        ######
        # self.add_characteristic(FitnessMachineFeatureCharacteristic(bus, 3, self))
        # slf.add_characteristic(IndoorBikeDataCharacteristic(bus, 1, self))
        # self.add_characteristic(AutoOffCharacteristic(bus, 2, self))

class FitnessMachineFeatureCharadctaristic(Characteristic):
    """
    Information on the supported features on the fitness machine.
    see https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/fmf-0000001050145124
    """
    uuid = uuids.CHARACTARISTICS.FITNESS_MACHINE_FEATURE
    description = b"Fitness Machine Feature Charactaristic"

    def __init__(self, bus, index, service):
        Characteristic.__init__(self, bus, index, self.uuid, ["read"], service)
        self.value = [0x00000000]
        self.add_descriptor(CharacteristicUserDescriptionDescriptor(bus, 1, self))

    def ReadValue(self, options):
        logger.debug("Fitness Machine Feature read:" + repr(self.value))
        return self.value

class IndoorBikeDataCharacteristic(Characteristic):
    uuid = uuids.CHARACTARISTICS.INDOOR_BIKE_DATA
    description = b"Indoor Bike Data Charactaristic "


    def __init__(self, bus, index, service):
        Characteristic.__init__(self, bus, index, self.uuid, ["notify"], service,)
        self.flags = [0x0000 | 0b1000000] # Change for new supported features ...
        # 0b1000000 = Power and speed
        self.value = [0x0000, 0x0000] # size depends on number of set params
        self.add_descriptor(CharacteristicUserDescriptionDescriptor(bus, 1, self))
        self.notifying = False

    def notify_bike_data(self):
        if not self.notifying:
            return
        self.PropertiesChanged(GATT_CHRC_IFACE,)

    def StartNotify(self, options):
        
        logger.debug("Indoor Bike Data Notify:" + repr(self.value))

        return self.value

    def WriteValue(self, value, options):
        logger.debug("power Write: " + repr(value))
        cmd = bytes(value).decode("utf-8")
        if self.State.has_value(cmd):
            # write it to machine
            logger.info("writing {cmd} to machine")
            data = {"cmd": cmd.lower()}
            try:
                res = requests.post(VivaldiBaseUrl + "/vivaldi/cmds", json=data)
            except Exceptions as e:
                logger.error(f"Error updating machine state: {e}")
        else:
            logger.info(f"invalid state written {cmd}")
            raise NotPermittedException

        self.value = value

#class AutoOffCharacteristic(Characteristic):
#    uuid = "9c7dbce8-de5f-4168-89dd-74f04f4e5842"
#    description = b"Get/set autoff time in minutes"
#
#    def __init__(self, bus, index, service):
#        Characteristic.__init__(
#            self, bus, index, self.uuid, ["secure-read", "secure-write"], service,
#        )
#
#        self.value = []
#        self.add_descriptor(CharacteristicUserDescriptionDescriptor(bus, 1, self))
#
#    def ReadValue(self, options):
#        logger.info("auto off read: " + repr(self.value))
#        res = None
#        try:
#            res = requests.get(VivaldiBaseUrl + "/vivaldi")
#            self.value = bytearray(struct.pack("i", int(res.json()["autoOffMinutes"])))
#        except Exception as e:
#            logger.error(f"Error getting status {e}")
#
#        return self.value
#
#    def WriteValue(self, value, options):
#        logger.info("auto off write: " + repr(value))
#        cmd = bytes(value)
#
#        # write it to machine
#        logger.info("writing {cmd} to machine")
#        data = {"cmd": "autoOffMinutes", "time": struct.unpack("i", cmd)[0]}
#        try:
#            res = requests.post(VivaldiBaseUrl + "/vivaldi/cmds", json=data)
#            logger.info(res)
#        except Exceptions as e:
#            logger.error(f"Error updating machine state: {e}")
#            raise
#
#
class CharacteristicUserDescriptionDescriptor(Descriptor):
    """
    Writable CUD descriptor.
    """

    CUD_UUID = "2901"

    def __init__(
        self, bus, index, characteristic,
    ):

        self.value = array.array("B", characteristic.description)
        self.value = self.value.tolist()
        Descriptor.__init__(self, bus, index, self.CUD_UUID, ["read"], characteristic)

    def ReadValue(self, options):
        return self.value

    def WriteValue(self, value, options):
        if not self.writable:
            raise NotPermittedException()
        self.value = value

#####
# Create Advertisement for Application
#####
class FTMSAdvertisement(Advertisement):
    def __init__(self, bus, index):
        Advertisement.__init__(self, bus, index, "peripheral",base_path = "/com/trainer/advertisement/roller")
        self.add_service_uuid(ftms_Service.UUID)
        self.add_local_name("FTMS")
        self.include_tx_power = True

# Successfull registration call back
def register_ad_cb():
    logger.info("Advertisement registered")

def register_ad_error_cb(error):
    logger.critical("Failed to register advertisement: " + str(error))
    mainloop.quit()


AGENT_PATH = "/com/trainer/agent"


def main():
    global mainloop

    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    # get the system bus
    bus = dbus.SystemBus()
    logger.info(bus.get_object)

    # get the ble controller location from system bus
    adapter = find_adapter(bus)
    logger.info(adapter)

    # system configuration error
    if not adapter:
        logger.critical("GattManager1 interface not found")
        return

    adapter_obj = bus.get_object(BLUEZ_SERVICE_NAME, adapter)
    # logger.info(adapter_obj)

    adapter_props = dbus.Interface(adapter_obj, "org.freedesktop.DBus.Properties")
    # logger.info(adapter_props)

    # powered property on the controller to on
    adapter_props.Set("org.bluez.Adapter1", "Powered", dbus.Boolean(1))



    # Get manager objs
    service_manager = dbus.Interface(adapter_obj, GATT_MANAGER_IFACE)
    ad_manager = dbus.Interface(adapter_obj, LE_ADVERTISING_MANAGER_IFACE)

    advertisement = FTMSAdvertisement(bus, 0)
    obj = bus.get_object(BLUEZ_SERVICE_NAME, "/org/bluez")

    agent = Agent(bus, AGENT_PATH)

    app = Application(bus)
    app.add_service(ftms_Service(bus, 2))

    mainloop = MainLoop()

    agent_manager = dbus.Interface(obj, "org.bluez.AgentManager1")
    agent_manager.RegisterAgent(AGENT_PATH, "NoInputNoOutput")

    ad_manager.RegisterAdvertisement(
        advertisement.get_path(),
        {},
        reply_handler=register_ad_cb,
        error_handler=register_ad_error_cb,
    )

    logger.info("Registering GATT application...")

    service_manager.RegisterApplication(
        app.get_path(),
        {},
        reply_handler=register_app_cb,
        error_handler=[register_app_error_cb],
    )

    agent_manager.RequestDefaultAgent(AGENT_PATH)

    # ad_manager.UnregisterAdvertisement(advertisement)
    # dbus.service.Object.remove_from_connection(advertisement)

    mainloop.run()
    ad_manager.UnregisterAdvertisement(advertisement)
    dbus.service.Object.remove_from_connection(advertisement)


if __name__ == "__main__":
    main()