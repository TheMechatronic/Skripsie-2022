""" 
BLE and FTMS UUIDs
"""

__author__ = "DC Eksteen"
__contact__ = "22623906@sun.ac.za"
__credits__ = ["Dr G. Venter", "PunchThrough"]
__date__ = "2022/04/16"
__email__ =  "gventer@sun.ac.za"
__version__ = "0.0.1"

"""
UUID's get calculated by adding:
UUID from 16-bit UUID Numbers Document to the BLE base UUID 
Base UUID = 00000000-0000-1000-8000-00805f9b34fb

UUID numbers Document: 
https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf
"""

class SERVICES(object):
    __slots__ = ()
    GAP = '00001800-0000-1000-8000-00805f9b34fb'
    FTMS = '00001826-0000-1000-8000-00805f9b34fb'
    CYCLING_POWER = '00001818-0000-1000-8000-00805f9b34fb'
    HEARTRATE = '0000180d-0000-1000-8000-00805f9b34fb'
    SPEED_CADENCE = '00001816-0000-1000-8000-00805f9b34fb'
    DEVICE_INFORMATION = '0000180a-0000-1000-8000-00805f9b34fb'

class CHARACTARISTICS(object):
    __slots__ = ()
    # Fitness Machine
    INDOOR_BIKE_DATA = '00002ad2-0000-1000-8000-00805f9b34fb'
    FITNESS_MACHINE_CONTROL_POINT = '00002ad9-0000-1000-8000-00805f9b34fb'
    FITNESS_MACHINE_FEATURE = '00002acc-0000-1000-8000-00805f9b34fb'
    SUPPORTED_RESISTANCE_LEVEL_RANGE = '00002ad6-0000-1000-8000-00805f9b34fb'
    SUPPORTED_POWER_RANGE = '00002ad8-0000-1000-8000-00805f9b34fb'
    FITNESS_MACHINE_STATUS = '00002ada-0000-1000-8000-00805f9b34fb'

    # Cycling Power
    CYCLING_POWER_MEASUREMENT = '00002a63-0000-1000-8000-00805f9b34fb'
    CYCLING_POWER_FEATURE = '00002a65-0000-1000-8000-00805f9b34fb'
    CYCLING_POWER_CONTROL_POINT = '00002a66-0000-1000-8000-00805f9b34fb' 

    # Heart Rate
    HEART_RATE_MEASUREMENT = '00002a37-0000-1000-8000-00805f9b34fb'

    # Cycling Speed and Cadence
    SPEED_CADENCE_MEASUREMENT = '00002a5b-0000-1000-8000-00805f9b34fb'
    SPEED_CADENCE_FEATURE = '00002a5c-0000-1000-8000-00805f9b34fb'
    SPEED_CADENCE_CONTROL_POINT = '00002a55 -0000-1000-8000-00805f9b34fb'

    # Device Information
    MANUFACTURER_NAME_STRING = '00002a29-0000-1000-8000-00805f9b34fb'
    MODEL_NUMBER_SRING = '00002a24-0000-1000-8000-00805f9b34fb'
    FIRMWARE_REVISION_STRING = '00002a26-0000-1000-8000-00805f9b34fb'