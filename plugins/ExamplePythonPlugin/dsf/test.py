#!/usr/bin/env python3

"""
Example to create a custom GET endpoint at http://duet3/machine/TestPython/RandomInt

Make sure when running this script to have access to the DSF UNIX socket owned by the dsf user.
"""

import time

from dsf.connections import CommandConnection
from dsf.commands.basecommands import HttpEndpointType
from dsf.http import HttpEndpointConnection
import random

async def respond_something(http_endpoint_connection: HttpEndpointConnection):
    await http_endpoint_connection.read_request()
    await http_endpoint_connection.send_response(200, str(random.randint(0, 99999)))
    http_endpoint_connection.close()


def custom_http_endpoint():
    cmd_conn = CommandConnection(debug=True)
    cmd_conn.connect()
    endpoint = None

    # Setup the endpoint
    endpoint = cmd_conn.add_http_endpoint(HttpEndpointType.GET, "TestPython", "RandomInt")
    # Register our handler to reply on requests
    endpoint.set_endpoint_handler(respond_something)

    print("Try accessing http://duet3/machine/custom/getIt in your browser...")

    return cmd_conn, endpoint


if __name__ == "__main__":
    try:
        cmd_conn, endpoint = custom_http_endpoint()
        # This just simulates doing other things as the new endpoint handler runs async
        while True:
            time.sleep(1800)
    finally:
        if endpoint is not None:
            endpoint.close()
        cmd_conn.close()
