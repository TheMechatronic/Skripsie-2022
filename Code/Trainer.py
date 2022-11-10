#!/usr/bin/env python3

"""
Zwift enabled smart trainer source code
"""

__author__ = "DC Eksteen"
__contact__ = "22623906@sun.ac.za"
__credits__ = ["Dr G. Venter"]
__date__ = "2022/11/10"
__email__ =  "gventer@sun.ac.za"
__version__ = "1.0"

####################################################
# Includes
####################################################
import dbus
import dbus.exceptions
import dbus.mainloop.glib
import dbus.service
import uuids
import sys
import array
import logging
from threading import Event, Thread
import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BCM)

####################################################
# GLib Mainloop
####################################################
MainLoop = None
# Get new version if availible:
try:
    from gi.repository import GLib
    MainLoop = GLib.MainLoop
except ImportError:
    import gobject as GObject
    MainLoop = GObject.MainLoop

####################################################
# Logger Setup
####################################################
# Log events to logs.log file
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

####################################################
# DBus Objects and Instances Declarations
####################################################
DBUS_OM_IFACE = "org.freedesktop.DBus.ObjectManager"
DBUS_PROP_IFACE = "org.freedesktop.DBus.Properties"

GATT_SERVICE_IFACE = "org.bluez.GattService1"
GATT_CHRC_IFACE = "org.bluez.GattCharacteristic1"
GATT_DESC_IFACE = "org.bluez.GattDescriptor1"

LE_ADVERTISING_MANAGER_IFACE = "org.bluez.LEAdvertisingManager1"
LE_ADVERTISEMENT_IFACE = "org.bluez.LEAdvertisement1"

BLUEZ_SERVICE_NAME = "org.bluez"
GATT_MANAGER_IFACE = "org.bluez.GattManager1"

BLUEZ_SERVICE_NAME = "org.bluez"
GATT_MANAGER_IFACE = "org.bluez.GattManager1"
LE_ADVERTISEMENT_IFACE = "org.bluez.LEAdvertisement1"
LE_ADVERTISING_MANAGER_IFACE = "org.bluez.LEAdvertisingManager1"

####################################################
# GPIO pin setup
####################################################
class RepeatedTimer:

    """Repeat `function` every `interval` seconds."""

    def __init__(self, interval, function, *args, **kwargs):
        self.interval = interval
        self.function = function
        self.args = args
        self.kwargs = kwargs
        self.start = time.time()
        self.event = Event()
        self.thread = Thread(target=self._target)
        self.thread.start()

    def _target(self):
        while not self.event.wait(self._time):
            self.function(*self.args, **self.kwargs)

    @property
    def _time(self):
        return self.interval - ((time.time() - self.start) % self.interval)

    def stop(self):
        self.event.set()
        self.thread.join()

class commonData:
    total_Resistance = 10
    speed_kph = 0

    def __init__(self):
        self.total_Resistance = 10
        self.speed_kph = 0

    def newResistance(self, Res):
        self.total_Resistance = Res

    def getResistance(self):
        return self.total_Resistance

    def newSpeed(self, Speed):
        self.speed_kph = Speed

    def getSpeed(self):
        return self.speed_kph

CommonData = commonData

class SpeedSensors(CommonData):
    FrontSensorPin = 27
    RearSensorPin = 17
    FrontSegments = 10
    RearSegments = 10
    FrontCount = 0
    RearCount = 0
    CalcTime = 1
    LastCalc = 0
    DrumDiameter = 0.09
    kph = 0
    RearRPM = 0

    def __init__(self):
        GPIO.setmode(GPIO.BCM)


        GPIO.setup(self.FrontSensorPin, GPIO.IN, pull_up_down = GPIO.PUD_OFF)
        GPIO.setup(self.RearSensorPin, GPIO.IN, pull_up_down = GPIO.PUD_OFF)

        GPIO.add_event_detect(self.FrontSensorPin, GPIO.RISING, self.my_callback_Front, 40)
        GPIO.add_event_detect(self.RearSensorPin, GPIO.RISING, self.my_callback_Rear)

        self.CalcTimer = RepeatedTimer(self.CalcTime, self.SpeedCalc, ())
        logger.info('Speed Sensors Initialized')

    def my_callback_Front(self, channel):
        self.FrontCount += 1
        logger.info(self.FrontCount)

    def my_callback_Rear(self, channel):
        self.RearCount += 1

    def SpeedCalc(self, ops):
        Period = time.time() - self.LastCalc
        self.LastCalc = time.time()
        self.FrontRPM = 60 * self.FrontCount / (self.FrontSegments * Period)
        self.RearRPM = 60 * self.RearCount / (self.RearSegments * Period)
        self.kph = 0.1885 * self.RearRPM * self.DrumDiameter
        CommonData.newSpeed(CommonData, self.kph)
        self.FrontCount = 0
        self.RearCount = 0

