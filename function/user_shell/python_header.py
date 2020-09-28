try:
    import requests,json
    import platform
    import sys

    PYTHON27 = "2.7"
    gPyVersion = platform.python_version()

    if PYTHON27 <= gPyVersion:
        print ("py version is true")
    else:
        print("This install script can not support python version: %s" % gPyVersion)
        sys.exit(1)
except ImportError as err:
    sys.exit("Unable to import module: %s." % str(err))