class motorControl:
    """
    Control of the motor and possible limmit switch
    """
    dir_pin = 26
    stp_pin = 20
    en_pin = 12
    switch_pin = 3
    pos = 0
    move_range = 360/8
    logger.info('move range:' + repr(move_range))

    def __init__(self):
        GPIO.setup(self.en_pin, GPIO.OUT)
        GPIO.setup(self.dir_pin, GPIO.OUT)
        GPIO.setup(self.stp_pin, GPIO.OUT)
        GPIO.setup(self.switch_pin, GPIO.IN, pull_up_down = GPIO.PUD_UP)
        GPIO.output(self.en_pin, GPIO.LOW)
        GPIO.output(self.dir_pin, GPIO.LOW)
        while GPIO.input(self.switch_pin):
            GPIO.output(self.stp_pin, GPIO.HIGH)
            time.sleep(0.02)
            GPIO.output(self.stp_pin, GPIO.LOW)
            time.sleep(0.02)
        GPIO.output(self.dir_pin, GPIO.HIGH)
        time.sleep(2)
        for i in range(8*15):
            GPIO.output(self.stp_pin, GPIO.HIGH)
            time.sleep(0.02)
            GPIO.output(self.stp_pin, GPIO.LOW)
            time.sleep(0.02)
        self.pos = 0

    def move(self, angle):
        """
        angle being the new position
        """
        if (angle < 0):
            angle = 0
        if (angle > self.pos):
            GPIO.output(self.dir_pin, GPIO.HIGH)
            for i in range((angle - self.pos)*15):
                    GPIO.output(self.stp_pin, GPIO.HIGH)
                    time.sleep(0.02)
                    GPIO.output(self.stp_pin, GPIO.LOW)
                    time.sleep(0.02)
        else:
            GPIO.output(self.dir_pin, GPIO.LOW)
            for i in range((angle - self.pos)*15):
                    GPIO.output(self.stp_pin, GPIO.HIGH)
                    time.sleep(0.02)
                    GPIO.output(self.stp_pin, GPIO.LOW)
                    time.sleep(0.02)
        self.pos = angle

####################################################
# Callbacks, Exceptions and Status Message Definitions
####################################################
class InvalidArgsException(dbus.exceptions.DBusException):
    _dbus_error_name = 'org.freedesktop.DBus.Error.InvalidArgs'

class NotSupportedException(dbus.exceptions.DBusException):
    _dbus_error_name = 'org.bluez.Error.NotSupported'

class NotPermittedException(dbus.exceptions.DBusException):
    _dbus_error_name = 'org.bluez.Error.NotPermitted'

class InvalidValueLengthException(dbus.exceptions.DBusException):
    _dbus_error_name = 'org.bluez.Error.InvalidValueLength'

class FailedException(dbus.exceptions.DBusException):
    _dbus_error_name = 'org.bluez.Error.Failed'

def register_ad_cb():
    logger.info("Advertisement registered")

def register_ad_error_cb(error):
    logger.critical("Failed to register advertisement: " + str(error))
    mainloop.quit()

def register_app_cb():
    logger.info('GATT application registered')

def register_app_error_cb(error):
    logger.critical('Failed to register application:' + str(error))
    mainloop.quit

####################################################
# Bluez BLE Function Class Definitions
####################################################
def find_adapter(bus):
    """
    Returns the first object in bluez service with a GattManager1 interface
    """
    remote_om = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, '/'), DBUS_OM_IFACE)
    objects = remote_om.GetManagedObjects()

    for o, props in objects.items():
        if GATT_MANAGER_IFACE in props.keys():
            return o

    return None

class Application(dbus.service.Object):
    """
    org.bluez.GattApplication1 interface implementation
    """

    def __init__(self, bus):
        self.path = "/"
        self.services = []
        dbus.service.Object.__init__(self, bus, self.path)

    def get_path(self):
        return dbus.ObjectPath(self.path)

    def add_service(self, service):
        self.services.append(service)

    @dbus.service.method(DBUS_OM_IFACE, out_signature="a{oa{sa{sv}}}")
    def GetManagedObjects(self):
        response = {}
        logger.info("GetManagedObjects")

        for service in self.services:
            response[service.get_path()] = service.get_properties()
            chrcs = service.get_characteristics()
            for chrc in chrcs:
                response[chrc.get_path()] = chrc.get_properties()
                descs = chrc.get_descriptors()
                for desc in descs:
                    response[desc.get_path()] = desc.get_properties()

        return response

class Service(dbus.service.Object):
    """
    org.bluez.GattService1 interface implementation
    """

    PATH_BASE = "/org/bluez/example/service"

    def __init__(self, bus, index, uuid, primary):
        self.path = self.PATH_BASE + str(index)
        self.bus = bus
        self.uuid = uuid
        self.primary = primary
        self.characteristics = []
        dbus.service.Object.__init__(self, bus, self.path)

    def get_properties(self):
        return {
            GATT_SERVICE_IFACE: {
                "UUID": self.uuid,
                "Primary": self.primary,
                "Characteristics": dbus.Array(
                    self.get_characteristic_paths(), signature="o"
                ),
            }
        }

    def get_path(self):
        return dbus.ObjectPath(self.path)

    def add_characteristic(self, characteristic):
        self.characteristics.append(characteristic)

    def get_characteristic_paths(self):
        result = []
        for chrc in self.characteristics:
            result.append(chrc.get_path())
        return result

    def get_characteristics(self):
        return self.characteristics

    @dbus.service.method(DBUS_PROP_IFACE, in_signature="s", out_signature="a{sv}")
    def GetAll(self, interface):
        if interface != GATT_SERVICE_IFACE:
            raise InvalidArgsException()

        return self.get_properties()[GATT_SERVICE_IFACE]


class Characteristic(dbus.service.Object):
    """
    org.bluez.GattCharacteristic1 interface implementation
    """

    def __init__(self, bus, index, uuid, flags, service):
        self.path = service.path + "/char" + str(index)
        self.bus = bus
        self.uuid = uuid
        self.service = service
        self.flags = flags
        self.descriptors = []
        dbus.service.Object.__init__(self, bus, self.path)

    def get_properties(self):
        return {
            GATT_CHRC_IFACE: {
                "Service": self.service.get_path(),
                "UUID": self.uuid,
                "Flags": self.flags,
                "Descriptors": dbus.Array(self.get_descriptor_paths(), signature="o"),
            }
        }

    def get_path(self):
        return dbus.ObjectPath(self.path)

    def add_descriptor(self, descriptor):
        self.descriptors.append(descriptor)

    def get_descriptor_paths(self):
        result = []
        for desc in self.descriptors:
            result.append(desc.get_path())
        return result

    def get_descriptors(self):
        return self.descriptors

    @dbus.service.method(DBUS_PROP_IFACE, in_signature="s", out_signature="a{sv}")
    def GetAll(self, interface):
        if interface != GATT_CHRC_IFACE:
            raise InvalidArgsException()

        return self.get_properties()[GATT_CHRC_IFACE]

    @dbus.service.method(GATT_CHRC_IFACE, in_signature="a{sv}", out_signature="ay")
    def ReadValue(self, options):
        logger.info("Default ReadValue called, returning error")
        raise NotSupportedException()

    @dbus.service.method(GATT_CHRC_IFACE, in_signature="aya{sv}")
    def WriteValue(self, value, options):
        logger.info("Default WriteValue called, returning error")
        raise NotSupportedException()

    @dbus.service.method(GATT_CHRC_IFACE)
    def StartNotify(self):
        logger.info("Default StartNotify called, returning error")
        raise NotSupportedException()

    @dbus.service.method(GATT_CHRC_IFACE)
    def StopNotify(self):
        logger.info("Default StopNotify called, returning error")
        raise NotSupportedException()

    @dbus.service.signal(DBUS_PROP_IFACE, signature="sa{sv}as")
    def PropertiesChanged(self, interface, changed, invalidated):
        pass

class Descriptor(dbus.service.Object):
    """
    org.bluez.GattDescriptor1 interface implementation
    """

    def __init__(self, bus, index, uuid, flags, characteristic):
        self.path = characteristic.path + "/desc" + str(index)
        self.bus = bus
        self.uuid = uuid
        self.flags = flags
        self.chrc = characteristic
        dbus.service.Object.__init__(self, bus, self.path)

    def get_properties(self):
        return {
            GATT_DESC_IFACE: {
                "Characteristic": self.chrc.get_path(),
                "UUID": self.uuid,
                "Flags": self.flags,
            }
        }

    def get_path(self):
        return dbus.ObjectPath(self.path)

    @dbus.service.method(DBUS_PROP_IFACE, in_signature="s", out_signature="a{sv}")
    def GetAll(self, interface):
        if interface != GATT_DESC_IFACE:
            raise InvalidArgsException()

        return self.get_properties()[GATT_DESC_IFACE]

    @dbus.service.method(GATT_DESC_IFACE, in_signature="a{sv}", out_signature="ay")
    def ReadValue(self, options):
        logger.info("Default ReadValue called, returning error")
        raise NotSupportedException()

    @dbus.service.method(GATT_DESC_IFACE, in_signature="aya{sv}")
    def WriteValue(self, value, options):
        logger.info("Default WriteValue called, returning error")
        raise NotSupportedException()

class Advertisement(dbus.service.Object):
    PATH_BASE = "/org/bluez/example/advertisement"

    def __init__(self, bus, index, advertising_type):
        self.path = self.PATH_BASE + str(index)
        self.bus = bus
        self.ad_type = advertising_type
        self.service_uuids = None
        self.manufacturer_data = None
        self.solicit_uuids = None
        self.service_data = None
        self.local_name = None
        self.include_tx_power = None
        self.data = None
        dbus.service.Object.__init__(self, bus, self.path)

    def get_properties(self):
        properties = dict()
        properties["Type"] = self.ad_type
        if self.service_uuids is not None:
            properties["ServiceUUIDs"] = dbus.Array(self.service_uuids, signature="s")
        if self.solicit_uuids is not None:
            properties["SolicitUUIDs"] = dbus.Array(self.solicit_uuids, signature="s")
        if self.manufacturer_data is not None:
            properties["ManufacturerData"] = dbus.Dictionary(
                self.manufacturer_data, signature="qv"
            )
        if self.service_data is not None:
            properties["ServiceData"] = dbus.Dictionary(
                self.service_data, signature="sv"
            )
        if self.local_name is not None:
            properties["LocalName"] = dbus.String(self.local_name)
        if self.include_tx_power is not None:
            properties["IncludeTxPower"] = dbus.Boolean(self.include_tx_power)

        if self.data is not None:
            properties["Data"] = dbus.Dictionary(self.data, signature="yv")
        return {LE_ADVERTISEMENT_IFACE: properties}

    def get_path(self):
        return dbus.ObjectPath(self.path)

    def add_service_uuid(self, uuid):
        if not self.service_uuids:
            self.service_uuids = []
        self.service_uuids.append(uuid)

    def add_solicit_uuid(self, uuid):
        if not self.solicit_uuids:
            self.solicit_uuids = []
        self.solicit_uuids.append(uuid)

    def add_manufacturer_data(self, manuf_code, data):
        if not self.manufacturer_data:
            self.manufacturer_data = dbus.Dictionary({}, signature="qv")
        self.manufacturer_data[manuf_code] = dbus.Array(data, signature="y")

    def add_service_data(self, uuid, data):
        if not self.service_data:
            self.service_data = dbus.Dictionary({}, signature="sv")
        self.service_data[uuid] = dbus.Array(data, signature="y")

    def add_local_name(self, name):
        if not self.local_name:
            self.local_name = ""
        self.local_name = dbus.String(name)

    def add_data(self, ad_type, data):
        if not self.data:
            self.data = dbus.Dictionary({}, signature="yv")
        self.data[ad_type] = dbus.Array(data, signature="y")

    @dbus.service.method(DBUS_PROP_IFACE, in_signature="s", out_signature="a{sv}")
    def GetAll(self, interface):
        logger.info("GetAll")
        if interface != LE_ADVERTISEMENT_IFACE:
            raise InvalidArgsException()
        logger.info("returning props")
        return self.get_properties()[LE_ADVERTISEMENT_IFACE]

    @dbus.service.method(LE_ADVERTISEMENT_IFACE, in_signature="", out_signature="")
    def Release(self):
        logger.info("%s: Released!" % self.path)


AGENT_INTERFACE = "org.bluez.Agent1"

def ask(prompt):
    try:
        return raw_input(prompt)
    except:
        return input(prompt)


def set_trusted(path):
    props = dbus.Interface(
        bus.get_object("org.bluez", path), "org.freedesktop.DBus.Properties"
    )
    props.Set("org.bluez.Device1", "Trusted", True)


def dev_connect(path):
    dev = dbus.Interface(bus.get_object("org.bluez", path), "org.bluez.Device1")
    dev.Connect()


class Rejected(dbus.DBusException):
    _dbus_error_name = "org.bluez.Error.Rejected"


class Agent(dbus.service.Object):
    exit_on_release = True

    def set_exit_on_release(self, exit_on_release):
        self.exit_on_release = exit_on_release

    @dbus.service.method(AGENT_INTERFACE, in_signature="", out_signature="")
    def Release(self):
        logger.info("Release")
        if self.exit_on_release:
            mainloop.quit()

    @dbus.service.method(AGENT_INTERFACE, in_signature="os", out_signature="")
    def AuthorizeService(self, device, uuid):
        logger.info("AuthorizeService (%s, %s)" % (device, uuid))
        authorize = ask("Authorize connection (yes/no): ")
        if authorize == "yes":
            return
        raise Rejected("Connection rejected by user")

    @dbus.service.method(AGENT_INTERFACE, in_signature="o", out_signature="s")
    def RequestPinCode(self, device):
        logger.info("RequestPinCode (%s)" % (device))
        set_trusted(device)
        return ask("Enter PIN Code: ")

    @dbus.service.method(AGENT_INTERFACE, in_signature="o", out_signature="u")
    def RequestPasskey(self, device):
        logger.info("RequestPasskey (%s)" % (device))
        set_trusted(device)
        passkey = ask("Enter passkey: ")
        return dbus.UInt32(passkey)

    @dbus.service.method(AGENT_INTERFACE, in_signature="ouq", out_signature="")
    def DisplayPasskey(self, device, passkey, entered):
        logger.info("DisplayPasskey (%s, %06u entered %u)" % (device, passkey, entered))

    @dbus.service.method(AGENT_INTERFACE, in_signature="os", out_signature="")
    def DisplayPinCode(self, device, pincode):
        logger.info("DisplayPinCode (%s, %s)" % (device, pincode))

    @dbus.service.method(AGENT_INTERFACE, in_signature="ou", out_signature="")
    def RequestConfirmation(self, device, passkey):
        logger.info("RequestConfirmation (%s, %06d)" % (device, passkey))
        confirm = ask("Confirm passkey (yes/no): ")
        if confirm == "yes":
            set_trusted(device)
            return
        raise Rejected("Passkey doesn't match")

    @dbus.service.method(AGENT_INTERFACE, in_signature="o", out_signature="")
    def RequestAuthorization(self, device):
        logger.info("RequestAuthorization (%s)" % (device))
        auth = ask("Authorize? (yes/no): ")
        if auth == "yes":
            return
        raise Rejected("Pairing rejected")

    @dbus.service.method(AGENT_INTERFACE, in_signature="", out_signature="")
    def Cancel(self):
        logger.info("Cancel")


####################################################
# FTMS Service and Charactaristic Initialization
####################################################
class ftmsService(Service):
    """
    FTMS service for controlable fitness machine
    see Fitness Machine Service Specofocation
    https://www.bluetooth.org/DocMan/handlers/DownloadDoc.ashx?doc_id=423422
    """
    FTMS_UUID = uuids.SERVICES.FTMS

    def __init__(self, bus, index):
        Service.__init__(self, bus, index, self.FTMS_UUID, True)
        # Add the used charactaristics here:
        self.add_characteristic(FitnessMachineFeatureCharadctaristic(bus, 0, self))
        self.add_characteristic(IndoorBikeDataCharacteristic(bus, 1, self))
        self.add_characteristic(FitnessMachineControlPointCharactaristic(bus, 2, self))

class FitnessMachineFeatureCharadctaristic(Characteristic):
    """
    Information on the supported features on the fitness machine.
    see https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/fmf-0000001050145124
    """
    FTF_UUID = uuids.CHARACTARISTICS.FITNESS_MACHINE_FEATURE
    description = b"Fitness Machine Feature Charactaristic"

    average_speed_supported = 1
    cadence_supported = 1
    total_distance_supported = 0
    inclination_supported = 0
    elevation_gain_supported = 0
    pace_supported = 0
    step_count_supported = 0
    resistance_level_supported = 0
    stride_count_supported = 0
    expended_energy_supported = 0
    metabolic_equivalent_supported = 0
    elapsed_time_supported = 0
    remaining_time_supported = 0
    power_measurement_supported = 1
    force_on_belt_and_power_output_supported = 0
    user_data_retention_supported = 0

    features_flag = 0x00000000
    features_flag |= average_speed_supported << 0
    features_flag |= cadence_supported << 1
    features_flag |= power_measurement_supported << 14
    logger.info(bin(features_flag))

    indoor_bike_simulation_supported = 1

    target_flag = 0x00000000
    target_flag |= indoor_bike_simulation_supported << 13


    def __init__(self, bus, index, service):
        Characteristic.__init__(self, bus, index, self.FTF_UUID, ["read"], service)
        self.value = []
        self.value.append(dbus.Byte(0x00))
        self.value.append(dbus.Byte(0x00))
        self.value.append(dbus.Byte((self.features_flag) & 0xff))
        self.value.append(dbus.Byte((self.features_flag >> 8) & 0xff))
        self.value.append(dbus.Byte(0x00))
        self.value.append(dbus.Byte(0x00))
        self.value.append(dbus.Byte(self.target_flag & 0xff))
        self.value.append(dbus.Byte((self.target_flag >> 8) & 0xff))

        self.add_descriptor(CharacteristicUserDescriptionDescriptor(bus, 1, self))

    def ReadValue(self, options):
        logger.info("Fitness Machine Feature read:" + repr(self.value))
        return self.value

class IndoorBikeDataCharacteristic(Characteristic, SpeedSensors, CommonData):
    """
    Sets live bike data: Updated every 1 sec
    """
    uuid = uuids.CHARACTARISTICS.INDOOR_BIKE_DATA
    description = b"Indoor Bike Data Charactaristic "

    instantanious_speed = 0
    # 0 - uint16 - 0.01 kph
    average_speed = 1
    # 1 - uint 16 - 0.01 kph
    instantanious_cadence = 1
    # 2 - uint16 - 0.5 /min
    average_cadence = 0
    # 3 - uint16 - 0.5 /min
    instantanious_power = 1
    # 6 - sint16 - 1 watt
    average_power = 0
    # 7 - sint16 - 1 watt

    flag = 0x0000
    flag |= instantanious_speed << 0
    flag |= average_speed << 1
    flag |= instantanious_cadence << 2
    flag |= average_cadence << 3
    flag |= instantanious_power << 6
    flag |= average_power << 7
    # 16 bit

    testPower = 10
    testAveragePower = 120
    testCadence = 80
    testAverageCadence = 90
    testAverageSpeed = 12

    def __init__(self, bus, index, service):
        Characteristic.__init__(self, bus, index, self.uuid, ['notify'], service)
        self.add_descriptor(CharacteristicUserDescriptionDescriptor(bus, 1, self))
        self.notifying = False
        self.spd = SpeedSensors()

    def bike_data_cb(self):
        value = []

        # Flags
        value.append(dbus.Byte(self.flag & 0xff))
        value.append(dbus.Byte((self.flag >> 8) & 0xff))
        logger.info('Speed Update: ' + repr(round(self.spd.kph,2)))

        # MSO - Instantanious Speed
        value.append(dbus.Byte(int(round(self.spd.kph,2) * 100) & 0xff))
        value.append(dbus.Byte((int(round(self.spd.kph,2) * 100) >> 8) & 0xff))
        # Average Speed
        if self.average_speed:
            value.append(dbus.Byte(int(self.spd.kph * 100) & 0xff))
            value.append(dbus.Byte((int(self.spd.kph * 100) >> 8) & 0xff))
        # Instantanious Cadence
        if self.instantanious_cadence:
            value.append(dbus.Byte(int(self.testCadence * 2) & 0xff))
            value.append(dbus.Byte(int(self.testCadence * 2) >> 8) & 0xff)
        # Average Cadence
        if self.average_cadence:
            value.append(dbus.Byte(int(self.testAverageCadence ) & 0xff))
            value.append(dbus.Byte((int(self.testAverageCadence ) >> 8) & 0xff))
        # Instantanious Power
        if self.instantanious_power:
            logger.info(repr(CommonData.getResistance(CommonData)))
            value.append(dbus.Byte(int(self.spd.kph * CommonData.getResistance(CommonData)) & 0xff))
            value.append(dbus.Byte((int(self.spd.kph * CommonData.getResistance(CommonData)) >> 8) & 0xff))
        # Average Power
        if self.average_power:
            value.append(dbus.Byte((int(self.testAveragePower * 1)) & 0xff))
            value.append(dbus.Byte((int(self.testAveragePower * 1) >> 8) & 0xff))
        # Average Speed

        self.PropertiesChanged(GATT_CHRC_IFACE, { 'Value': value }, [])

        logger.info('Updated Bike Data Characteristic')
        return self.notifying

    def _update_bike_data(self):
        logger.info('Update Bike Data Characteristic')
        if not self.notifying:
            return

        GLib.timeout_add(1000, self.bike_data_cb)

    def StartNotify(self):
        if self.notifying:
            logger.info("Already Notifying")
            return

        self.notifying = True
        logger.info("Bike Data Notify Started")
        GLib.timeout_add(1000, self.bike_data_cb)
        self._update_bike_data

    def StopNotify(self):
        if not self.notifying:
            print("Not Notifying")
            return

        self.notifying = False

class FitnessMachineControlPointCharactaristic(Characteristic, CommonData):
    """
    Control of the machine:

    Request Command Structure:
    Op Code (uint8) + Parameter ...
    Response Structure:
    Response Op Code (uint8) + Request Op Code (uint8) + Result Code (uint8) + Response Parameters (...)
    """
    uuid = uuids.CHARACTARISTICS.FITNESS_MACHINE_CONTROL_POINT
    description = b"Fitness Machine Control Point "

    controllable = True
    # Request Codes:
    Request_control = 0x00
    # Response is 0x80 followed by appropriate parameter value
    Reset = 0x01
    # Reset the controllable settings of machine - Response is 0x80 and parameter
    Start_Resume = 0x07
    # Start or resume training session - Response 0x80 with Control Info parameter
    Stop_Pause = 0x08
    # Stop or Pause the training session - Response 0x80 with outcome
    Set_SIM_params = 0x11
    # Response is SIM param array and resp code 0x80
    Response_code = 0x80

    # Response Codes:
    Success_code = 0x01
    Not_Supported_code = 0x02
    Invalid_parameter_code = 0x03
    Operation_Failed_code = 0x04
    Control_Not_Premitted_code = 0x05

    # SIM parameters
    windSpeed = 1
    grade = 0
    temp_grade = 0
    cw = 1
    crr = 1

    # Initialize values
    Result = Success_code
    wind_resistance = 0
    gravitational_resistance = 0
    rolling_resistance = 0

    brakeControl = motorControl()

    def __init__(self, bus, index, service):
        Characteristic.__init__(self, bus, index, self.uuid, ['indicate', 'write'], service)
        self.controllable = True
        self.out_q = None
        self.opCode = 0x00
        self.add_descriptor(CharacteristicUserDescriptionDescriptor(bus, 1, self))

    def WriteValue(self, value, options):
        self.value = value
        self.opCode = value[0] & 0xff
        logger.info('Control Point Write Received: ' + repr(self.value))

        self.GetOperation(CommonData)
        return value

    def GetOperation(self, CommonData):
        logger.info('Op Code Received: ' + repr(self.opCode))
        if self.opCode == self.Request_control:
            self.ControlRequest()
        elif self.opCode == self.Reset:
            self.ResetMachine()
        elif self.opCode == self.Start_Resume:
            self.StartResume()
        elif self.opCode == self.Stop_Pause:
            self.StopPause()
        elif self.opCode == self.Set_SIM_params:
            self.SIMparams(CommonData)

    def ControlRequest(self):
        """
        Control remainse valid until: Connection terminated, FMS Status set to Control Permission Lost or Reset initiated by Client
        """
        if self.controllable:
            logger.info('ControlRequest: Control Granted')
            self.Result = self.Success_code
            self._resp_cb()
            self.controllable = True
            return

        logger.info('ControlRequest: Control Denied')
        self.Result = self.Control_Not_Premitted_code
        self._resp_cb()

    def ResetMachine(self):
        logger.info('Reset Command Received')
        self.controllable = True
        self.Result = self.Success_code
        self._resp_cb()

    def StartResume(self):
        logger.info('Start Resume Command Received')
        self.Result = self.Success_code
        self._resp_cb()

    def StopPause(self):
        logger.info('Stop Pause Command Received')
        self.Result = self.Success_code
        self._resp_cb()

    def SIMparams(self, CommonData):
        """
        Breaks if SIM parameters are not properly received
        Currently no limits set ...
        """
        logger.info('SIM parameters received:')
        self.windSpeed = (self.value[2] << 8) + self.value[1]
        self.temp_grade = (self.value[4] << 8) + self.value[3]
        if (self.temp_grade & (1 << (16 - 1))) != 0:
            self.temp_grade = self.temp_grade - (1 << 16)
            self.temp_grade = 0
        logger.info(repr(self.temp_grade))
        self.grade = self.temp_grade
        self.brakeControl.move(self.grade/100 * 2)
        self.crr = self.value[5] & 0xff
        self.cw = self.value[6] & 0xff
        logger.info('Wind Speed: ' + repr(self.windSpeed/1000) + ' mps  Grade: ' + repr(self.grade/100) + ' %  crr: ' + repr(self.crr/1000) + '  cw: ' + repr(self.cw/100) + ' kg/m')
        self._windResistance(CommonData)
        self._gravResistance()
        self._rollingResistance()
        self._totalResistance(CommonData)
        self.Result = self.Success_code
        logger.info('Done with SIM update')
        self._resp_cb()

    def StartNotify(self):
        logger.info('Notify Control Point Started')
        self._resp_cb()
        logger.info('Successfull StartNotify')
        return

    def _resp_cb(self):
        logger.info('Controll Point response callback')
        self.value = []
        self.value.append(dbus.Byte(self.Response_code))
        self.value.append(dbus.Byte(self.opCode))
        self.value.append(dbus.Byte(self.Result))
        if self.opCode == self.Set_SIM_params:
            self.value.append(dbus.Byte(self.windSpeed & 0xff))
            self.value.append(dbus.Byte((self.windSpeed >> 8) & 0xff))
            self.value.append(dbus.Byte(self.temp_grade & 0xff))
            self.value.append(dbus.Byte((self.temp_grade >> 8) & 0xff))
            self.value.append(dbus.Byte(self.crr & 0xff))
            self.value.append(dbus.Byte(self.cw & 0xff))
            logger.info('SIM parameter array reponse triggered')
        self.PropertiesChanged(GATT_CHRC_IFACE, {'Value': self.value}, [])
        logger.info('Controll Point response sent:')
        return

    def _windResistance(self, CommonData):
        # F (N) = 0.5 * airDensity * A * cw * v^2
        self.wind_resistance = 0.5 * 1.204 * 0.4 * (self.cw/100) * ((CommonData.getSpeed(CommonData)/3.6) + (self.windSpeed/1000))**2
        logger.info('Wind Resistance Calculated: ' + repr(self.wind_resistance))

    def _gravResistance(self):
        self.gravitational_resistance = 9.81 * ((self.grade/100)/100) * 80
        logger.info('Gravitational Resistance Calculated: ' + repr(self.gravitational_resistance))

    def _rollingResistance(self):
        self.rolling_resistance = 80 * 9.81 * self.crr/10000
        logger.info('Rolling Resistance Calculated: ' + repr(self.rolling_resistance))

    def _totalResistance(self, CommonData):
        CommonData.newResistance(CommonData, self.wind_resistance + self.gravitational_resistance + self.rolling_resistance)
        logger.info('Total Resistance Calculated: ' + repr(CommonData.getResistance(CommonData)))

class CharacteristicUserDescriptionDescriptor(Descriptor):
    """
    Writable CUD descriptor.
    """

    CUD_UUID = "2901"

    def __init__(self, bus, index, characteristic):
        self.value = array.array("B", characteristic.description)
        self.value = self.value.tolist()
        Descriptor.__init__(self, bus, index, self.CUD_UUID, ["read"], characteristic)

    def ReadValue(self, options):
        return self.value

    def WriteValue(self, value, options):
        if not self.writable:
            raise NotPermittedException()
        self.value = value

class FTMSAdvertisement(Advertisement):
    def __init__(self, bus, index):
        Advertisement.__init__(self, bus, index, "peripheral")
        self.add_service_uuid(ftmsService.FTMS_UUID)
        self.add_local_name("22623906 FTMS")
        self.include_tx_power = True
        self.add_service_data(ftmsService.FTMS_UUID, [0x01])


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
    app.add_service(ftmsService(bus, 0))

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

if __name__ == '__main__':
    main()